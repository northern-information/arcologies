offset_mixin = {}

offset_mixin.init = function(self)

  self.setup_offset = function(self)
    self.offset_key = "OFFSET"
    self.offset = 0
    self.offset_min = 0
    self.offset_max = 15
    self:register_save_key("offset")
    self:register_menu_getter(self.offset_key, self.offset_menu_getter)
    self:register_menu_setter(self.offset_key, self.offset_menu_setter)
    self:register_arc_style({
      key = self.offset_key,
      style_getter = function() return "glowing_segment" end,
      style_max_getter = function() return 360 end,
      sensitivity = .05,
      offset = 180, -- style offset, cell offset :)
      wrap = false,
      snap = true,
      min = self.offset_min,
      max = self.offset_max,
      value_getter = self.get_offset,
      value_setter = self.set_offset
    })
   self:register_modulation_target({
      key = self.offset_key,
      inc = self.offset_increment,
      dec = self.offset_decrement
    })
  end

  self.offset_increment = function(self, i)
    local value = i ~= nil and i or 1
    self:set_offset(self:get_offset() + value)
  end

  self.offset_decrement = function(self, i)
    local value = i ~= nil and i or 1
    self:set_offset(self:get_offset() - value)
  end

  self.get_offset = function(self)
    return self.offset
  end

  self.set_offset = function(self, i)
    self.offset = util.clamp(i, self.offset_min, self.offset_max)
    self.callback(self, "set_offset")
  end

  self.offset_menu_getter = function(self)
    return self:get_offset()
  end

  self.offset_menu_setter = function(self, i)
    self:set_offset(self.offset + i)
  end

end