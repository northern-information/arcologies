Cell = {}

function Cell:new(x, y, g)
  local c = setmetatable({}, { __index = Cell })

  -- constants
  c.x = x
  c.y = y
  c.id = fn.id()
  c.available_ports = {
    { c.x, c.y - 1, "n" },
    { c.x + 1, c.y, "e" },
    { c.x, c.y + 1, "s" },
    { c.x - 1, c.y, "w" }
  }
  c.available_structures = { "HIVE", "SHRINE", "GATE", "RAVE" }
  c.attributes = { "STRUCTURE", "OFFSET", "NOTE", "VELOCITY", "DOCS" }
  c.generation = g
  c.index = fn.index(x, y)
  c.structure_attribute_map = {
    ["HIVE"] = {"OFFSET"},
    ["SHRINE"] = {"NOTE", "VELOCITY"},
    ["GATE"] = {},
    ["RAVE"] = {"ENERGY"}
  }
  for k,v in pairs(c.structure_attribute_map) do
    c.structure_attribute_map[k][#c.structure_attribute_map[k] + 1] = "STRUCTURE"
    c.structure_attribute_map[k][#c.structure_attribute_map[k] + 1] = "DOCS"
  end

  -- mutable
  c.ports = {}
  c.structure = 1
  c.offset = 0
  c.note = 72 -- gonna need to do some work here once the sound/midi stuff is done
  c.velocity = 127

  return c
end

function Cell:menu_items()
      if self.structure == 1 then return self.structure_attribute_map["HIVE"]
  elseif self.structure == 2 then return self.structure_attribute_map["SHRINE"]
  elseif self.structure == 3 then return self.structure_attribute_map["GATE"]
  elseif self.structure == 4 then return self.structure_attribute_map["RAVE"]
  end
end

function Cell:get_menu_value_by_attribute(attribute)
  if attribute == "STRUCTURE" then return self.available_structures[self.structure] end
  if attribute == "OFFSET"    then return self.offset end
  if attribute == "NOTE"     then return self:get_note_name() end
  if attribute == "VELOCITY"  then return self.velocity end
end

function Cell:set_structure(i)
  self.structure = i
end

function Cell:cycle_structure(i)
  self:set_structure(fn.cycle(self.structure + i, 1, #self.available_structures))
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