depreciate_trait = {}

depreciate_trait.init = function(self)

  self.setup_depreciate = function(self)
    self.depreciate = 4
  end

  self.set_depreciate = function(self, i)
    self.depreciate = util.clamp(i, 0, 100)
    self.callback(self, 'set_depreciate')
  end

end