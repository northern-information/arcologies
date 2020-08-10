local keeper = {}

function keeper.init()  
  keeper.is_cell_selected = false
  keeper.selected_cell_id = ""
  keeper.selected_cell_x = ""
  keeper.selected_cell_y = ""
  keeper.selected_cell = {}
  keeper.cells = {}
  keeper.signals = {}
end

function keeper:spawn_signals()
  for k,v in pairs(self.cells) do
    if v.structure == 1 and v.phase == generation() % meter + 1 and #v.ports > 0then
      for kk,vv in pairs(v.ports) do
        if vv == "n" then
          self:create_signal(v.x, v.y - 1, "n", generation())
        elseif vv == "e" then
          self:create_signal(v.x + 1, v.y, "e", generation())
        elseif vv == "s" then
          self:create_signal(v.x, v.y + 1, "s", generation())
        elseif vv == "w" then
          self:create_signal(v.x - 1, v.y, "w", generation())
        end
        dirty_grid(true)
        dirty_screen(true)
      end
    end
  end
end

function keeper:propagate_signals()
  if #self.signals < 1 then return end
  local delete = {}
  for k,v in pairs(self.signals) do
    if v.generation < generation() then
      v:propagate()
      if not in_bounds(v.x, v.y) then
        table.insert(delete, v.id)
      end
    end
  end
  for k,v in pairs(delete) do
    self:delete_signal(v)
  end
  dirty_grid(true)
  dirty_screen(true)
end

function keeper:collide_signals()
  for k,v in pairs(self.signals) do
    for kk,vv in pairs(self.signals) do
      if k ~= kk then 
        if v.id == vv.id then
          g:register_signal_death_at(v.x, v.y)
          self:delete_signal(v.id)
          self:delete_signal(vv.id)
        end
      end
    end
  end
end

function keeper:collide_signals_and_cells()
  for k,signal in pairs(self.signals) do
    for kk,cell in pairs(self.cells) do
      if signal.id == cell.id then
        self:collide(signal, cell)              
      end
    end
  end
end

function keeper:collide(signal, cell)
  local heading = signal.heading
  -- smash into closed port
  if not cell:is_port_open(heading) then
    self:delete_signal(signal.id)
  end
  -- hives don't allow any signals in
  if cell.structure == 1 then
    self:delete_signal(signal.id)
  end
  -- shrines play sounds
  if cell.structure == 3 then
    sound:play(cell.sound, cell.velocity)
    self:delete_signal(signal.id)
  end
  -- gates and shrines reroute & split
  -- look at all the ports to see if this signal made it in
  -- then split the signal to all the other ports
  for k,in_port in pairs(cell.ports) do
    if self:are_signal_and_port_compatible(signal, in_port) then
      for k,out_port in pairs(cell.ports) do
        if out_port ~= in_port then
          g:register_signal_and_cell_collision_at(cell.x, cell.y)
          if out_port == "n" then self:create_signal(cell.x, cell.y - 1, "n", generation() + 1) end
          if out_port == "e" then self:create_signal(cell.x + 1, cell.y, "e", generation() + 1) end
          if out_port == "s" then self:create_signal(cell.x, cell.y + 1, "s", generation() + 1) end
          if out_port == "w" then self:create_signal(cell.x - 1, cell.y, "w", generation() + 1) end
        end
      end
    end
  end
end

function keeper:are_signal_and_port_compatible(signal, port)
  if (signal.heading == "n" and port == "s") then return true end
  if (signal.heading == "e" and port == "w") then return true end
  if (signal.heading == "s" and port == "n") then return true end
  if (signal.heading == "w" and port == "e") then return true end
  return false
end

-- signals

function keeper:create_signal(x, y, h, g)
  local new_signal = Signal:new(x, y, h, g)
  table.insert(self.signals, new_signal)
  return new_signal
end

function keeper:delete_signal(id)
  for k,v in pairs(self.signals) do
    if v.id == id then
      table.remove(self.signals, k)
    end
  end
  dirty_grid(true)
end

function keeper:delete_all_signals()
  self.signals = {}
end

-- cells

function keeper:get_cell(id)
   for k,v in pairs(self.cells) do
    if v.id == id then
      return v
    end
  end
  return false
end

function keeper:cell_exists(id)
  for k,v in pairs(self.cells) do
    if v.id == id then
      return true
    end
  end
  return false
end

function keeper:create_cell(x, y)
  local new_cell = Cell:new(x, y, generation())
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
  local id = id(x, y)
  if self:cell_exists(id) then
    self.selected_cell = self:get_cell(id)
  else
    self.selected_cell = self:create_cell(x, y)
  end
  self.is_cell_selected = true
  self.selected_cell_id = self.selected_cell.id
  self.selected_cell_x = self.selected_cell.x
  self.selected_cell_y = self.selected_cell.y
  dirty_grid(true)
  dirty_screen(true)
end

function keeper:deselect_cell()
  self.is_cell_selected = false
  self.selected_cell_id = ""
  self.selected_cell_x = ""
  self.selected_cell_y = ""
  dirty_grid(true)
  dirty_screen(true)
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