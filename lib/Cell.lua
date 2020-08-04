Cell = {}

function Cell:new(x, y, g)
  local c = setmetatable({}, { __index = Cell })

  -- constants
  c.x = (x or 0)
  c.y = (y or 0)
  c.id = "X" .. c.x .. "Y" .. c.y
  c.generation = (g or 0)

  -- mutable
  c.structure = "HIVE"
  c.metabolism = 4
  c.sound = 72
  c.ports = {}

  return c
end

function Cell:structure(s)
  self.structure = s
end

function Cell:metabolism(m)
  self.structure = m
end

function Cell:sound(s)
  self.structure = s
end

function Cell:open_port(p)
  table.insert(self.ports, p)
end

function Cell:close_port(p)
  table.remove(self.ports, p)
end

function Cell:check_port(p)
  return tu.contains(self.ports, p)
end
