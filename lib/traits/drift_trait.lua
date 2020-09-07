drift_trait = {}

drift_trait.init = function(self)

  self.setup_drift = function(self)
    self.drift = 4
  end

  self.set_drift = function(self, i)
    self.drift = util.clamp(i, 0, 100)
    self.callback(self, 'set_drift')
  end

end