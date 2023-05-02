-- Import the Base64 module.
local b64 = require('base64')


-- Input string
local input_string = "Hello, World!"


-- Encode the input string
local encoded_string = b64.enc(input_string)  --> "SGVsbG8sIFdvcmxkIQ=="
print("Encoded string: " .. encoded_string)


-- Decode the encoded string
local decoded_string = b64.dec(encoded_string) --> "Hello, World!"
print("Decoded string: " .. decoded_string)


-- Check if the decoded string is the same as the input string
if input_string == decoded_string then
  print("The input string and decoded string match!")
else
  print("The input string and decoded string do not match.")
end
