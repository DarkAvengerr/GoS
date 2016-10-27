function GetWebResultAsync(url, callback)
  url = url:gsub("https://", ""):gsub("http://", "")
  local GotResult = false
  local started = false
  local result = ""
  local socket = require("socket").tcp()
  socket:settimeout(0, 'b')
  socket:settimeout(99999999, 't')
  socket:connect('gamingonsteroids.com', 80)
  Callback.Add("Tick", function()
    if GotResult then return end
    s, status, partial = socket:receive(1024)
    if status == 'timeout' and not started then
      started = true
      socket:send("GET "..'/GOS/TCPUpdater/GetScript5.php?script='..Base64Encode(url)..'&rand='..math.random(99999999).." HTTP/1.1\r\nHost: gamingonsteroids.com\r\n\r\n")
    end
    result = result .. (s or partial)
    if result:find('</scr'..'ipt>') then
      result = result:sub(result:find('\r\n\r\n'),-1)
      local i, ContentStart = result:find('<scr'..'ipt>')
      local ContentEnd = result:find('</scr'..'ipt>')
      if not ContentStart or not ContentEnd then return end
      GotResult = true
      socket:close()
      socket = nil
      if callback and type(callback) == 'function' then
        callback(Base64Decode(result:sub(ContentStart + 1, ContentEnd - 1)))
      end
    end
  end)
end

function DownloadFileAsync(url, path, callback)
  url = url:gsub("https://", ""):gsub("http://", "")
  local filesize
  local GotFile = false
  local started = false
  local result = ""
  local socket = require("socket").tcp()
  socket:settimeout(0, 'b')
  socket:settimeout(99999999, 't')
  socket:connect('gamingonsteroids.com', 80)
  Callback.Add("Tick", function()
    if GotFile then return end
    s, status, partial = socket:receive(1024)
    if status == 'timeout' and not started then
      started = true
      socket:send("GET "..'/GOS/TCPUpdater/GetScript5.php?script='..Base64Encode(url)..'&rand='..math.random(99999999).." HTTP/1.1\r\nHost: gamingonsteroids.com\r\n\r\n")
    end
    result = result .. (s or partial)
    if result:find('</si'..'ze>') then
      if not filesize then
        filesize = tonumber(result:sub(result:find('<si'..'ze>')+6,result:find('</si'..'ze>')-1))
      end
    end
    if result:find('</scr'..'ipt>') then
      result = result:sub(result:find('\r\n\r\n'),-1)
      local file = ""
      for line,content in ipairs(result:split('\n')) do
        if content:len() > 5 then
          file = file..content
        end
      end
      local i, ContentStart = file:find('<scr'..'ipt>')
      local ContentEnd = file:find('</scr'..'ipt>')
      if not ContentStart or not ContentEnd then return end
      local newf = file:sub(ContentStart+1,ContentEnd-1):gsub('\r','')
      if newf:len() ~= filesize then return end
      local f = io.open(path,"w+b")
      f:write(Base64Decode(newf))
      f:close()
      GotFile = true
      socket:close()
      socket = nil
      if callback and type(callback) == 'function' then
        callback()
      end
    end
  end)
end
