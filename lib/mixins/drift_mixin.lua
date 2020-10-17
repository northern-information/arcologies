drift_mixin = {}

drift_mixin.init = function(self)

  self.setup_drift = function(self)
    self.drift_key = "DRIFT"
    self.drift = 1
    self.drift_min = 1
    self.drift_max = 3
    self:register_save_key("drift")
    self.drift_menu_values = {"N/S", "E/W", "???"}
    self:register_menu_getter(self.drift_key, self.drift_menu_getter)
    self:register_menu_setter(self.drift_key, self.drift_menu_setter)
    self:register_arc_style({
      key = self.drift_key,
      style_getter = function() return "glowing_drift" end,
      style_max_getter = function() return 360 end,
      sensitivity = .01,
      offset = 0,
      wrap = false,
      snap = true,
      min = self.drift_min,
      max = self.drift_max,
      value_getter = self.get_drift,
      value_setter = self.set_drift
    })
    self:register_modulation_target({
      key = self.drift_key,
      inc = self.drift_increment,
      dec = self.drift_decrement
    })
  end

  self.drift_increment = function(self, i)
    local value = i ~= nil and i or 1
    self:set_drift(self:get_drift() + value)
  end

  self.drift_decrement = function(self, i)
    local value = i ~= nil and i or 1
    self:set_drift(self:get_drift() - value)
  end

  self.get_drift = function(self)
    return self.drift
  end

  self.set_drift = function(self, i)
    self.drift = util.clamp(i, self.drift_min, self.drift_max)
    self.callback(self, "set_drift")
  end

  self.drift_menu_getter = function(self)
    return self.drift_menu_values[self:get_drift()]
  end

  self.drift_menu_setter = function(self, i)
    self:set_drift(self.drift + i)
  end

end