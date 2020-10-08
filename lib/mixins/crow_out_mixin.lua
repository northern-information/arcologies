crow_out_mixin = {}

crow_out_mixin.init = function(self)

  self.setup_crow_out = function(self)
    self.crow_out_key = "CROW OUT"
    self.crow_out = 1
    self:register_save_key("crow_out")
    self.crow_out_menu_values = {"1/2", "3/4"}
    self:register_menu_getter(self.crow_out_key, self.crow_out_menu_getter)
    self:register_menu_setter(self.crow_out_key, self.crow_out_menu_setter)
    self:register_arc_style({
      key = self.crow_out_key,
      style_getter = function() return "glowing_divided" end,
      style_max_getter = function() return 240 end,
      sensitivity = .05,
      offset = 240,
      wrap = false,
      snap = true,
      min = 1,
      max = 2,
      value_getter = self.get_crow_out,
      value_setter = self.set_crow_out
    })
  end

  self.get_crow_out = function(self)
    return self.crow_out
  end

  self.set_crow_out = function(self, i)
    self.crow_out = util.clamp(i, 1, 2)
    self.callback(self, "set_crow_out")
  end

  self.crow_out_menu_getter = function(self)
    return self.crow_out_menu_values[self:get_crow_out()]
  end

  self.crow_out_menu_setter = function(self, i)
    self:set_crow_out(self.crow_out + i)
  end

end