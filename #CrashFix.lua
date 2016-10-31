function GetWebResultAsync(url, callback, UseHttps)
  local UseHttps = UseHttps ~= nil and UseHttps or true
  local url = url:gsub("https://", ""):gsub("http://", "")
  local GotResult = false
  local started = false
  local result = ""
  local socket = require("socket").tcp()
  socket:settimeout(0, 'b')
  socket:settimeout(99999999, 't')
  socket:connect('gamingonsteroids.com', 80)
  Callback.Add("Tick", function()
    if GotResult then return end
    local s, status, partial = socket:receive(1024)
    if status == 'timeout' and not started then
      started = true
      socket:send("GET "..'/GOS/TCPUpdater/GetScript'..(UseHttps and '5' or '6')..'.php?script='..Base64Encode(url)..'&rand='..math.random(99999999).." HTTP/1.1\r\nHost: gamingonsteroids.com\r\n\r\n")
    end
    result = result .. (s or partial)
    if result:find('</scr'..'ipt>') then
      local a,b = result:find('\r\n\r\n')
      result = result:sub(a,-1)
      local HeaderEnd, ContentStart = result:find('<scr'..'ipt>')
      local ContentEnd, _ = result:find('</scr'..'ipt>')
      if not ContentStart or not ContentEnd then return end
      if callback and type(callback) == 'function' then
        callback(Base64Decode(result:sub(ContentStart + 1, ContentEnd - 1)))
      end
      GotResult = true
      socket:close()
    end
  end)
end

function DownloadFileAsync(url, path, callback, UseHttps)
  local UseHttps = UseHttps ~= nil and UseHttps or true
  local url = url:gsub("https://", ""):gsub("http://", "")
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
    local s, status, partial = socket:receive(1024)
    if status == 'timeout' and not started then
      started = true
      socket:send("GET "..'/GOS/TCPUpdater/GetScript'..(UseHttps and '5' or '6')..'.php?script='..Base64Encode(url)..'&rand='..math.random(99999999).." HTTP/1.1\r\nHost: gamingonsteroids.com\r\n\r\n")
    end
    result = result .. (s or partial)
    if result:find('</si'..'ze>') then
      if not filesize then
        filesize = tonumber(result:sub(result:find('<si'..'ze>')+6,result:find('</si'..'ze>')-1))
      end
    end
    if result:find('</scr'..'ipt>') then
      local a,b = result:find('\r\n\r\n')
      result = result:sub(a,-1)
      local file = ""
      for line,content in ipairs(result:split('\n')) do
        if content:len() > 5 then
          file = file..content
        end
      end
      local HeaderEnd, ContentStart = file:find('<scr'..'ipt>')
      local ContentEnd, _ = file:find('</scr'..'ipt>')
      if not ContentStart or not ContentEnd then return end
      local newf = file:sub(ContentStart+1,ContentEnd-1):gsub('\r','')
      if newf:len() ~= filesize then return end
      local f = io.open(path,"w+b")
      f:write(Base64Decode(newf))
      f:close()
      if callback and type(callback) == 'function' then
        callback()
      end
      GotFile = true
      socket:close()
    end
  end)
end
