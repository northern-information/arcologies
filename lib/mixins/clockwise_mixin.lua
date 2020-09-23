clockwise_mixin = {}

clockwise_mixin.init = function(self)

  self.setup_clockwise = function(self)
    self.clockwise_key = "CLOCKWISE"
    self.clockwise = true
    self:register_save_key("clockwise")
    self.clockwise_menu_values = { "YES", "COUNTER" }
    self:register_menu_getter(self.clockwise_key, self.clockwise_menu_getter)
    self:register_menu_setter(self.clockwise_key, self.clockwise_menu_setter)
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
end