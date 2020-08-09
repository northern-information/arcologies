Signal = {}

function Signal:new(x, y, h, g)
  local s = setmetatable({}, { __index = Signal })

  -- constants
  s.generation = (g or generation())

  -- mutable
  s.x = x
  s.y = y
  s.id = id(s.x, s.y)
  s.heading = h
  s.index = x + ((y - 1) * grid_width())

  return s
end

function Signal:set_heading(h)
  self.heading = h
end

function Signal:propagate()
  if self.heading == "n" then
    self.y = self.y - 1
  elseif self.heading == "e" then
    self.x = self.x + 1
  elseif self.heading == "s" then
    self.y = self.y + 1
  elseif self.heading == "w" then
    self.x = self.x - 1
  end
  self.id = id(self.x, self.y)
  self.index = self.x + ((self.y - 1) * grid_width())
end