function GetWebResultAsync(url, callback, UseHttps)
  local UseHttps = UseHttps or true
  local url = url:gsub("https://", ""):gsub("http://", "")
  local file = ""
  local GotResult = false
  local socket = require("socket").tcp()
  socket:connect('gamingonsteroids.com', 80)
  socket:send("GET "..'/GOS/TCPUpdater/GetScript'..(UseHttps and '5' or '6')..'.php?script='..Base64Encode(url)..'&rand='..math.random(99999999).." HTTP/1.1\r\nHost: gamingonsteroids.com\r\n\r\n")
  socket:settimeout(0, 'b')
  socket:settimeout(99999999, 't')
  Callback.Add("Tick", function()
    if GotResult then return end
    s, status, partial = socket:receive(1024)
    file = file .. (s or partial)
    if file:find('</scr'..'ipt>') then
      GotResult = true
      socket:close()
      local a, b = file:find('\r\n\r\n')
      file = file:sub(a,-1)
      local i, ContentStart = file:find('<scr'..'ipt>')
      local ContentEnd = file:find('</scr'..'ipt>')
      if not ContentStart or not ContentEnd then return end
      if callback and type(callback) == 'function' then
        callback(Base64Decode(file:sub(ContentStart + 1, ContentEnd - 1)))
      end
    end
  end)
end

function DownloadFileAsync(url, path, callback)
  GetWebResultAsync(url, function(data) 
    local f = io.open(path,"w+b")
    f:write(data)
    f:close()
    if callback and type(callback) == 'function' then 
      callback() 
    end
  end)
end
