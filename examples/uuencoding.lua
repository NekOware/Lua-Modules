-- Import the UUEncoding module
local uu = require("uuencoding")

-- Input string
local input_string = "Hello, World!"

-- Encode the input string
local encoded_string = uu.enc(input_string)   --> "-2&5L;&\\L(%=O<FQD(0``\n`"
print("Encoded string: " .. encoded_string)

-- Decode the encoded string
local decoded_string = uu.dec(encoded_string) --> "Hello, World!"
print("Decoded string: " .. decoded_string)

-- Check if the decoded string is the same as the input string
if input_string == decoded_string then
  print("The input string and decoded string match!")
else
  print("The input string and decoded string do not match.")
end

-- Encode a file to UUEncoding.
local encoded_file = uu.encFile(
  '../_test_file.txt', -- Absolute or Relative Target File Path.
  '644'                -- Permission Octal. Defaults to "644"
)
--[[
  encoded_file =  'begin 644 test.txt\n'..
                  'M2&5L;&\\L(%=O<FQD(0T*5&AE(\'%U:6-K(&)R;W=N(&9O>"!J=6UP<R!O=F5R\n'..
                  '7(\'1H92!L87IY(&1O9RX-"DAI(&UO;2$`\n'..
                  '`\n'..
                  'end'
]]

-- Decode one or more files from a UUEncoded file string.
local file_count, decoded_files = uu.decFile(encoded_file)
--[[
  file_count = 1
  decoded_files = {
    {
      name = 'test.txt',
      perm = '644',
      data = 'Hello, World!\r\nThe quick brown fox jumps over the lazy dog.\r\nHi mom!'
    }
  }
]]

-- Check if at least one file was decoded.
if file_count <= 0 then
  print('FAIL: No files were decoded from test file encode.')
  os.exit(1) -- Exit the script and return the code 1 to the OS.
end
