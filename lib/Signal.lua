Signal = {}

function Signal:new(x, y, h, g)
  local s = setmetatable({}, { __index = Signal })

  -- constants
  s.generation = (g or fn.generation())

  -- mutable
  s.x = x
  s.y = y
  s.id = fn.id()
  s.heading = h
  s.index = fn.index(x, y)

  return s
end

function Signal:set_heading(h)
  self.heading = h
end

function Signal:propagate()
  if self.generation < fn.generation() then
    if self.heading == "n" then
      self.y = self.y - 1
    elseif self.heading == "e" then
      self.x = self.x + 1
    elseif self.heading == "s" then
      self.y = self.y + 1
    elseif self.heading == "w" then
      self.x = self.x - 1
    end
    self.index = self.x + ((self.y - 1) * fn.grid_width())
    if not fn.in_bounds(self.x, self.y) then
      keeper:register_delete_signal(self.id)
    end
  end
end