# Lua-Modules
A place where some of my less useful Lua modules live.

<details>
  <summary><h2>UUEncoding.lua</h2></summary>
  
  A module that provides functions to encode and decode strings to and from the uuencoding format.  
  Uuencoding is a form of binary-to-text encoding, which is primarily used to convert binary data into a format that can be easily transmitted as plain text, such as email or Usenet messages.  
  For more info on uuencoding: [Wikipedia](https://en.wikipedia.org/wiki/Uuencoding)
  
  ### Features
  - [x] Encode/Decode strings and files to and from UUEncoded format.
  - [x] ~~Efficient.~~ Simple.
  - [x] Easy-to-Use.
  - [ ] Fix all of your code issues.
  
  ### Usage
  ```lua
  local uu = require("uuencoding")

  -- Encode a string
  local encoded_string = uu.enc("Hello, World!")

  -- Decode a string
  local decoded_string = uu.dec(encoded_string)

  -- Encode a file
  local encoded_file = uu.encFile("_test_file.txt", "644")

  -- Decode files from a encoded file string.
  local file_count, decoded_files = uu.decFile("begin 644 _test_file.txt\n! Encoded Data !\n`\nend")
  ```
  
  ### Links
  [UUEncoding.lua][lib_uuencoding]  
  [Example.lua][example_uuencoding]  
  [Test.lua][test_uuencoding]
  
  [lib_uuencoding]: https://github.com/NekOware/Lua-Modules/blob/main/libs/uuencoding.lua
  [example_uuencoding]: https://github.com/NekOware/Lua-Modules/blob/main/examples/uuencoding.lua
  [test_uuencoding]: https://github.com/NekOware/Lua-Modules/blob/main/tests/uuencoding.lua
  
</details>

<details>
  <summary><h2>Base64.lua</h2></summary>

  A module that provides functions to encode and decode strings to and from the base64 encoding format.  
  Base64 is a method of encoding any binary data in a way that can be transmitted or stored as text. It uses a set of 64 characters (hence the name "Base64") that includes letters, numbers, and symbols to represent the binary data as a series of 6-bit values. Each group of three bytes is converted into four Base64 characters, resulting in an output string that is approximately 33% larger than the original binary data. Base64 is commonly used in email, web pages, and other applications where binary data needs to be transmitted as ASCII text.  
  For more info on Base64: [Wikipedia](https://en.wikipedia.org/wiki/Base64)
  
  ### Features
  - [x] Encode/Decode strings to and from the Base64 format.
  - [x] ~~Optimized.~~ Dumb, but simple.
  - [x] Easy-to-Use.
  - [ ] Locate the cause of your kernel panics.

  ### Usage
  ```lua
  local b64 = require('base64')

  -- Encode a string
  local encoded_string = b64.enc("Hello, World!") -- 'b64.enc' is an alias for 'b64.encode'
  
  -- Decode a string
  local decoded_string = b64.dec(encoded_string) -- 'b64.dec' is an alias for 'b64.decode'
  
  -- Decode a string with strict mode which disallows non-base64 characters from the input string.
  -- (If input string has non-base64 characters then calls an error.)
  local decoded_strict = b64.dec(encoded_string, true)
  ```

  ### Links
  [Base64.lua][lib_base64]  
  [Example.lua][example_base64]  
  [Test.lua][test_base64]
  
  [lib_base64]: https://github.com/NekOware/Lua-Modules/blob/main/libs/base64.lua
  [example_base64]: https://github.com/NekOware/Lua-Modules/blob/main/examples/base64.lua
  [test_base64]: https://github.com/NekOware/Lua-Modules/blob/main/tests/base64.lua

</details>
