local g = grid.connect()

function g.key(x,y,z)
  if z == 1 then
    select_page(2)
    select_cell(x, y)
    print(x,y)
  end
end

return g