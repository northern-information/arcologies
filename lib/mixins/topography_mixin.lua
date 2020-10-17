-- requires state_index
-- requires notes
topography_mixin = {}

topography_mixin.init = function(self)

  self.setup_topography = function(self)
    self.topography_key = "TOPOGRAPHY"
    self.topography = 1
    self.topography_min = 1
    self.topography_max = 4
    self:register_save_key("topography")
    self.topography_menu_values = {">>>>", "<<<<", ">><<", "DRUNK"}
    self.topography_pendulum = true
    self:register_menu_getter(self.topography_key, self.topography_menu_getter)
    self:register_menu_setter(self.topography_key, self.topography_menu_setter)
    self:register_arc_style({
      key = self.topography_key,
      style_getter = function() return "glowing_topography" end,
      style_max_getter = function() return 360 end,
      sensitivity = .01,
      offset = 0,
      wrap = false,
      snap = false,
      min = self.topography_min,
      max = self.topography_max,
      value_getter = self.get_topography,
      value_setter = self.set_topography
    })
    self:register_modulation_target({
      key = self.topography_key,
      inc = self.topography_increment,
      dec = self.topography_decrement
    })
  end

  self.topography_increment = function(self, i)
    local value = i ~= nil and i or 1
    self:set_topography(self:get_topography() + value)
  end

  self.topography_decrement = function(self, i)
    local value = i ~= nil and i or 1
    self:set_topography(self:get_topography() - value)
  end

  self.get_topography = function(self)
    return self.topography
  end

  self.get_topography_string = function(self)
    local s = self.topography_menu_values[self:get_topography()]
    if s == "DRUNK" then
      local out = ""
      for i = 1, 4 do
        out = out .. ((fn.coin() == 0) and "<" or ">")
      end
      return out
    else
      return s
    end
  end

  self.set_topography = function(self, i)
    self.topography = util.clamp(i, self.topography_min, self.topography_max)
    self.callback(self, "set_topography")
  end

  self.topography_menu_getter = function(self)
    return self:get_topography_string()
  end

  self.topography_menu_setter = function(self, i)
    self:set_topography(self.topography + i)
  end

  self.topography_operation = function(self)
    local s = self.topography_menu_values[self:get_topography()]
    if s == ">>>>" then
      return 1
    elseif s == "<<<<" then
      return -1
    elseif s == ">><<" then
      if self.state_index == 1 then
        self.topography_pendulum = true
      elseif self.state_index == self.note_count then
        self.topography_pendulum = false
      end
      if self.topography_pendulum then
        return 1
      else
        return -1
      end
    elseif s == "DRUNK" then
      return math.random(1, self.note_count)
    end
  end

end