local g = grid.connect()

function g.init()
  g.signal_deaths = {}
  g.signal_and_cell_collisions = {}
end

function g.grid_redraw_clock()
  while true do
    clock.sleep(1 / 30)
    if fn.dirty_grid() == true then
      g:grid_redraw()
      fn.dirty_grid(false)
    end
    if keeper.is_cell_selected then fn.dirty_grid(true) end
    if #g.signal_deaths > 0 then fn.dirty_grid(true) end
    if #g.signal_and_cell_collisions > 0 then fn.dirty_grid(true) end
  end
end

function g:grid_redraw()
  self:all(0)
  self:led_cells()
  self:led_signals()
  self:led_signal_deaths()
  self:led_signal_and_cell_collision()
  self:led_selected_cell()
  self:led_cell_ports()
  self:led_cell_analysis()
  self:refresh()
end

function g.key(x, y, z)
  if z == 0 then return end
  if not keeper.is_cell_selected then
    keeper:select_cell(x, y)
    graphics:top_message_cell_structure()
  else
    if keeper.selected_cell.id == fn.id(x, y) then
      keeper.selected_cell:cycle_structure()
      graphics:top_message_cell_structure()
    elseif keeper.selected_cell:find_port(x, y) then
      keeper.selected_cell:toggle_port(x, y)
    elseif keeper:cell_exists(fn.id(x, y)) then
      keeper:select_cell(x, y)
      graphics:top_message_cell_structure()
    else
      keeper:deselect_cell()
    end
  end
  page:select(2)
  fn.dirty_grid(true)
  fn.dirty_screen(true)
end

function g:led_signals()
  local level = page.active_page == 3 and page.selected_item == 4 and 10 or 2
  for k,v in pairs(keeper.signals) do
    if v.generation <= fn.generation() then
      self:led(v.x, v.y, level)
    end
  end
end

function g:register_signal_death_at(x, y)
  local signal = {}
  signal.x = x
  signal.y = y
  signal.generation = fn.generation()
  signal.level = 15
  table.insert(self.signal_deaths, signal)
end

function g:led_signal_deaths()
  for k,v in pairs(self.signal_deaths) do
    if v.level == 0 or v.generation + 2 < fn.generation() then
      table.remove(self.signal_deaths, k)
    else
      self:led(v.x, v.y, v.level)
      v.level = v.level - 1
    end
  end
end

function g:register_signal_and_cell_collision_at(x, y)
  local collision = {}
  collision.x = x
  collision.y = y
  collision.generation = fn.generation()
  collision.level = 15
  table.insert(self.signal_and_cell_collisions, collision)
end

function g:led_signal_and_cell_collision()
  for k,v in pairs(self.signal_and_cell_collisions) do
    if v.level == 0 or v.generation + 2 < fn.generation() then
      table.remove(self.signal_and_cell_collisions, k)
    else
      self:led(v.x, v.y, v.level)
      v.level = v.level - 1
    end
  end
end

function g:led_cells()
  -- local level = page.active_page == 3 and page.selected_item ~= 5 and 2 or 5
  for k,v in pairs(keeper.cells) do
    self:led(v.x, v.y, 5)
  end
end

function g:led_cell_analysis()
  if page.active_page == 3 then
    for k,v in pairs(keeper.cells) do
        if v.structure == page.selected_item then
          self:highlight_cell(v)
        end
      end
  end
end

function g:led_selected_cell()
  if keeper.is_cell_selected then
    self:highlight_cell(keeper.selected_cell)
  end
end

function g:highlight_cell(cell)
  self:led(cell.x, cell.y, util.clamp(fn.grid_frame() % 15, 5, 15))
end

function g:led_cell_ports()
  if not keeper.is_cell_selected then return end
  local x = keeper.selected_cell_x
  local y = keeper.selected_cell_y
  local high = util.clamp(fn.grid_frame() % 15, 10, 15)
  local low = util.clamp(fn.grid_frame() % 15, 3, 5)
  if fn.in_bounds(x, y - 1) then
    self:led(x, y - 1, keeper.selected_cell:is_port_open("n") and high or low)
  end
  if fn.in_bounds(x + 1, y) then
    self:led(x + 1, y, keeper.selected_cell:is_port_open("e") and high or low)
  end
  if fn.in_bounds(x, y + 1) then
    self:led(x, y + 1, keeper.selected_cell:is_port_open("s") and high or low)
  end
  if fn.in_bounds(x - 1 , y) then
    self:led(x - 1, y, keeper.selected_cell:is_port_open("w") and high or low)
  end
end

return g