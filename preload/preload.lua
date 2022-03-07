require "error_code"
require "logger_api"
-- class = require "middleclass"

local serpent_lib = require "serpent"
function serpent(value)
  return serpent_lib.block(value)
end

local inspect_lib = require "inspect"
function inspect(value)
  return inspect_lib(value, {
    process = function(item, path)
      if type(item) == "function" then
        return nil
      end

      if path[#path] == inspect_lib.METATABLE then
        return nil
      end

      return item
    end,
    newline = " ",
    indent = ""
  })
end
