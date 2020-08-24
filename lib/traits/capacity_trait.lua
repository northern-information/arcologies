capacity_trait = {}

capacity_trait.init = function(self)

  self.setup_capacity = function(self)
    self.capacity = 4
  end

  self.set_capacity = function(self, i)
    self.capacity = util.clamp(i, 0, 100)
    self.callback(self, 'set_capacity')
  end

end