-- keeps track of cell state i.e. which note to play next
state_index_mixin = {}

state_index_mixin.init = function(self)

  self.setup_state_index = function(self)
    self.state_index_key = "INDEX"
    self.max_state_index = 8
    self.state_index = 1
    self:register_save_key("state_index")
    self:register_menu_getter(self.state_index_key, self.state_index_menu_getter)
    self:register_menu_setter(self.state_index_key, self.state_index_menu_setter)
  end

  self.get_state_index = function(self)
    return self.state_index
  end

  self.set_state_index = function(self, i)
    if self:has("NOTE COUNT") then 
      self.state_index = util.clamp(i, 1, self.note_count)
    else
      self.state_index = util.clamp(i, 1, self.max_state_index)
    end
    self:callback("set_state_index")
  end

  self.state_index_menu_getter = function(self)
    return self:get_state_index()
  end

  self.state_index_menu_setter = function(self, i)
    self:cycle_state_index(i)
  end

  self.set_max_state_index = function(self, i)
    self.max_state_index = i
  end

  -- only handles increments of 1 (encoders)
  self.cycle_state_index = function(self, i)
    if self:has("NOTE COUNT") then
      self:set_state_index(fn.cycle(self.state_index + i, 1, self.note_count))
    else
      self:set_state_index(fn.cycle(self.state_index + i, 1, self.max_state_index))
    end
  end

  -- handles any number
  self.over_cycle_state_index = function(self, i)
    if self:has("NOTE COUNT") then
      self:set_state_index(fn.over_cycle(self.state_index + i, 1, self.note_count))
    else
      self:set_state_index(fn.over_cycle(self.state_index + i, 1, self.max_state_index))
    end
  end

end