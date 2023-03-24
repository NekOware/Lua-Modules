# Lua-Modules
A place where some of my less useful Lua modules live.

<details><summary><h2>UUEncoding.lua</h2></summary>
  
  A module that provides functions to encode and decode strings to and from the uuencoding format. Uuencoding is a form of binary-to-text encoding, which is primarily used to convert binary data into a format that can be easily transmitted as plain text, such as email or Usenet messages.  
  For more info on uuencoding: [Wikipedia](https://en.wikipedia.org/wiki/Uuencoding)
  
  ### Features
  - [x] ~~Efficient.~~ Simple.
  - [x] Easy-to-use.
  - [ ] Fix all of your code issues.
  
  ### Usage
  ```lua
  local uu = require("uuencoding")

  -- Encode a string
  local encoded_string = uu.enc("Hello, World!")

  -- Decode a string
  local decoded_string = uu.dec(encoded_string)
  ```
  Links: [UUEncoding.lua][lib_uuencoding] - [Example.lua][example_uuencoding] - [Test.lua][test_uuencoding]
  
  [lib_uuencoding]: https://github.com/NekOware/Lua-Modules/blob/main/libs/uuencoding.lua
  [example_uuencoding]: https://github.com/NekOware/Lua-Modules/blob/main/examples/uuencoding.lua
  [test_uuencoding]: https://github.com/NekOware/Lua-Modules/blob/main/tests/uuencoding.lua
  
</details>
