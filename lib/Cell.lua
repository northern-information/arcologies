Cell = {}

function Cell:new(x, y, g)
  local c = setmetatable({}, { __index = Cell })

  -- constants
  c.x = x
  c.y = y
  c.id = id(c.x, c.y)
  c.generation = g

  -- mutable
  c.structure = 1
  c.metabolism = 4
  c.sound = 72
  c.ports = {"n", "e", "s", "w"}

  return c
end

function Cell:set_metabolism(m)
  self.structure = m
end

function Cell:set_sound(s)
  self.structure = s
end

function Cell:open_port(p)
  if not self:check_port(p) then
    table.insert(self.ports, p)
  end
end

function Cell:close_port(p)
  if self:check_port(p) then
    table.remove(self.ports, p)
  end
end

function Cell:is_port_open(p)
  return tu.contains(self.ports, p)
end
