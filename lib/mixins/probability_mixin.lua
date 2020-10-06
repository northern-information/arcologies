probability_mixin = {}

probability_mixin.init = function(self)

  self.setup_probability = function(self)
    self.probability_key = "PROBABILITY"
    self.probability = 50
    self.probability_min = 0
    self.probability_max = 100
    self:register_save_key("probability")
    self:register_menu_getter(self.probability_key, self.probability_menu_getter)
    self:register_menu_setter(self.probability_key, self.probability_menu_setter)
    self:register_arc_style({
      key = self.probability_key,
      style_getter = function() return "glowing_segment" end,
      style_max_getter = function() return 240 end,
      sensitivity = .5,
      offset = 240,
      wrap = false,
      snap = false,
      min = self.probability_min,
      max = self.probability_max,
      value_getter = self.get_probability,
      value_setter = self.set_probability
    })
  end

  self.get_probability = function(self)
    return self.probability
  end

  self.set_probability = function(self, i)
    self.probability = util.clamp(i, self.probability_min, self.probability_max)
    self.callback(self, "set_probability")
  end

  self.probability_menu_getter = function(self)
    return self:get_probability() .. "%"
  end

  self.probability_menu_setter = function(self, i)
    self:set_probability(self.probability + i)
  end

end