amortize_trait = {}

amortize_trait.init = function(self)

  self.setup_amortize = function(self)
    self.amortize = 4
  end

  self.set_amortize = function(self, i)
    self.amortize = util.clamp(i, 0, 100)
    self.callback(self, 'set_amortize')
  end

end