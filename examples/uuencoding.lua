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
