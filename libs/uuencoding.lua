--[[
    uuencoding.lua - A Lua 5.1 module for encoding and decoding strings to and from the uuencoding format.
    For more information on uuencoding, see: https://en.wikipedia.org/wiki/Uuencoding

    Usage:
      local uu = require "uuencoding"
      local encoded = uu.enc("Hello, World!")
      local decoded = uu.dec(encoded)
--]]

--// Easy Functions. Change for Compatibility.

-- A object containing FileSystem functions.
local fs = {}

-- Return whether the file was opened or not and the contents of the file, error message and error code if applicable.
-- path: File path to be read.
-- Returns: Boolean success, [File Contents | Error Message, Error Code]
function fs.readFile(path)
  local f, em, ec = io.open(path,'rb')
  if not f then return false, em, ec
  else
    local data = f:read('*a')
    f:close()
    return true, data
  end
end

-- Returns the path separator used in file paths
-- Returns: Path separator string ("/" for Linux, "\" for Windows)
function fs.pathSep()
  return ( os.tmpname():sub(1, 1) == '/' and '/' or '\\' )
end


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

-- Encodes a string into uuencoded format.
-- str: The input string to be encoded.
-- Returns: The uuencoded string.
function uu.enc(str)
  local out = {}
  -- Iterate through the input string in 45-byte chunks
  for p = 1, #str, 45 do
    local part = str:sub(p, p+44)
    -- Convert each chunk to binary and pad it with zeros to a multiple of 24 bits
    local bin = bin_enc(part) .. (('0'):rep(8):rep((#part % 3==0) and 0 or (3-(#part % 3))))
    -- Get the length character of the input data as the first character of the encoded line.
    local enc = uu_chars[#part]
    -- Convert the binary to uuencoding
    for i=1, #bin, 6 do
      enc = enc.. (uu_chars[tonumber(bin:sub(i, i+5), 2)])
    end
    table.insert(out, enc)
  end
  return (table.concat(out, '\n') .. ('\n'..uu_chars[0]))
end

-- Decodes a uuencoded string.
-- str: The uuencoded string to be decoded.
-- Returns: The decoded string.
function uu.dec(str)
  local out = {}
  -- Iterate through each line of the uuencoded string and extract the line length and data
  for line in str:gmatch('[^\r\n]+') do
    -- Check if length and data characters are present and valid.
    local len_c, part = line:match('^([\96\33-M])([\32-\96]-)$')
    if len_c and part then
      local len = uu_chars[len_c]
      -- Convert given data part to binary and remove padding zeroes.
      local bin = part:gsub('.', function(c)return (bin_num(uu_chars[c]):sub(-6)) end):sub(1, len*8)
      local dec = bin_dec(bin)
      table.insert(out, dec)
    end
  end
  -- Concatenate all the decoded lines and return the resulting string.
  return table.concat(out)
end

-- Encodes a file into uuencoded format.
-- path: The path of the file to be encoded.
-- perm: The file permissions in octal (e.g. "644"). Defaults to "644" if not provided.
-- Returns: The uuencoded file string.
function uu.encFile(path, perm)
  -- Set default permissions and ensure perm is a string containing a valid octal number
  if type(perm) ~= 'string' or #perm > 3 or not perm:match('^[0-7]+$') then perm = '644' end
  perm = (perm .. (('000'):sub(#perm+1))):sub(1, 3)
  -- Read file and return encoded data with proper uuencoding headers and footer
  local ok, dat, err_c = fs.readFile(path)
  if not ok then
    error('[UU.encFile]: ' .. dat)
  else
    return(
      'begin ' .. perm .. ' ' .. (path:match('([^'..fs.pathSep()..']+)$')) .. '\n' ..
      uu.enc(dat) .. '\n' ..
      'end'
    )
  end
end

-- Decodes a uuencoded file string into its contents.
-- data: The uuencoded file string to be decoded.
-- Returns: The number of files decoded, and a table containing the file names, permission octals and contents.
function uu.decFile(data)
  assert(type(data)=='string','[UU.decFile]: Expected string with uuencoded file, but got '..type(data)..'.')
  local ret = {}
  for sc, perm, path, encs, ec in data:gmatch('(.?)begin ([0-7][0-7][0-7]) ([^\r\n]+)\r?\n([\32-\96\r\n]-\r?\n`)\r?\nend(.?)') do
    -- Check if the string is properly seperated and not in the middle of a string,
    --   if so, add the file's details to the table
    if not(sc and sc~='' and sc~='\n') and not(ec and ec~='' and ec~='\n' and ec~='\r')then
      table.insert(ret,{
        name = path,        -- Filename.
        perm = perm,        -- Permission octal (e.g. "644")
        data = uu.dec(encs) -- The decoded data string.
      })
    end
  end
  -- Return the number of files decoded and the table of decoded files
  return #ret, ret
end

return uu
