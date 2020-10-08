crumble_mixin = {}

crumble_mixin.init = function(self)

  self.setup_crumble = function(self)
    self.crumble_key = "CRUMBLE"
    self.crumble = 4
    self.crumble_min = 0
    self.crumble_max = 100
    self:register_save_key("crumble")
    self:register_menu_getter(self.crumble_key, self.crumble_menu_getter)
    self:register_menu_setter(self.crumble_key, self.crumble_menu_setter)
    self:register_arc_style({
      key = self.crumble_key,
      style_getter = function() return "glowing_segment" end,
      style_max_getter = function() return 240 end,
      sensitivity = .5,
      offset = 240,
      wrap = false,
      snap = false,
      min = self.crumble_min,
      max = self.crumble_max,
      value_getter = self.get_crumble,
      value_setter = self.set_crumble
    })
  end

  self.get_crumble = function(self)
    return self.crumble
  end

  self.set_crumble = function(self, i)
    self.crumble = util.clamp(i,  self.crumble_min,  self.crumble_max)
    self.callback(self, "set_crumble")
  end

  self.raw_set_crumble = function(self, i)
    self.crumble = i
    self.callback(self, "raw_set_crumble")
  end

  self.crumble_menu_getter = function(self)
    return self:get_crumble()
  end

  self.crumble_menu_setter = function(self, i)
    self:set_crumble(self.crumble + i)
  end

end