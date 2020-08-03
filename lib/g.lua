local g = grid.connect()

function g.key(x,y,z)
  if z == 1 then
    select_cell(x, y)
    select_page(2)
    print(x,y)
  end
end

return g