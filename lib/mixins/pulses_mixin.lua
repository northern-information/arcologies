-- requires metabolism
pulses_mixin = {}

pulses_mixin.init = function(self)

  self.setup_pulses = function(self)
    self.pulses_key = "PULSES"
    self.pulses = 0
    self.pulses_min = 0
    self.pulses_max = self:get_metabolism()
    self:register_save_key("pulses")
    self:register_menu_getter(self.pulses_key, self.pulses_menu_getter)
    self:register_menu_setter(self.pulses_key, self.pulses_menu_setter)
    self:register_arc_style({
      key = self.pulses_key,
      style_getter = function() return "sweet_sixteen" end,
      style_max_getter = function() return 360 end,
      sensitivity = .05,
      offset = 180,
      wrap = false,
      snap = true,
      min = self.pulses_min,
      max = self.pulses_max,
      value_getter = self.get_pulses,
      value_setter = self.set_pulses
    })
    self:register_modulation_target({
      key = self.pulses_key,
      inc = self.pulses_increment,
      dec = self.pulses_decrement
    })
  end

  self.pulses_increment = function(self, i)
    local value = i ~= nil and i or 1
    self:set_pulses(self:get_pulses() + value)
  end

  self.pulses_decrement = function(self, i)
    local value = i ~= nil and i or 1
    self:set_pulses(self:get_pulses() - value)
  end

  self.get_pulses = function(self)
    return self.pulses
  end

  self.set_pulses = function(self, i)
    self.pulses = util.clamp(i, self.pulses_min, self.pulses_max)
    self.callback(self, "set_pulses")
  end

  self.pulses_menu_getter = function(self)
    return self:get_pulses()
  end

  self.pulses_menu_setter = function(self, i)
    self:set_pulses(self.pulses + i)
  end

  self.set_pulses_max = function(self, i)
    self.pulses_max = i
    self.arc_styles.PULSES.max = i
  end

end