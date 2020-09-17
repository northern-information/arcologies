resilience_trait = {}

resilience_trait.init = function(self)

  self.setup_resilience = function(self)
    self.resilience = 50
  end

  self.set_resilience = function(self, i)
    self.resilience = util.clamp(i, 0, 100)
    self.callback(self, "set_resilience")
  end

end