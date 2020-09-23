offset_mixin = {}

offset_mixin.init = function(self)

  self.setup_offset = function(self)
    self.offset_key = "OFFSET"
    self.offset = 0
    self:register_save_key("offset")
    self:register_menu_getter(self.offset_key, self.offset_menu_getter)
    self:register_menu_setter(self.offset_key, self.offset_menu_setter)
  end

  self.get_offset = function(self)
    return self.offset
  end

  self.set_offset = function(self, i)
    self.offset = util.clamp(i, 0, 15)
    self.callback(self, "set_offset")
  end

  self.offset_menu_getter = function(self)
    return self:get_offset()
  end

  self.offset_menu_setter = function(self, i)
    self:set_offset(self.offset + i)
  end

end