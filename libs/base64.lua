
-- A very helpful function.
local function num_to_bin(num)
  local ret=''
  for i = 8, 1, -1 do
    ret = ret .. ( num%2^i - num%2^(i-1) > 0 and '1' or '0')
  end
  return ret
end

-- A helpful constant.
local _b64_chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'


local b64 = {}

--- Params
-- 1: string  ; A string to be encoded using base64.
function b64.encode(str)
  local res, suf = '', '' -- result, suffix
  local bin = ''

  -- Convert the input string to binary.
  for i = 1, #str do
    local bits = num_to_bin( str:byte(i) )
    bin = bin .. bits
  end

  -- Add padding 0's if input string's length not divisible by 3
  local pad = 3 - (#str%3)
  if pad < 3 then
    bin = bin .. ('00'):rep(pad)
    suf = ('='):rep(pad)
  end

  -- Read converted binary 6 bits at a time,
  -- convert bits to decimal and
  -- insert corresponding base64 character to result string.
  for i = 1, #bin, 6 do
    local bits = bin:sub(i, i+5)
    local num = tonumber(bits, 2) + 1
    res = res .. _b64_chars:sub(num, num)
  end

  return res .. suf
end

--- Params
-- 1: string  ; A base64 encoded string to be decoded.
-- 2: boolean ; A switch to enable "strict" mode which disallows all invalid characters from the input base64 string.
function b64.decode(str, strict)
  local res = ''
  local bin = ''

  -- Make sure that strict switch is true and not just any random value.
  strict = (strict == true)

  -- Strict mode to make sure that all characters in input are valid
  -- and if not then raise an error.
  if strict then
    local pos = str:find('[^' .. _b64_chars .. '=%s]')
    if pos then
      local line, column = 1, 0
      for i = 1, pos do
        if str:sub(i,i) == '\n' then
          line = line + 1
          column = 0
        else
          column = column + 1
        end
      end
      local msg = ('[Base64.decode]: (Strict) Invalid character at position %i (Line: %i, Column: %i)')
                  :format( pos, line, column )
      return error(msg)
    end
  end

  -- Remove any invalid characters from input string.
  str = str:gsub('[^' .. _b64_chars .. ']', '')

  -- Convert each base64 character in input string to it's corresponding decimal number
  -- then make that number into binary and remove the first 2 unused bits from each number.
  for i = 1, #str do
    local char = str:sub(i, i)
    local num = (_b64_chars:find(char)) - 1
    local bits = num_to_bin(num)
    bin = bin .. bits:sub(-6)
  end

  -- Just to be safe.
  -- Calculate the amount of bits and make sure it's divisible by 8.
  local len = #bin - (#bin%8)

  -- Convert each binary byte to it's decimal number and
  -- get the ASCII character for that number.
  for i = 1, len, 8 do
    local bits = bin:sub(i, i+7)
    local num = tonumber(bits, 2)
    local char = string.char(num)
    res = res .. char
  end

  return res
end


b64.enc = b64.encode
b64.dec = b64.decode


return b64
