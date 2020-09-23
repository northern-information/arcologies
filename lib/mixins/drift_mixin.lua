drift_mixin = {}

drift_mixin.init = function(self)

  self.setup_drift = function(self)
    self.drift_key = "DRIFT"
    self.drift = 1
    self:register_save_key("drift")
    self.drift_menu_values = {"N/S", "E/W", "???"}
    self:register_menu_getter(self.drift_key, self.drift_menu_getter)
    self:register_menu_setter(self.drift_key, self.drift_menu_setter)
  end

  self.get_drift = function(self)
    return self.drift
  end

  self.set_drift = function(self, i)
    self.drift = util.clamp(i, 1, 3)
    self.callback(self, "set_drift")
  end

  self.drift_menu_getter = function(self)
    return self.drift_menu_values[self:get_drift()]
  end

  self.drift_menu_setter = function(self, i)
    self:set_drift(self.drift + i)
  end

end