
--// Utilities

local tests = {}

local function check(bool, name)
  local result = not bool and "FAIL" or "OK"
  table.insert(tests, name .. ": " .. result)
end

local function print_results(name)
  print('Test results for ' .. name)
  for i,v in pairs(tests)do
    print(string.format('  %2i - %s', i, v))
  end
end

--// The tests

local uu = require'uuencoding'

-- Simple encoding test.
do
  local input = "Hello, World!"
  local expected = "-2&5L;&\\L(%=O<FQD(0``\n`"
  local got = uu.enc(input)
  check(got == expected, "Encode a string correctly")
end

-- Simple decoding test.
do
  local input = "-2&5L;&\\L(%=O<FQD(0``\n`"
  local expected = "Hello, World!"
  local got = uu.dec(input)
  check(got == expected, "Decode a string correctly")
end

-- Encode and Decode without loss.
do
  local input = "The quick brown fox jumps over the lazy dog."
  local encoded = uu.enc(input)
  local decoded = uu.dec(encoded)
  check(input == decoded, "Encode and decode a string without loss")
end

print_results('UUEncoding.lua')
