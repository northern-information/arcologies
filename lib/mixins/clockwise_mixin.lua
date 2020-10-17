clockwise_mixin = {}

clockwise_mixin.init = function(self)

  self.setup_clockwise = function(self)
    self.clockwise_key = "CLOCKWISE"
    self.clockwise = true
    self:register_save_key("clockwise")
    self.clockwise_menu_values = { "YES", "COUNTER" }
    self:register_menu_getter(self.clockwise_key, self.clockwise_menu_getter)
    self:register_menu_setter(self.clockwise_key, self.clockwise_menu_setter)
    self:register_arc_style({
      key = self.clockwise_key,
      style_getter = function() return "glowing_clock" end,
      style_max_getter = function() return 360 end,
      sensitivity = .05,
      offset = 0,
      wrap = false,
      snap = false,
      min = 0,
      max = 1,
      value_getter = self.clockwise_boolean_to_int_getter,
      value_setter = self.clockwise_menu_setter
    })
    self:register_modulation_target({
      key = self.clockwise_key,
      inc = self.clockwise_increment,
      dec = self.clockwise_decrement
    })
  end

  self.clockwise_increment = function(self, i)
    self:set_clockwise(true)
  end

  self.clockwise_decrement = function(self, i)
    self:set_clockwise(false)
  end

  self.get_clockwise = function(self)
    return self.clockwise
  end

  self.set_clockwise = function(self, bool)
    self.clockwise = bool
    self.callback(self, "set_clockwise")
  end

  self.clockwise_menu_getter = function(self)
    local key = self:get_clockwise() and 1 or 2
    return self.clockwise_menu_values[key]
  end

  self.clockwise_menu_setter = function(self, i)
    self:set_clockwise(i > 0)
  end

  self.clockwise_boolean_to_int_getter = function(self)
    return self.clockwise and 1 or 0
  end

end