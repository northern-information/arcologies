local g = grid.connect()

function g.init()
  clock.run(grid_redraw_clock)
end

function grid_redraw_clock()
  while true do
    clock.sleep(1 / 30)
    if dirty_grid() == true then
      grid_redraw()
      dirty_grid(false)
    end
  end
end

function grid_redraw()
  g:all(0)
  g:led_cells()
  g:led_selected_cell()
  g:refresh()
end

function g.key(x, y, z)
  if z == 1 then
    print('g.key: ' .. id(x, y))
    keeper:select_cell(x, y)
    select_page(2)
  end
  dirty_grid(true)
end

function g:led_cells()
  for key,value in pairs(keeper.cells) do
    g:led(value.x, value.y, 5) 
  end
end

function g:led_selected_cell()
  if keeper.is_cell_selected then
    g:led(keeper.selected_cell_x, keeper.selected_cell_y, 15)
  end
end

return g