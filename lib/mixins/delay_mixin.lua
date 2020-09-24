delay_mixin = {}

delay_mixin.init = function(self)

  self.setup_delay = function(self)
    self.delay_key = "DELAY"
    self.delay = 100
    self:register_save_key("delay")
    self:register_menu_getter(self.delay_key, self.delay_menu_getter)
    self:register_menu_setter(self.delay_key, self.delay_menu_setter)
  end

  self.get_delay = function(self)
    return self.delay
  end

  self.set_delay = function(self, i)
    self.delay = util.clamp(i, 0, 100)
    self.callback(self, "set_delay")
  end

  self.delay_menu_getter = function(self)
    return "[" .. self:get_delay() .. "]"
  end

  self.delay_menu_setter = function(self, i)
    self:set_delay(self.delay + i)
  end

end