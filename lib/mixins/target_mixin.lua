target_mixin = {}

target_mixin.init = function(self)

  self.setup_target = function(self)
    self.target_key = "TARGET"
    self.target_min = 1
    self.target_max = #self.modulation_targets
    self.target = "METABOLISM" -- default
    self:register_save_key("target")
    self:register_menu_getter(self.target_key, self.target_menu_getter)
    self:register_menu_setter(self.target_key, self.target_menu_setter)
    self:register_arc_style({
      key = self.target_key,
      style_getter = function() return "glowing_divided" end,
      style_max_getter = function() return 240 end,
      sensitivity = .05,
      offset = 240,
      wrap = false,
      snap = true,
      min = self.target_min,
      max = self.target_max,
      value_getter = self.get_target_index,
      value_setter = self.set_target_index
    })
    self:register_modulation_target({
      key = self.target_key,
      inc = self.target_increment,
      dec = self.target_decrement
    })
  end

  self.target_increment = function(self, i)
    local value = i ~= nil and i or 1
    self:set_target_index(self:get_target_index() + value)
  end

  self.target_decrement = function(self, i)
    local value = i ~= nil and i or 1
    self:set_target_index(self:get_target_index() - value)
  end

  self.get_target_index = function(self)
    for index, v in ipairs(self.modulation_targets) do
      if v.key == self.target then
        return index
      end
    end
  end

  self.set_target_index = function(self, i)
    self:set_target(self.modulation_targets[i].key)
  end

  self.get_target = function(self)
    return self.target
  end

  self.set_target = function(self, s)
    self.target = s
    self.callback(self, "set_target")
  end

  self.target_menu_getter = function(self)
    return self:get_target()
  end

  self.target_menu_setter = function(self, i)
    self:set_target_index(util.clamp(self:get_target_index() + i, self.target_min, self.target_max))
  end

end