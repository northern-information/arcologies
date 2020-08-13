Cell = {}

function Cell:new(x, y, g)
  local c = setmetatable({}, { __index = Cell })

  -- constants
  c.x = x
  c.y = y
  c.id = fn.id(c.x, c.y)
  c.available_ports = {
    { c.x, c.y - 1, "n" },
    { c.x + 1, c.y, "e" },
    { c.x, c.y + 1, "s" },
    { c.x - 1, c.y, "w" }
  }
  c.available_structures = { "HIVE", "SHRINE", "GATE" }
  c.attributes = { "STRUCTURE", "OFFSET", "SOUND", "VELOCITY" }
  c.generation = g
  c.index = x + ((y - 1) * fn.grid_width())

  -- mutable
  c.ports = {}
  c.structure = 1
  c.offset = 0
  c.note = 72 -- gonna need to do some work here once the sound/midi stuff is done
  c.velocity = 127

  return c
end

function Cell:set_structure(i)
  self.structure = fn.cycle(i, 1, #self.available_structures)
end

function Cell:set_offset(i)
  self.offset = fn.cycle(i, 0, 15)
end

function Cell:set_note(i)
  self.note = mu.snap_note_to_array(util.clamp(i, 1, 144), sound.notes_in_this_scale)
end

function Cell:set_velocity(i)
  self.velocity = util.clamp(i, 0, 127)
end

function Cell:toggle_port(x, y)
  local port = self:find_port(x, y)
  if self:is_port_open(port[3]) then
    self:close_port(port[3])
  else
    self:open_port(port[3])
  end
end

function Cell:open_port(p)
  table.insert(self.ports, p)
end

function Cell:close_port(p)
  table.remove(self.ports, fn.table_find(self.ports, p))
end

function Cell:is_port_open(p)
  return tu.contains(self.ports, p)
end

function Cell:find_port(x, y)
  for k,v in pairs(self.available_ports) do
    if v[1] == x and v[2] == y then
      return v
    end
  end
  return false
end

function Cell:cycle_structure()
  self:set_structure(self.structure + 1)
end

function Cell:get_note_name()
  return mu.note_num_to_name(self.note, true)
end