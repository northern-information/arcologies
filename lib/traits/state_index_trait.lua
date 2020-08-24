-- keeps track of cell state i.e. which note to play next
state_index_trait = {}

state_index_trait.init = function(self)

  self.setup_state_index = function(self)
    self.max_state_index = 8
    self.state_index = 1
  end

  self.set_state_index = function(self, i)
    self.state_index = util.clamp(i, 1, self.max_state_index)
    self:callback("set_state_index")
  end

  self.set_max_state_index = function(self, i)
    self.max_state_index = i
  end

  self.cycle_state_index = function(self, i)
    self:set_state_index(fn.cycle(self.state_index + i, 1, self.max_state_index))
  end

end




