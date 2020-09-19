network_mixin = {}

network_mixin.init = function(self)

  self.setup_network = function(self)
    self.network_key = "NETWORK"
    self.network = 1
    self.network_menu_values = {
      "A", "B", "C", "D", "E", "F", "G", "H", 
      "I", "J", "K", "L", "M", "N", "O", "P", 
      "Q", "R", "S", "T", "U", "V", "W", "X", 
      "Y", "Z"
    }
    self:register_menu_getter(self.network_key, self.network_menu_getter)
    self:register_menu_setter(self.network_key, self.network_menu_setter)
  end

  self.get_network = function(self)
    return self.network
  end

  self.set_network = function(self, i)
    self.network = util.clamp(i, 1, 26)
    self.callback(self, "set_network")
  end

  self.network_menu_getter = function(self)
    return self.network_menu_values[self:get_network()]
  end

  self.network_menu_setter = function(self, i)
    self:set_network(self.network + i)
  end

end