-- requires metabolism
-- requires pulses
er_trait = {}

er_trait.init = function(self)

  self.setup_er = function(self)
    self.er = {}
  end

  self.set_er = function(self)
    self.er = {}
    self.er = er.gen(self.pulses, self.metabolism)
    self.callback(self, "set_er")
  end

end