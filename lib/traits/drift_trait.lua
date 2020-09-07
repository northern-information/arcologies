drift_trait = {}

drift_trait.init = function(self)

  self.setup_drift = function(self)
    self.drift = 1
    self.drift_values = {"N/S", "E/W", "???"}
  end

  self.set_drift = function(self, i)
    self.drift = util.clamp(i, 1, 3)
    self.callback(self, 'set_drift')
  end

  self.get_drift_value = function(self)
    return self.drift_values[self.drift]
  end

end