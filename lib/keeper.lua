local keeper = {}

function keeper.init()
  keeper.is_cell_selected = false
  keeper.selected_cell_id = ""
  keeper.selected_cell_x = ""
  keeper.selected_cell_y = ""
  keeper.selected_cell = {}
  keeper.cells = {}
  keeper.signals = {}
  keeper.signals_to_delete = {}
end

-- spawning, propagation, and collision

function keeper:spawn_signals()
  for k,v in pairs(self.cells) do
    if v.structure == 1 and v.offset == counters.music_generation() % sound.meter and #v.ports > 0 then
      for kk,vv in pairs(v.ports) do
        if vv == "n" then
          self:create_signal(v.x, v.y - 1, "n")
        elseif vv == "e" then
          self:create_signal(v.x + 1, v.y, "e")
        elseif vv == "s" then
          self:create_signal(v.x, v.y + 1, "s")
        elseif vv == "w" then
          self:create_signal(v.x - 1, v.y, "w")
        end
        fn.dirty_grid(true)
        fn.dirty_screen(true)
      end
    end
  end
end

function keeper:propagate_signals()
  for k,signal in pairs(self.signals) do
    signal:propagate()
  end
  fn.dirty_grid(true)
  fn.dirty_screen(true)
end

function keeper:collide_signals()
  for ka, signal_from_set_a in pairs(self.signals) do
    for kb, signal_from_set_b in pairs(self.signals) do
      if signal_from_set_a.index == signal_from_set_b.index 
      and signal_from_set_a.id ~= signal_from_set_b.id then 
        self:register_delete_signal(signal_from_set_a.id)
        self:register_delete_signal(signal_from_set_b.id)
        g:register_signal_death_at(signal_from_set_a.x, signal_from_set_a.y)
      end
    end
  end
end 

function keeper:collide_signals_and_cells()
  for k, signal in pairs(self.signals) do
    for kk, cell in pairs(self.cells) do
      if signal.index == cell.index then
        self:collision(signal, cell)
      end
    end
  end
end

function keeper:collision(signal, cell)

  -- smash into closed port
  if not self:are_signal_and_port_compatible(signal, cell) then
    self:register_delete_signal(signal.id)    
    g:register_signal_death_at(cell.x, cell.y)
  
  -- hives don't allow any signals in
  elseif cell.structure == 1 then
    self:register_delete_signal(signal.id)
    g:register_signal_death_at(cell.x, cell.y)

  -- shrines play single midi notes
  elseif cell.structure == 2 then
    sound:play(cell.note, cell.velocity)
    self:register_delete_signal(signal.id)
    g:register_collision_at(cell.x, cell.y)
  end
  
  --[[ gates and shrines reroute & split
    look at all the ports to see if this signal made it in
    then split the signal to all the other ports ]]
  if cell.structure == 2 or cell.structure == 3 then
    for k, port in pairs(cell.ports) do
      if port == "n" and signal.heading ~= "s" then self:create_signal(cell.x, cell.y - 1, "n", counters.music_generation() + 1) end
      if port == "e" and signal.heading ~= "w" then self:create_signal(cell.x + 1, cell.y, "e", counters.music_generation() + 1) end
      if port == "s" and signal.heading ~= "n" then self:create_signal(cell.x, cell.y + 1, "s", counters.music_generation() + 1) end
      if port == "w" and signal.heading ~= "e" then self:create_signal(cell.x - 1, cell.y, "w", counters.music_generation() + 1) end
      g:register_collision_at(cell.x, cell.y)
    end
  end
end

function keeper:are_signal_and_port_compatible(signal, cell)
  if (signal.heading == "n" and cell:is_port_open("s")) then return true end
  if (signal.heading == "e" and cell:is_port_open("w")) then return true end
  if (signal.heading == "s" and cell:is_port_open("n")) then return true end
  if (signal.heading == "w" and cell:is_port_open("e")) then return true end
  return false
end

-- signals

function keeper:create_signal(x, y, h, g)
  local signal = Signal:new(x, y, h, g)
  table.insert(self.signals, signal)
  return signal
end

function keeper:register_delete_signal(id)
  self.signals_to_delete[#self.signals_to_delete + 1] = id
end

function keeper:delete_signals()
  for k, id_to_delete in pairs(self.signals_to_delete) do
    for k, signal in pairs(self.signals) do
      if signal.id == id_to_delete then
        table.remove(self.signals, k)
      end
    end
  end
  self.signals_to_delete = {}
  fn.dirty_grid(true)
  fn.dirty_screen(true)
end

function keeper:delete_all_signals()
  self.signals = {}
  self.signals_to_delete = {}
  fn.dirty_grid(true)
  fn.dirty_screen(true)
end

-- cells

function keeper:get_cell(index)
   for k, cell in pairs(self.cells) do
    if cell.index == index then
      return cell
    end
  end
  return false
end

function keeper:create_cell(x, y)
  local new_cell = Cell:new(x, y, counters.music_generation())
  table.insert(self.cells, new_cell)
  return new_cell
end

function keeper:delete_cell(id)
  for k,v in pairs(self.cells) do
    if v.id == id then
      table.remove(self.cells, k)
      self:deselect_cell()
    end
  end
end

function keeper:delete_all_cells()
  self:deselect_cell()
  self.cells = {}
end

function keeper:select_cell(x, y)
  if self:get_cell(fn.index(x, y)) then
    self.selected_cell = self:get_cell(fn.index(x, y))
  else
    self.selected_cell = self:create_cell(x, y)
  end
  self.is_cell_selected = true
  self.selected_cell_id = self.selected_cell.id
  self.selected_cell_x = self.selected_cell.x
  self.selected_cell_y = self.selected_cell.y
  fn.dirty_grid(true)
  fn.dirty_screen(true)
end

function keeper:deselect_cell()
  self.is_cell_selected = false
  self.selected_cell_id = ""
  self.selected_cell_x = ""
  self.selected_cell_y = ""
  fn.dirty_grid(true)
  fn.dirty_screen(true)
end

function keeper:count_cells(s)
  local count = 0
  for k,v in pairs(self.cells) do
    if v.structure == s then
      count = count + 1
    end
  end
  return count
end

return keeper