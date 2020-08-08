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
    if keeper.is_cell_selected then
      dirty_grid(true)
    end
  end
end

function grid_redraw()
  g:all(0)
  g:led_cells()
  g:led_selected_cell()
  g:led_cell_ports()
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
  local l = 0
  if keeper.is_cell_selected then
    l = util.clamp(grid_frame() % 15, 5, 15)
    self:led(keeper.selected_cell_x, keeper.selected_cell_y, l)
  end
end

function g:led_cell_ports()
  if not keeper.is_cell_selected then return end
  local x = keeper.selected_cell_x
  local y = keeper.selected_cell_y
  local l = 0
  if in_bounds(x, y - 1) then
    if keeper.selected_cell:is_port_open('n') then
      l = util.clamp(grid_frame() % 15, 10, 15)
      self:led(x, y - 1, l)
    else
      l = util.clamp(grid_frame() % 15, 3, 5)
      self:led(x, y - 1, l)
    end
  end
  if in_bounds(x + 1, y) then
    if keeper.selected_cell:is_port_open('e') then
      l = util.clamp((grid_frame() % 15) + 3, 10, 15)
      self:led(x + 1, y, l)
    else
      l = util.clamp(grid_frame() % 15, 3, 5)
      self:led(x + 1, y, l)
    end
  end
  if in_bounds(x, y + 1) then
    if keeper.selected_cell:is_port_open('s') then
      l = util.clamp((grid_frame() % 15) + 6, 10, 15)
      self:led(x, y + 1, l)
    else
      l = util.clamp(grid_frame() % 15, 3, 5)
      self:led(x, y + 1, l)
    end
  end
  if in_bounds(x- 1 , y) then  
    if keeper.selected_cell:is_port_open('w') then
      l = util.clamp((grid_frame() % 15) + 9, 10, 15)
      self:led(x - 1, y, l)
    else
      l = util.clamp(grid_frame() % 15, 3, 5)
      self:led(x - 1, y, l)
    end
  end
end

return g