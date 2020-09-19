probability_mixin = {}

probability_mixin.init = function(self)

  self.setup_probability = function(self)
    self.probability_key = "PROBABILITY"
    self.probability = 50
    self:register_menu_getter(self.probability_key, self.probability_menu_getter)
    self:register_menu_setter(self.probability_key, self.probability_menu_setter)
  end

  self.get_probability = function(self)
    return self.probability
  end

  self.set_probability = function(self, i)
    self.probability = util.clamp(i, 0, 100)
    self.callback(self, "set_probability")
  end

  self.probability_menu_getter = function(self)
    return self:get_probability() .. "%"
  end

  self.probability_menu_setter = function(self, i)
    self:set_probability(self.probability + i)
  end

end