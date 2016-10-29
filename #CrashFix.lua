local function Base64Encode(data)
  local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
  return ((data:gsub('.', function(x)
    local r,b='',x:byte()
    for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
    return r;
  end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
    if (#x < 6) then return '' end
    local c=0
    for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
    return b:sub(c+1,c+1)
  end)..({ '', '==', '=' })[#data%3+1])
end

local function AutoUpdater:Base64Decode(data)
  local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
  data = string.gsub(data, '[^'..b..'=]', '')
  return (data:gsub('.', function(x)
    if (x == '=') then return '' end
    local r,f='',(b:find(x)-1)
    for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
    return r;
  end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
    if (#x ~= 8) then return '' end
    local c=0
    for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
    return string.char(c)
  end))
end

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
      file = file:sub(file:find('\r\n\r\n'),-1)
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
