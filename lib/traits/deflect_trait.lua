deflect_trait = {}

deflect_trait.init = function(self)

  self.setup_deflect = function(self)
    self.deflect = 4
  end

  self.set_deflect = function(self, i)
    self.deflect = util.clamp(i, 0, 100)
    self.callback(self, 'set_deflect')
  end

end