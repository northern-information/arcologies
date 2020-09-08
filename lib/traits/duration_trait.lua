duration_trait = {}

duration_trait.init = function(self)

  self.setup_duration = function(self)
    self.duration = 1
  end

  self.set_duration = function(self, i)
     self.duration = util.clamp(i, 1, 16)
     self.callback(self, "set_duration")
  end

end