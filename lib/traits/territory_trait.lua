territory_trait = {}

territory_trait.init = function(self)

  self.setup_territory = function(self)
    self.territory = 4
  end

  self.set_territory = function(self, i)
    self.territory = util.clamp(i, 0, 100)
    self.callback(self, 'set_territory')
  end

end