Cell = {}

function Cell:new(x, y, g)
  local c = setmetatable({}, { __index = Cell })

  -- constants
  c.x = x
  c.y = y
  c.id = id(c.x, c.y)
  c.available_ports = {
    { c.x, c.y - 1, "n" },
    { c.x + 1, c.y, "e" },
    { c.x, c.y + 1, "s" },
    { c.x - 1, c.y, "w" }
  }
  c.available_structures = { "HIVE", "SHRINE", "GATE" }
  c.generation = g
  c.index = x + ((y - 1) * grid_width())

  -- mutable
  c.ports = {}
  c.structure = 0
  c.offset = 0
  c.sound = 0
  c.velocity = 0
  c:set_structure(1)
  c:set_offset(0)
  c:set_sound(72)
  c:set_velocity(127)

  return c
end

-- todo "cycle" utility function
function Cell:set_structure(s)
  if s > #self.available_structures then
    self.structure = 1
  elseif s < 1 then
    self.structure = #available_structures
  else
    self.structure = s
  end
end

function Cell:set_offset(o)
  if o > 15 then
    self.offset = 0
  elseif o < 0 then
    self.offset = 15
  else
    self.offset = o
  end
end

function Cell:set_sound(s)
  self.sound = s
end

function Cell:set_velocity(v)
  self.velocity = v
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
  table.remove(self.ports, table_find(self.ports, p))
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
  return mu.note_num_to_name(self.sound, true)
end