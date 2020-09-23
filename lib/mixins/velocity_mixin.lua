velocity_mixin = {}

velocity_mixin.init = function(self)

  self.setup_velocity = function(self)
    self.velocity_key = "VELOCITY"
    self.velocity = 127
    self:register_save_key("velocity")
    self:register_menu_getter(self.velocity_key, self.velocity_menu_getter)
    self:register_menu_setter(self.velocity_key, self.velocity_menu_setter)
  end

  self.get_velocity = function(self)
    return self.velocity
  end

  self.set_velocity = function(self, i)
    self.velocity = util.clamp(i, 0, 127)
    self.callback(self, "set_velocity")
  end

  self.velocity_menu_getter = function(self)
    return self:get_velocity()
  end

  self.velocity_menu_setter = function(self, i)
    self:set_velocity(self.velocity + i)
  end

end