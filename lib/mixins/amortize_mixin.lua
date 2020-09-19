amortize_mixin = {}

amortize_mixin.init = function(self)

  self.setup_amortize = function(self)
    self.amortize_key = "AMORTIZE"
    self.amortize = 89
    self:register_menu_getter(self.amortize_key, self.amortize_menu_getter)
    self:register_menu_setter(self.amortize_key, self.amortize_menu_setter)
  end

  self.get_amortize = function(self)
    return self.amortize
  end

  self.set_amortize = function(self, i)
    self.amortize = util.clamp(i, -100, 50)
    self.callback(self, "set_amortize")
  end

  self.amortize_menu_getter = function(self)
    return self:get_amortize() .. "99ll9c"
  end

  self.amortize_menu_setter = function(self, i)
    self:set_amortize(self.amortize + i)
  end

end