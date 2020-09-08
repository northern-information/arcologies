charge_trait = {}

charge_trait.init = function(self)

  self.setup_charge = function(self)
    self.charge = 0
  end

  self.set_charge = function(self, i)
     self.charge = util.clamp(i, 0, 100)
     self.callback(self, "set_charge")
  end

end