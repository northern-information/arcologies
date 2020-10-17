device_mixin = {}

device_mixin.init = function(self)

  self.setup_device = function(self)
    self.device_key = "DEVICE"
    self.device = 1
    self.device_min = 1
    self.device_max = 4
    self:register_save_key("device")
    self:register_menu_getter(self.device_key, self.device_menu_getter)
    self:register_menu_setter(self.device_key, self.device_menu_setter)
    self:register_arc_style({
      key = self.device_key,
      style_getter = function() return "glowing_segment" end,
      style_max_getter = function() return 240 end,
      sensitivity = .05,
      offset = 240,
      wrap = false,
      snap = false,
      min = self.device_min,
      max = self.device_max,
      value_getter = self.get_device,
      value_setter = self.set_device
    })
    self:register_modulation_target({
      key = self.device_key,
      inc = self.device_increment,
      dec = self.device_decrement
    })
  end

  self.device_increment = function(self, i)
    local value = i ~= nil and i or 1
    self:set_device(self:get_device() + value)
  end

  self.device_decrement = function(self, i)
    local value = i ~= nil and i or 1
    self:set_device(self:get_device() - value)
  end

  self.get_device = function(self)
    return self.device
  end

  self.set_device = function(self, i)
    self.device = util.clamp(i, self.device_min, self.device_max)
    self.callback(self, "set_device")
  end

  self.device_menu_getter = function(self)
    return self:get_device()
  end

  self.device_menu_setter = function(self, i)
    self:set_device(self.device + i)
  end

end