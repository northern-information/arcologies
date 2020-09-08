range_trait = {}

range_trait.init = function(self)

  self.setup_range = function(self)
    self.range_min = 0
    self.range_max = 100
  end

  self.set_range_min = function(self, i)
    self.range_min = util.clamp(i, 0, 100)
    self.range_max = util.clamp(self.range_max, self.range_min, 100)
    self.callback(self, "set_range_min")
  end

  self.set_range_max = function(self, i)
    self.range_max = util.clamp(i, 0, 100)
    self.range_min = util.clamp(self.range_min, 0, self.range_max)
    self.callback(self, "set_range_max")
  end

end