velocity_trait = {}

velocity_trait.init = function(self)

  self.setup_velocity = function(self)
    self.velocity = 127
  end

  self.set_velocity = function(self, i)
    self.velocity = util.clamp(i, 0, 127)
    self.callback(self, "set_velocity")
  end

end