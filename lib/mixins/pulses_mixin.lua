-- requires metabolism
pulses_mixin = {}

pulses_mixin.init = function(self)

  self.setup_pulses = function(self)
    self.pulses_key = "PULSES"
    self.pulses = 0
    self:register_save_key("pulses")
    self:register_menu_getter(self.pulses_key, self.pulses_menu_getter)
    self:register_menu_setter(self.pulses_key, self.pulses_menu_setter)
  end

  self.get_pulses = function(self)
    return self.pulses
  end

  self.set_pulses = function(self, i)
    self.pulses = util.clamp(i, 0, self:get_metabolism())
    self.callback(self, "set_pulses")
  end

  self.pulses_menu_getter = function(self)
    return self:get_pulses()
  end

  self.pulses_menu_setter = function(self, i)
    self:set_pulses(self.pulses + i)
  end

end