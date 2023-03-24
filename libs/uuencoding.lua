--[[
    uuencoding.lua - A Lua 5.1 module for encoding and decoding strings to and from the uuencoding format.
    For more information on uuencoding, see: https://en.wikipedia.org/wiki/Uuencoding

    Usage:
      local uu = require "uuencoding"
      local encoded = uu.enc("Hello, World!")
      local decoded = uu.dec(encoded)
--]]

--// Helper functions.

-- Converts an 8-bit number (0-255) to a binary string.
local function bin_num(num)
  local r = ''
  for i = 8, 1, -1 do
    r=r.. ( 0 < (num % 2^i - num % 2^(i-1)) and '1' or '0')
  end
  return r
end

-- Encodes given string into a binary string.
local function bin_enc(str)
  return (str:gsub('.', function(x) return bin_num(x:byte()) end))
end

-- Decodes a string from given binary string.
local function bin_dec(str)
  local r = ''
  for i = 1, #str, 8 do
    r=r.. string.char(tonumber(str:sub(i, i+7), 2))
  end
  return r
end

--// The module itself.

-- A table of all the valid characters in a uuencoded string.
local uu_chars = { [0]='`', ['`']=0 }
for i = 1, 63 do
  local char = string.char(32 + i)
  uu_chars[i], uu_chars[char] = char, i
end

-- The main uu object containing the encoding and decoding functions.
local uu={}

-- Encodes a given string into uuencoded format.
-- str: The input string to be encoded.
-- Returns: The uuencoded string.
function uu.enc(str)
  local out = {}
  for p = 1, #str, 45 do
    local part = str:sub(p, p+44)
    local bin = bin_enc(part) .. (('0'):rep(8):rep((#part % 3==0) and 0 or (3-(#part % 3))))
    local enc = uu_chars[#part]
    for i=1, #bin, 6 do
      enc = enc.. (uu_chars[tonumber(bin:sub(i, i+5), 2)])
    end
    table.insert(out, enc)
  end
  return (table.concat(out, '\n') .. ('\n'..uu_chars[0]))
end

-- Decodes a given string from uuencoded format.
-- str: The uuencoded string to be decoded.
-- Returns: The decoded string.
function uu.dec(str)
  local out = {}
  for line in str:gmatch('[^\r\n]+') do
    local len_c, part = line:match('^([\96\33-M])([\32-\96]-)$')
    if len_c and part then
      local len = uu_chars[len_c]
      local bin = part:gsub('.', function(c)return (bin_num(uu_chars[c]):sub(-6)) end):sub(1, len*8)
      local dec = bin_dec(bin)
      table.insert(out, dec)
    end
  end
  return table.concat(out)
end

return uu
