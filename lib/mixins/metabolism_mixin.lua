-- requires offset
metabolism_mixin = {}

metabolism_mixin.init = function(self)

  self.setup_metabolism = function(self)
    self.metabolism_key = "METABOLISM"
    self.metabolism = 13
    self:register_menu_getter(self.metabolism_key, self.metabolism_menu_getter)
    self:register_menu_setter(self.metabolism_key, self.metabolism_menu_setter)
  end

  self.get_metabolism = function(self)
    return self.metabolism
  end

  self.set_metabolism = function(self, i)
    self.metabolism = util.clamp(i, 0, 16)
    self.callback(self, "set_metabolism")
  end

  self.metabolism_menu_getter = function(self)
    return self:get_metabolism()
  end

  self.metabolism_menu_setter = function(self, i)
    self:set_metabolism(self.metabolism + i)
  end

  self.get_metabolism_steps = function(self)
    local steps = {}
    steps[0]  = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    steps[1]  = {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    steps[2]  = {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1}
    steps[3]  = {1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0}
    steps[4]  = {1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0}
    steps[5]  = {1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0}
    steps[6]  = {1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0}
    steps[7]  = {1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0}
    steps[8]  = {1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0}
    steps[9]  = {1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0}
    steps[10] = {1,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0}
    steps[11] = {1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0}
    steps[12] = {1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1}
    steps[13] = {1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0}
    steps[14] = {1,0,0,1,0,0,1,0,0,1,0,0,1,0,0,1}
    steps[15] = {1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0}
    steps[16] = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1} 
    local to_bools = {}
    for k,v in pairs(steps[self:get_metabolism()]) do
      table.insert(to_bools, v == 1)
    end
    return to_bools
  end

  self.get_inverted_metabolism = function(self)
    -- could do this as a loop but this doubles as a developer guide
    local i = {}
    i[0]  = 0
    i[1]  = 16
    i[2]  = 15
    i[3]  = 14
    i[4]  = 13
    i[5]  = 12
    i[6]  = 11
    i[7]  = 10
    i[8]  = 9
    i[9]  = 8
    i[10] = 7
    i[11] = 6
    i[12] = 5
    i[13] = 4
    i[14] = 3
    i[15] = 2
    i[16] = 1
    return i[self:get_metabolism()]
  end

  self.inverted_metabolism_check = function(self)
    if self.metabolism == 0 then
      return false
    else
      return (((counters:this_beat() - self.offset) % self:get_inverted_metabolism()) == 1) or (self:get_inverted_metabolism() == 1)
    end
  end

end