Cell = {}

function Cell:new(x, y, g)
  local c = setmetatable({}, { __index = Cell })

  -- constants
  c.x = x ~= nil and x or 0
  c.y = y ~= nil and y or 0
  c.generation = g ~= nil and g or 0
  c.id = fn.id()
  c.index = fn.index(c.x, c.y)
  c.cardinals = { "n", "e", "s", "w" }
  c.available_ports = {
    { c.x, c.y - 1, "n" },
    { c.x + 1, c.y, "e" },
    { c.x, c.y + 1, "s" },
    { c.x - 1, c.y, "w" }
  }
  c.metabolisms = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 }
  c.structures = { "HIVE", "SHRINE", "GATE", "RAVE", "TOPIARY" }
  c.attributes = { "STRUCTURE", "OFFSET", "VELOCITY", "METABOLISM", "DOCS",
                   "NOTE INDEX", "NOTE 1", "NOTE 2", "NOTE 3", "NOTE 4", "NOTE 5",
                   "NOTE 6", "NOTE 7", "NOTE 8", }
  c.structure_attribute_map = {
    ["HIVE"] = {"OFFSET", "METABOLISM"},
    ["SHRINE"] = {"NOTE 1", "VELOCITY"},
    ["GATE"] = {},
    ["RAVE"] = {"OFFSET", "METABOLISM"},
    ["TOPIARY"] = {"NOTE INDEX", "NOTE 1", "NOTE 2", "NOTE 3", "NOTE 4", 
                   "NOTE 5", "NOTE 6", "NOTE 7", "NOTE 8", "VELOCITY"}
  }
  for k,v in pairs(c.structure_attribute_map) do
    c.structure_attribute_map[k][#c.structure_attribute_map[k] + 1] = "STRUCTURE"
    c.structure_attribute_map[k][#c.structure_attribute_map[k] + 1] = "DOCS"
  end

  -- mutable
  c.ports = {}
  c.structure_key = 1
  c.structure_value = c.structures[c.structure_key]
  c.offset = 0
  c.notes = {72, 72, 72, 72, 72, 72, 72, 72}
  c.note_count = 1
  c.note_index = 1  
  c.max_note_index = 8
  c.velocity = 127
  c.metabolism = 4
  
  

  return c
end

function Cell:menu_items()
 return self.structure_attribute_map[self.structure_value] or "NONE?"
end

function Cell:get_menu_value_by_attribute(attribute)
      if attribute == "STRUCTURE"  then return self.structure_value
  elseif attribute == "OFFSET"     then return self.offset
  elseif attribute == "NOTE INDEX" then return self.note_index  
  elseif attribute == "VELOCITY"   then return self.velocity
  elseif attribute == "METABOLISM" then return self.metabolism
  -- keep it stupid simple, don't want to fuck with substrings or loops  
  elseif attribute == "NOTE 1"     then return self:get_note_name(1)
  elseif attribute == "NOTE 2"     then return self:get_note_name(2)
  elseif attribute == "NOTE 3"     then return self:get_note_name(3)
  elseif attribute == "NOTE 4"     then return self:get_note_name(4)
  elseif attribute == "NOTE 5"     then return self:get_note_name(5)
  elseif attribute == "NOTE 6"     then return self:get_note_name(6)
  elseif attribute == "NOTE 7"     then return self:get_note_name(7)
  elseif attribute == "NOTE 8"     then return self:get_note_name(8)
  end
end

function Cell:set_structure(i)
  self.structure_key = util.clamp(i, 1, #self.structures)
  self.structure_value = self.structures[self.structure_key]
  self.note_count = self.structure_value == "TOPIARY" and 8 or 1
end

function Cell:cycle_note_index(i)
  self.note_index = fn.cycle(self.note_index + i, 1, self.max_note_index)
end

function Cell:is(s)
  return self.structure_value == s and true or false
end

function Cell:has(s)
  return fn.table_find(self.structure_attribute_map[self.structure_value], s) or false
end

function Cell:set_offset(i)
  self.offset = i
end

function Cell:set_note(note, index)
  local index = index ~= nil and index or 1
  self.notes[index] = sound.notes_in_this_scale[util.clamp(note, 1, #sound.notes_in_this_scale)]
end

function Cell:get_note()
  return mu.note_num_to_name(self.notes[self.index], true)
end

function Cell:get_note_name(i)
  return mu.note_num_to_name(self.notes[i], true)
end

function Cell:set_velocity(i)
  self.velocity = util.clamp(i, 0, 127)
end

function Cell:set_metabolism(i)
  self.metabolism = util.clamp(i, 0, 16)
end

function Cell:toggle_port(x, y)
  local port = self:find_port(x, y)
  if not port then return end
  if self:is_port_open(port[3]) then
    self:close_port(port[3])
  else
    self:open_port(port[3])
  end
end

function Cell:find_port(x, y)
  if not fn.in_bounds(x, y) then return false end
  for k,v in pairs(self.available_ports) do
    if v[1] == x and v[2] == y then
      return v
    end
  end
  return false
end

function Cell:is_port_open(p)
  return tu.contains(self.ports, p)
end

function Cell:open_port(p)
  table.insert(self.ports, p)
end

function Cell:close_port(p)
  table.remove(self.ports, fn.table_find(self.ports, p))
end

function Cell:invert_ports()
  for k,v in pairs(self.available_ports) do
    self:toggle_port(v[1], v[2])
  end
end

-- divergent cell structures



function Cell:is_spawning()
  -- metabolism of 0 is mute
  if self.metabolism == 0 then
    return false
  elseif ((counters.this_beat() - self.offset) % self.metabolism) == 1 then
        if self:is("HIVE") then return true
    elseif self:is("RAVE") then return true
       end
  else
    return false
  end
end

function Cell:setup()
  if self:is("RAVE") then self:drugs() end
end

-- turn on, tune in, drop out...
-- close all the ports, then flip coins to open them
function Cell:drugs()
  self.ports = {}
  for i = 1,4 do
    if fn.coin() == 1 then
      self:open_port(self.cardinals[i])
    end
  end
end


