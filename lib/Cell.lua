Cell = {}

function Cell:new(x, y, g)
  local c = setmetatable({}, { __index = Cell })

  -- constants
  c.x = x
  c.y = y
  c.id = id(c.x, c.y)
  c.generation = g

  -- mutable
  c.selected = false
  c.structure = "HIVE"
  c.metabolism = 4
  c.sound = 72
  c.ports = {}

  return c
end

-- tired, left off here. can't get the last cell to be cleared from grid
function Cell:select()
  self.selected = true
end

function Cell:deselect()
  self.selected = false
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
