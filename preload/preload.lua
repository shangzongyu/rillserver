require "error_code"
require "logger_api"
class = require "middleclass"

local serpent_lib = require "serpent"

function serpent(value)
  return serpent_lib.line(value)
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

function table2string(arr)
  local str = ''
  if arr ~= nil then
    table.foreach(arr, function(i,v)
      str = str .. i .. ':' .. arr2string(v) .. ','
    end)
  end
  return str
end

function arr2string(...)
  local str = ''
  for i,v in ipairs({...}) do
    if type(v) == 'table' then
      str = str .. ',[' .. table2string(v) .. ']'
    else
      str = str .. ',' .. tostring(v)
    end
  end
  if string.len(str) > 0 and string.byte(str, 1) == 44 then
    str = string.sub(str, 2)
  end
  return str
end

function creatEnum(tbl, index)
  local enumtbl = {}
  local enumindex = index or 0
  for i, v in ipairs(tbl) do
    enumtbl[v] = enumindex + i
  end
  return enumtbl
end

function readFile(file, model)
  local data = nil
  local ffile = io.open(file, model or 'rb')
  if ffile ~= nil then
    data = ffile:read '*a'
    ffile:close()
  end
  return data
end

function saveFile(file, data)
  local ffile = io.open(file, 'w')
  if ffile ~= nil then
    ffile:write(data)
    ffile:close()
  end
end

function string.split(str, delimiter)
  if str==nil or str=='' or delimiter==nil then
    return nil
  end
  local result = {}
  for match in (str..delimiter):gmatch('(.-)'..delimiter) do
    table.insert(result, match)
  end
  return result
end

function string.strip(str)
  return str:match('^%s*(.-)%s*$')
end
