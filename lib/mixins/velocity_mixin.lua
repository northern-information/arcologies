velocity_mixin = {}

velocity_mixin.init = function(self)

  self.setup_velocity = function(self)
    self.velocity_key = "VELOCITY"
    self.velocity = 127
    self.velocity_min = 0
    self.velocity_max = 127
    self:register_save_key("velocity")
    self:register_menu_getter(self.velocity_key, self.velocity_menu_getter)
    self:register_menu_setter(self.velocity_key, self.velocity_menu_setter)
    self:register_arc_style({
      key = self.velocity_key,
      style_getter = function() return "glowing_segment" end,
      style_max_getter = function() return 240 end,
      sensitivity = .5,
      offset = 240,
      wrap = false,
      snap = false,
      min = self.velocity_min,
      max = self.velocity_max,
      value_getter = self.get_velocity,
      value_setter = self.set_velocity
    })
  end

  self.get_velocity = function(self)
    return self.velocity
  end

  self.set_velocity = function(self, i)
    self.velocity = util.clamp(i, self.velocity_min, self.velocity_max)
    self.callback(self, "set_velocity")
  end

  self.velocity_menu_getter = function(self)
    return self:get_velocity()
  end

  self.velocity_menu_setter = function(self, i)
    self:set_velocity(self.velocity + i)
  end

end