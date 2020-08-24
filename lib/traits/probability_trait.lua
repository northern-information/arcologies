probability_trait = {}

probability_trait.init = function(self)

  self.setup_probability = function(self)
    self.probability = 50
  end

  self.set_probability = function(self, i)
    self.probability = util.clamp(i, 0, 100)
    self.callback(self, 'set_probability')
  end

end