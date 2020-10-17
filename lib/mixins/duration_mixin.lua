duration_mixin = {}

duration_mixin.init = function(self)

  self.setup_duration = function(self)
    self.duration_key = "DURATION"
    self.duration = 1
    self.duration_min = 1
    self.duration_max = 16
    self:register_save_key("duration")
    self:register_menu_getter(self.duration_key, self.duration_menu_getter)
    self:register_menu_setter(self.duration_key, self.duration_menu_setter)
    self:register_arc_style({
      key = self.duration_key,
      style_getter = function() return "sweet_sixteen" end,
      style_max_getter = function() return 360 end,
      sensitivity = .05,
      offset = 180,
      wrap = false,
      snap = true,
      min = self.duration_min,
      max = self.duration_max,
      value_getter = self.get_duration,
      value_setter = self.set_duration
    })
    self:register_modulation_target({
      key = self.duration_key,
      inc = self.duration_increment,
      dec = self.duration_decrement
    })
  end

  self.duration_increment = function(self, i)
    local value = i ~= nil and i or 1
    self:set_duration(self:get_duration() + value)
  end

  self.duration_decrement = function(self, i)
    local value = i ~= nil and i or 1
    self:set_duration(self:get_duration() - value)
  end

  self.get_duration = function(self)
    return self.duration
  end

  self.set_duration = function(self, i)
    self.duration = util.clamp(i, self.duration_min, self.duration_max)
    self.callback(self, "set_duration")
  end

  self.duration_menu_getter = function(self)
    return self:get_duration()
  end

  self.duration_menu_setter = function(self, i)
    self:set_duration(self.duration + i)
  end

end