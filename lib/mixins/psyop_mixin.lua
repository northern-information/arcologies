-- requires target
-- requires territory
psyop_mixin = {}

psyop_mixin.init = function(self)

  self.setup_psyop = function(self)
    self.psyop_key = "PSYOP"
    self.psyop = 0
    self.psyop_min = -3
    self.psyop_max = 3
    self:register_save_key("psyop")
    self:register_menu_getter(self.psyop_key, self.psyop_menu_getter)
    self:register_menu_setter(self.psyop_key, self.psyop_menu_setter)
    self:register_arc_style({
      key = self.psyop_key,
      style_getter = function() return "glowing_fulcrum" end,
      style_max_getter = function() return 240 end,
      sensitivity = .05,
      offset = 240,
      wrap = false,
      snap = false,
      min = self.psyop_min,
      max = self.psyop_max,
      value_getter = self.get_psyop,
      value_setter = self.set_psyop
    })
    self:register_modulation_target({
      key = self.psyop_key,
      inc = self.psyop_increment,
      dec = self.psyop_decrement
    })
  end

  self.psyop_increment = function(self, i)
    local value = i ~= nil and i or 1
    self:set_psyop(self:get_psyop() + value)
  end

  self.psyop_decrement = function(self, i)
    local value = i ~= nil and i or 1
    self:set_psyop(self:get_psyop() - value)
  end

  self.get_psyop = function(self)
    return self.psyop
  end

  self.set_psyop = function(self, i)
    self.psyop = util.clamp(i, self.psyop_min, self.psyop_max)
    self:psyop_check()
    self.callback(self, "set_psyop")
  end

  self.psyop_check = function(self)
    if self.psyop == 3 then
      self:psyop_engage("increment")
      self:set_psyop(0)
    elseif self.psyop == -3 then
      self:psyop_engage("decrement")
      self:set_psyop(0)
    end
    
  end

  self.psyop_menu_getter = function(self)
    return graphics:psyop_animation(self:get_psyop())
  end

  self.psyop_menu_setter = function(self, i)
    self:set_psyop(self.psyop + i)
  end

  self.psyop_signal_adaptor = function(self, signal_heading)
    -- s and w ports increment, while n and e decrement
    local direction = (signal_heading == "s" or signal_heading == "w") and "increment" or "decrement"
    self:psyop_engage(direction)
  end

  -- todo refactor into less nesting
  self.psyop_engage = function(self, direction)
    for k, cell in pairs(keeper.cells) do
      if self:within_fringes(cell.x, cell.y) and cell.id ~= self.id then
        for kk, modulation_target in pairs(cell.modulation_targets) do
          if modulation_target.key == self.target then
            if direction == "increment" then
              modulation_target.inc(cell)
            elseif direction == "decrement" then
              modulation_target.dec(cell)
            end
          end
        end
      end
    end
  end

end