-- requires metabolism
-- requires pulses
er_mixin = {}

er_mixin.init = function(self)

  self.setup_er = function(self)
    self.er_key = "ER"
    self.er = {}
  end

  self.get_er = function(self)
    return self.er
  end

  self.set_er = function(self, i)
    self.er = {}
    self.er = er.gen(self.pulses, self.metabolism)
    self.callback(self, "set_er")
  end

end