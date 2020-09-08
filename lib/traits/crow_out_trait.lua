crow_out_trait = {}

crow_out_trait.init = function(self)

  self.setup_crow_out = function(self)
    self.crow_out = 1
  end

  self.set_crow_out = function(self, i)
    self.crow_out = util.clamp(i, 1, 2)
    self.callback(self, "set_crow_out")
  end

end