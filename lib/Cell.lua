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
  c.structures = { "HIVE", "SHRINE", "GATE", "RAVE" }
  c.attributes = { "STRUCTURE", "OFFSET", "NOTE", "VELOCITY", "METABOLISM", "DOCS" }
  c.structure_attribute_map = {
    ["HIVE"] = {"OFFSET", "METABOLISM"},
    ["SHRINE"] = {"NOTE", "VELOCITY"},
    ["GATE"] = {},
    ["RAVE"] = {"OFFSET", "METABOLISM"}
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
  c.note = 72 -- gonna need to do some work here once the sound/midi stuff is done
  c.velocity = 127
  c.metabolism = 4

  return c
end

function Cell:menu_items()
 return self.structure_attribute_map[self.structure_value]
end

function Cell:get_menu_value_by_attribute(attribute)
      if attribute == "STRUCTURE"  then return self.structure_value
  elseif attribute == "OFFSET"     then return self.offset
  elseif attribute == "NOTE"       then return self:get_note_name()
  elseif attribute == "VELOCITY"   then return self.velocity
  elseif attribute == "METABOLISM" then return self.metabolism
  end
end

function Cell:set_structure(i)
  self.structure_key = i
  self.structure_value = self.structures[self.structure_key]
end

function Cell:cycle_structure(i)
  self:set_structure(fn.cycle(self.structure_key + i, 1, #self.structures))
end

function Cell:is(s)
  return self.structure_value == s and true or false
end

function Cell:has(s)
  return fn.table_find(self.structure_attribute_map[self.structure_value], s)
end


function Cell:set_offset(i)
  self.offset = i
end

function Cell:set_note(i)
  self.note = sound.notes_in_this_scale[util.clamp(i, 1, #sound.notes_in_this_scale)]
end

function Cell:get_note_name()
  return mu.note_num_to_name(self.note, true)
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
  elseif fn.cycle((counters.this_beat() - self.offset) % self.metabolism, 1, self.metabolism) == 1 then
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


