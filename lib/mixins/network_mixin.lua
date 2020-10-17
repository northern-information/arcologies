network_mixin = {}

network_mixin.init = function(self)

  self.setup_network = function(self)
    self.network_key = "NETWORK"
    self.network = 1
    self.network_min = 1
    self.network_max = 26
    self:register_save_key("network")
    self.network_menu_values = {
      "A", "B", "C", "D", "E", "F", "G", "H", 
      "I", "J", "K", "L", "M", "N", "O", "P", 
      "Q", "R", "S", "T", "U", "V", "W", "X", 
      "Y", "Z"
    }
    self:register_menu_getter(self.network_key, self.network_menu_getter)
    self:register_menu_setter(self.network_key, self.network_menu_setter)
    self:register_arc_style({
      key = self.network_key,
      style_getter = function() return "glowing_divided" end,
      style_max_getter = function() return 240 end,
      sensitivity = .05,
      offset = 240,
      wrap = false,
      snap = false,
      min = self.network_min,
      max = self.network_max,
      value_getter = self.get_network,
      value_setter = self.set_network
    })
    self:register_modulation_target({
      key = self.network_key,
      inc = self.network_increment,
      dec = self.network_decrement
    })
  end

  self.network_increment = function(self, i)
    local value = i ~= nil and i or 1
    self:set_network(self:get_network() + value)
  end

  self.network_decrement = function(self, i)
    local value = i ~= nil and i or 1
    self:set_network(self:get_network() - value)
  end

  self.get_network = function(self)
    return self.network
  end

  self.set_network = function(self, i)
    self.network = util.clamp(i, self.network_min, self.network_max)
    self.callback(self, "set_network")
  end

  self.network_menu_getter = function(self)
    return self.network_menu_values[self:get_network()]
  end

  self.network_menu_setter = function(self, i)
    self:set_network(self.network + i)
  end

end