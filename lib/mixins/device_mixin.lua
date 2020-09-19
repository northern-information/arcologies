device_mixin = {}

device_mixin.init = function(self)

  self.setup_device = function(self)
    self.device_key = "DEVICE"
    self.device = 1
    self:register_menu_getter(self.device_key, self.device_menu_getter)
    self:register_menu_setter(self.device_key, self.device_menu_setter)
  end

  self.get_device = function(self)
    return self.device
  end

  self.set_device = function(self, i)
    self.device = util.clamp(i, 1, 4)
    self.callback(self, "set_device")
  end

  self.device_menu_getter = function(self)
    return self:get_device()
  end

  self.device_menu_setter = function(self, i)
    self:set_device(self.device + i)
  end

end