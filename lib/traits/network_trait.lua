network_trait = {}

network_trait.init = function(self)

  self.setup_network = function(self)
    self.networks = {
      "A", "B", "C", "D", "E", "F", "G", "H", 
      "I", "J", "K", "L", "M", "N", "O", "P", 
      "Q", "R", "S", "T", "U", "V", "W", "X", 
      "Y", "Z"
    }
    self:set_network(1)
  end

  self.set_network = function(self, key)
    self.network_key = util.clamp(key, 1, 26)
    self.network_value = self.networks[self.network_key]
    self.callback(self, "set_network")
  end

  self.get_network_value = function(self, key)
    return self.networks[util.clamp(key, 1, 26)]
  end

end