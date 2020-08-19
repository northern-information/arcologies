Cell = {}

function Cell:new(x, y, g)
  local c = setmetatable({}, { __index = Cell })

  -- constants
  c.x = x ~= nil and x or 0
  c.y = y ~= nil and y or 0
  c.generation = g ~= nil and g or 0
  c.id = fn.id()
  c.cardinals = { "n", "e", "s", "w" }
  c.structures = { "HIVE", "SHRINE", "GATE", "RAVE" }
  c.attributes = { "STRUCTURE", "OFFSET", "NOTE", "VELOCITY", "METABOLISM", "DOCS" }
  c.metabolisms = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 }
  c.index = fn.index(c.x, c.y)
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

function Cell:set_offset(i)
  self.offset = i
end

function Cell:cycle_offset(i)
  self:set_offset(fn.cycle(self.offset + i, 0, 15))
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
  -- port[3] is where the direction string is stored
  if self:is_port_open(port[3]) then -- also is this sloppy?
    self:close_port(port[3])
  else
    self:open_port(port[3])
  end
end

function Cell:find_port(x, y)
  local available_ports = {
    { self.x, self.y - 1, "n" },
    { self.x + 1, self.y, "e" },
    { self.x, self.y + 1, "s" },
    { self.x - 1, self.y, "w" }
  }
  for k,v in pairs(available_ports) do
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

function Cell:is_it_time()
  -- metabolism of 0 is mute
  if self.metabolism == 0 then
    return false
  end


  if fn.cycle((counters.this_beat() - self.offset) % self.metabolism, 1, self.metabolism) == 1 then
    return true
  end



  -- shift offset up one because a zero offset means we're on the down beat
  -- elseif (self.offset + 1 == counters.this_beat()) % self.metabolism == 0 then 
  -- elseif (counters.this_beat() / self.metabolism == 4) then
  --   return true
    -- print("metabolism:")
    -- print(self.metabolism)
    -- print("this_beat:")
    -- print(counters.this_beat())
    -- -- hrmmm
    -- return counters.this_beat() 
  return false
end

-- divergent cell structures

function Cell:is_spawning()
  -- print(self.offset + 1 == counters.this_beat())
  -- print(self:is_it_time())
  -- print("=========")
  -- print(self:it_is_time())
  if self:is("HIVE") and self:is_it_time() then
    return true
  elseif self:is("RAVE") and self:is_it_time() then
    return true
  end
  return false
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


