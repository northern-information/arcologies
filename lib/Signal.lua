Signal = {}

function Signal:new(x, y, h, g)
  local s = setmetatable({}, { __index = Signal })
  s.generation = (g or counters.music_generation)
  s.x = x
  s.y = y
  s.id = "signal-" .. fn.id()  -- unique identifier for this signal
  s.index = fn.index(x, y) -- location on the grid
  s.heading = h
  return s
end

function Signal:set_heading(h)
  self.heading = h
end

function Signal:propagate()
  if self.generation < counters.music_generation then
        if self.heading == "n" then self.y = self.y - 1
    elseif self.heading == "e" then self.x = self.x + 1
    elseif self.heading == "s" then self.y = self.y + 1
    elseif self.heading == "w" then self.x = self.x - 1
    end
    self.index = self.x + ((self.y - 1) * fn.grid_width())
    if not fn.in_bounds(self.x, self.y) then
      self.index = nil
      keeper:register_delete_signal(self.id)
    end
  end
end

function Signal:reroute(x, y, h)
  self.x = x
  self.y = y
  self.heading = h
  self.index = fn.index(x, y)
end