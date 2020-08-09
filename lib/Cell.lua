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
  c.generation = g
  c.index = x + ((y - 1) * grid_width())

  -- mutable
  c.structure = 1
  c.metabolism = 4
  c.sound = 72
  c.velocity = 127
  c.ports = {}

  return c
end

function Cell:set_structure(s)
  self.structure = s
end

function Cell:set_metabolism(m)
  self.metabolism = m
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
