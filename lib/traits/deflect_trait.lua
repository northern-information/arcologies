deflect_trait = {}

deflect_trait.init = function(self)

  self.setup_deflect = function(self)
    self.deflect = 1
    self.deflect_values = {"NORTH", "EAST", "SOUTH", "WEST"}
  end

  self.set_deflect = function(self, i)
    self.deflect = util.clamp(i, 1, 4)
    self.callback(self, "set_deflect")
  end

  self.get_deflect_value = function(self)
    return self.deflect_values[self.deflect]
  end

end