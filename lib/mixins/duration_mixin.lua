duration_mixin = {}

duration_mixin.init = function(self)

  self.setup_duration = function(self)
    self.duration_key = "DURATION"
    self.duration = 1
    self:register_menu_getter(self.duration_key, self.duration_menu_getter)
    self:register_menu_setter(self.duration_key, self.duration_menu_setter)
  end

  self.get_duration = function(self)
    return self.duration
  end

  self.set_duration = function(self, i)
    self.duration = util.clamp(i, 1, 16)
    self.callback(self, "set_duration")
  end

  self.duration_menu_getter = function(self)
    return self:get_duration()
  end

  self.duration_menu_setter = function(self, i)
    self:set_duration(self.duration + i)
  end

end