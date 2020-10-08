mapping_mixin = {}

mapping_mixin.init = function(self)

  self.setup_mapping = function(self)
    self.mapping_key = "MAPPING"
    self.mapping = 1
    self:register_save_key("mapping")
    self:register_menu_getter(self.mapping_key, self.mapping_menu_getter)
    self:register_menu_setter(self.mapping_key, self.mapping_menu_setter)
  end

  self.get_mapping = function(self)
    return self.mapping
  end

  self.set_mapping = function(self, i)
    self.mapping = util.clamp(i, 1, 4)
    self.callback(self, "set_mapping")
  end

  self.mapping_menu_getter = function(self)
    return self:get_mapping()
  end

  self.mapping_menu_setter = function(self, i)
    self:set_mapping(self.mapping + i)
  end

end