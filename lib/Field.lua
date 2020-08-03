Field = {}

function Field:new()
  local f = setmetatable({}, { __index = Field })

  f.cells = {}
  return f
end

function Field:add_cell(cell)
  table.insert(self.cells, cell)
end

function Field:is_cell(x, y)
  
end

function Field:lookup(x, y)
  local id = "X" .. x .. "Y" .. y
  local result = false
  --tabutil.contains(t, e)
  for k,v in pairs(self.cells) do
    -- todo: understand what is wrong with this one  
    -- tabutil.contains(v, id)
    for kk,vv in pairs(v) do
      if kk == "id" then
        if vv == id then
          result = true
        end
      end
    end
  end
  return result
end

function Field:debug()
  for k,v in pairs(self.cells) do
    print(k)
    print(v)
  end
end