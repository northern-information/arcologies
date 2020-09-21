keeper = {}

-- see counters.conductor() for how things are orchestrated

function keeper.init()
  keeper.is_cell_selected = false
  keeper.selected_cell_id = ""
  keeper.selected_cell_x = ""
  keeper.selected_cell_y = ""
  keeper.selected_cell = {}
  keeper.copied_cell = {}
  keeper.cells = {}
  keeper.signals = {}
  keeper.new_signals = {}
  keeper.signals_to_delete = {}
  keeper.kudzu_growth = 0
end

-- spawning, propagation, and collision


function keeper:collision(signal, cell)

  -- all collisions result in signal deaths
  self:register_delete_signal(signal.id)
  g:register_signal_death_at(cell.x, cell.y)

  -- bang a closed port and gates redirect invert ports
  if cell:is("GATE") and not self:are_signal_and_port_compatible(signal, cell) then
    cell:invert_ports()

  -- cells below this only interact with open ports
  elseif not self:are_signal_and_port_compatible(signal, cell) then
    -- empty

  -- these don't allow signals in
  elseif cell:is("HIVE") or cell:is("RAVE") or cell:is("DOME") or cell:is("RAVE") then
    -- empty

  -- crypts play samples
  elseif cell:is("CRYPT") then
    s:one_shot(cell.state_index, cell.level / 100)

  -- shrines play single notes via sc
  elseif cell:is("SHRINE") then
    sound:play(cell.notes[1], cell.velocity)

  -- uxbs play single notes via midi
  elseif cell:is("UXB") then
    m:play(cell.notes[1], cell.velocity, cell.channel, cell.duration, cell.device)

  -- aviaries play single notes via crow
  elseif cell:is("AVIARY") then
    c:play(cell.notes[1], cell.crow_out)

  -- stores signals as charge
  elseif cell:is("SOLARIUM") then
    cell:set_charge(cell.charge + 1)

  -- crumble the institutions
  elseif cell:is("INSTITUTION") then
    cell:set_crumble(cell.crumble - 1)

  -- topiaries cylce through notes
  elseif cell:is("TOPIARY") then
    cell:cycle_state_index(1)
    sound:play(cell.notes[cell.state_index], cell.velocity)

  -- topiaries cylce through notes
  elseif cell:is("CASINO") then
    cell:cycle_state_index(1)
    m:play(cell.notes[cell.state_index], cell.velocity, cell.channel, cell.duration, cell.device)

  -- forests cylce through notes
  elseif cell:is("FOREST") then
    cell:cycle_state_index(1)
    c:play(cell.notes[cell.state_index], cell.crow_out)

  -- send signals to other tunnels
  elseif cell:is("TUNNEL") then
    self:broadcast(cell)

  -- vales play random notes
  elseif cell:is("VALE") then
    sound:play(sound:get_random_note(cell.range_min / 100, cell.range_max / 100), cell.velocity)

  -- spomeniks play single notes on jf
  elseif cell:is("SPOMENIK") then
    c:jf(cell.notes[1])

  -- autons cycle through notes on jf
  elseif cell:is("AUTON") then
    cell:cycle_state_index(1)
    c:jf(cell.notes[cell.state_index])

  -- hydroponics operate at a distance
  elseif cell:is("HYDROPONICS") then
    keeper:hydroponics(cell)

  end

  --[[ the below structures reroute & split
    look at all the ports to see if this signal made it in
    then split the signal to all the other ports ]]
  if cell:is("SHRINE")
  or cell:is("GATE")
  or cell:is("TOPIARY")
  or cell:is("CRYPT")
  or cell:is("VALE")
  or cell:is("UXB")
  or cell:is("CASINO")
  or cell:is("AVIARY")
  or cell:is("FOREST")
  or cell:is("HYDROPONICS")
  or cell:is("MIRAGE")
  or cell:is("AUTON") then
    for k, port in pairs(cell.ports) do
          if (port == "n" and signal.heading ~= "s") then self:create_signal(cell.x, cell.y - 1, "n", "tomorrow")
      elseif (port == "e" and signal.heading ~= "w") then self:create_signal(cell.x + 1, cell.y, "e", "tomorrow")
      elseif (port == "s" and signal.heading ~= "n") then self:create_signal(cell.x, cell.y + 1, "s", "tomorrow")
      elseif (port == "w" and signal.heading ~= "e") then self:create_signal(cell.x - 1, cell.y, "w", "tomorrow")
      end
    end
  end
end


function keeper:deflect_signals()
  for k, signal in pairs(self.signals) do
    for kk, cell in pairs(self.cells) do
      if signal.index == cell.index then
        if cell:has("DEFLECT") and not self:are_signal_and_port_compatible(signal, cell) then
          self:deflection(signal, cell)
        end
      end
    end
  end
end

function keeper:deflection(signal, cell)
  local d = cell.cardinals[cell.deflect]
  local x = signal.x
  local y = signal.y
  local h = signal.heading
  -- matching headings and deflections result in the signal being sent "counter clockwise" away
  -- north signals
      if h == "n" and  d == "e"              then signal:reroute(x + 1, y + 1, "e")
  elseif h == "n" and  d == "s"              then signal:reroute(x + 0, y + 1, "s")
  elseif h == "n" and (d == "w" or d == "n") then signal:reroute(x - 1, y + 1, "w")
  -- east signals
  elseif h == "e" and  d == "n"              then signal:reroute(x - 1, y - 1, "n")
  elseif h == "e" and (d == "s" or d == "e") then signal:reroute(x - 1, y + 1, "s")
  elseif h == "e" and  d == "w"              then signal:reroute(x - 1, y + 0, "w")
  -- south signals
  elseif h == "s" and  d == "n"              then signal:reroute(x + 0, y - 1, "n")
  elseif h == "s" and (d == "e" or d == "s") then signal:reroute(x + 1, y - 1, "e")
  elseif h == "s" and  d == "w"              then signal:reroute(x - 1, y - 1, "w")
  -- west signals
  elseif h == "w" and (d == "n" or d == "w") then signal:reroute(x + 1, y - 1, "n")
  elseif h == "w" and  d == "e"              then signal:reroute(x + 1, y + 0, "e")
  elseif h == "w" and  d == "s"              then signal:reroute(x + 1, y + 1, "s")
  -- quantum signals
  else print("Error: Some quantum signal shit just happened.")
  end
end

function keeper:hydroponics(cell)
  for k, other_cell in pairs(self.cells) do
      if cell:has_other_cell_in_territory(other_cell)
    and other_cell:has("METABOLISM")
    and other_cell.id ~= cell.id then
      other_cell:set_metabolism(math.floor(cell:run_operation(other_cell.metabolism, cell.metabolism)))
    end
  end
end

function keeper:broadcast(cell)
  for k, other_cell in pairs(self.cells) do
    if other_cell:is("TUNNEL") and other_cell.id ~= cell.id and other_cell.network == cell.network then
      for k, port in pairs(other_cell.ports) do
            if port == "n" then self:create_signal(other_cell.x, other_cell.y - 1, "n", "tomorrow")
        elseif port == "e" then self:create_signal(other_cell.x + 1, other_cell.y, "e", "tomorrow")
        elseif port == "s" then self:create_signal(other_cell.x, other_cell.y + 1, "s", "tomorrow")
        elseif port == "w" then self:create_signal(other_cell.x - 1, other_cell.y, "w", "tomorrow")
        end
      end
    end 
  end
end

function keeper:are_signal_and_port_compatible(signal, cell)
  if (signal.heading == "n" and cell:is_port_open("s"))
  or (signal.heading == "e" and cell:is_port_open("w"))
  or (signal.heading == "s" and cell:is_port_open("n"))
  or (signal.heading == "w" and cell:is_port_open("e")) then
    return true
  else
    return false
  end
end

function keeper:spawn_signals()
  for k,cell in pairs(self.cells) do
    if cell:is_spawning() and #cell.ports > 0 then
      if cell:is_port_open("n") then self:create_signal(cell.x, cell.y - 1, "n", "now") end
      if cell:is_port_open("e") then self:create_signal(cell.x + 1, cell.y, "e", "now") end
      if cell:is_port_open("s") then self:create_signal(cell.x, cell.y + 1, "s", "now") end
      if cell:is_port_open("w") then self:create_signal(cell.x - 1, cell.y, "w", "now") end
    end
  end
end

function keeper:setup()
  for k, signal in pairs(self.new_signals) do table.insert(self.signals, signal) end
  self.new_signals = {}
  for k, cell in pairs(self.cells) do cell:setup() end
  self:kudzu()
end

function keeper:kudzu()
  self.kudzu_growth = 0
  local sorted = self:sort_structures_by("KUDZU", "generation")
  for k, cell in pairs(sorted) do
    if cell:inverted_metabolism_check() and self.kudzu_growth < params:get("kudzu_aggression") then
      local x = cell.x
      local y = cell.y
      local vacant_neighbors = fn.get_vacant_neighbors(x, y)
      if #vacant_neighbors > 0 then
        local d = vacant_neighbors[math.random(1, #vacant_neighbors)]
            if d == "n" then y = y - 1
        elseif d == "e" then x = x + 1
        elseif d == "s" then y = y + 1
        elseif d == "w" then x = x - 1
        end
        self.kudzu_growth = self.kudzu_growth + 1
        local growth = keeper:create_cell(x, y)
        growth:change("KUDZU")
        growth:set_resilience(cell.resilience)
        growth:set_metabolism(cell.metabolism)
      end
    end
  end
end

function keeper:cropdust()
  for k, cell in pairs(self.cells) do
    if cell:is("KUDZU") then
      cell.crumble = cell.crumble - params:get("kudzu_cropdust_potency")
      cell:has_crumbled()
      g:register_flicker_at(cell.x, cell.y)
    end
  end
end

function keeper:sort_structures_by(structure, attribute)
  local sorted, reversed = {}, {}
  local i = 1
  for k, v in pairs(self.cells, function(t, a, b) return t[b][attribute] > t[a][attribute] end) do
    if v:is(structure) then
      sorted[i] = v
      i = i + 1
    end
  end
  for i = 1, #sorted do
    reversed[#sorted + 1 - i] = sorted[i]
  end
  return reversed
end

function keeper:teardown()
  for k, cell in pairs(self.cells) do cell:teardown() end
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
      and signal_from_set_a.id ~= signal_from_set_b.id 
      and fn.in_bounds(signal_from_set_a.x, signal_from_set_a.y) 
      and fn.in_bounds(signal_from_set_b.x, signal_from_set_b.y) then
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

-- signals

function keeper:create_signal(x, y, h, when)
  if not fn.in_bounds(x, y) then return false end
  if when == "now" then
    table.insert(self.signals, Signal:new(x, y, h))
  elseif when =="tomorrow" then
    table.insert(self.new_signals, Signal:new(x, y, h, counters.music_generation + 1))
  end
  fn.dirty_grid(true)
  fn.dirty_screen(true)
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
  local new_cell = Cell:new(x, y, counters.music_generation)
  table.insert(self.cells, new_cell)
  return new_cell
end

function keeper:delete_cell(id, s, d)
  local silent = s == nil and false or true
  local deselect = d == nil and true or false
  if id == nil and not self.is_cell_selected then
    if not silent then
      graphics:set_message("SELECT A CELL TO DELETE")
    end
  end
  id = id == nil and self.selected_cell_id or id
  for k,cell in pairs(self.cells) do
    if cell.id == id then
      table.remove(self.cells, k)
      if not silent then
        graphics:set_message("DELETED " .. cell.structure_name)
      end
      if page.active_page == 2 then
        menu:reset()
      end
      if deselect then 
        self:deselect_cell()
      end
    end
  end
end

function keeper:delete_all_structures(name)
  if self.selected_cell.structure_name == name then
    self:deselect_cell()
  end
  for k, cell in pairs(self.cells) do
    if cell.structure_name == name then
      table.remove(self.cells, k)
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

function keeper:count_cells(name)
  local count = 0
  for k,cell in pairs(self.cells) do
    if cell.structure_name == name then
      count = count + 1
    end
  end
  return count
end

function keeper:count_signals()
  return #self.signals
end

function keeper:get_analysis_items()
  local analysis_items = {}
  table.insert(analysis_items, "SIGNALS")
  for k,v in pairs(structures:all_enabled()) do
    if self:count_cells(v.name) > 0 then
      table.insert(analysis_items, v.name)
    end
  end
  return analysis_items
end

-- happens when the user changes the root note or the scale
function keeper:update_all_notes()
  for k,cell in pairs(self.cells) do
    if cell:has("NOTES") then
      for i=1, #cell.notes do
        -- delta of zero just jiggles the handle
        cell:browse_notes(0, i)
      end
    end
  end
end

-- happens when a new crypt directory is selected
function keeper:update_all_crypts()
  s:crypt_table()
  for k,cell in pairs(self.cells) do
    if cell:is("CRYPT") then
      cell:cycle_state_index(0, i)
    end
  end
end

return keeper