field = {}

function field:init()
  field.cells = {}
end

function field:add_cell(cell)
  table.insert(self.cells, cell)
end

function field:delete_cell(id)
  print(' - - - - - - - - - - - - - - ')
  for key, value in pairs(self.cells) do
    print(value.generation)
    print(key .. ' - ')
    print(value.id)
    if value.id == id then
      print('match')
      table.remove(self.cells, key)
    end
  end
end

function field:lookup(id)
  for key, value in pairs(self.cells) do
    return tu.contains(value, id)
  end
end

return field
