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
  g:led_selected_cell_ports()
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
    self:led(value.x, value.y, 5) 
  end
end

function g:led_selected_cell()
  if keeper.is_cell_selected then
    self:led(keeper.selected_cell_x, keeper.selected_cell_y, 15)
  end
end

function g:led_selected_cell_ports()
  if not keeper.is_cell_selected then return end
  local x = keeper.selected_cell_x
  local y = keeper.selected_cell_y
  if keeper.selected_cell:is_port_open('n') then
    if 0 < y - 1 then
      self:led(x, y - 1, 5)
    end
  end
  if keeper.selected_cell:is_port_open('e') then
    if params:get("grid_width") > x + 1 then
      self:led(x + 1, y, 5)
    end
  end
  if keeper.selected_cell:is_port_open('s') then
    if params:get("grid_height") > y + 1 then
      self:led(x, y + 1, 5)
    end
  end
  if keeper.selected_cell:is_port_open('w') then
    if 0 < x - 1 then
      self:led(x - 1, y, 5)
    end
  end
end

return g