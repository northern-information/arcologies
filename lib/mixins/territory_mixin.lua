territory_mixin = {}

territory_mixin.init = function(self)

  self.setup_territory = function(self)
    self.territory_key = "TERRITORY"
    self.territory = 1
    self.territory_menu_values = {"NORTH", "EAST", "SOUTH", "WEST", "N/E", "S/E", "S/W", "N/W", "ALL", "FRINGES"}
    self.territory_min = 1
    self.territory_max = #self.territory_menu_values
    self:register_save_key("territory")
    self:register_menu_getter(self.territory_key, self.territory_menu_getter)
    self:register_menu_setter(self.territory_key, self.territory_menu_setter)
    self:register_arc_style({
      key = self.territory_key,
      style_getter = function() return "glowing_territory" end,
      style_max_getter = function() return 360 end,
      sensitivity = .01,
      offset = 0,
      wrap = false,
      snap = true,
      min = self.territory_min,
      max = self.territory_max,
      value_getter = self.get_territory,
      value_setter = self.set_territory
    })
  end

  self.get_territory = function(self)
    return self.territory
  end

  self.set_territory = function(self, i)
    self.territory = util.clamp(i, self.territory_min, self.territory_max)
    self.callback(self, "set_territory")
  end

  self.territory_menu_getter = function(self)
    return self.territory_menu_values[self:get_territory()]
  end

  self.territory_menu_setter = function(self, i)
    self:set_territory(self.territory + i)
  end

  self.has_other_cell_in_territory = function(self, serf_cell)
    local t = self.territory
    local x, y, sx, sy = self.x, self.y, serf_cell.x, serf_cell.y
    if (t == 1 and y >= sy) -- north
    or (t == 2 and x <= sx) -- east
    or (t == 3 and y <= sy) -- south
    or (t == 4 and x >= sx) -- west
    or (t == 5 and y >= sy and x <= sx) -- ne
    or (t == 6 and y <= sy and x <= sx) -- se
    or (t == 7 and y <= sy and x >= sx) -- sw
    or (t == 8 and y >= sy and x >= sx) -- nw
    or (t == 9) -- all
    or (t == 10 and self:within_fringes(sx, sy)) then
      return true
    else
      return false
    end
  end

  self.get_fringes = function(self)
    return {
      x1 = self.x - 1,
      y1 = self.y - 1,
      x2 = self.x + 1,
      y2 = self.y + 1
    }
  end

  self.within_fringes = function(self, x, y)
    local f = self:get_fringes()
     if x >= f.x1 
    and x <= f.x2
    and y >= f.y1
    and y <= f.y2
    then
        return true
    else
      return false
    end
  end

  self.get_territory_coordinates = function(self)
    local x1, y1, x2, y2 = 0, 0, 0, 0
    local cell_x = self.x
    local cell_y = self.y
    local width_min, height_min = 1, 1
    local width_max = fn.grid_width()
    local height_max = fn.grid_height()
    local t = self.territory_menu_values[self.territory]

    if (t == "NORTH") then
      x1 = width_min
      y1 = height_min
      x2 = width_max
      y2 = cell_y
    elseif (t == "EAST") then
      x1 = cell_x
      y1 = height_min
      x2 = width_max
      y2 = height_max
    elseif (t == "SOUTH") then
      x1 = width_min
      y1 = cell_y
      x2 = width_max
      y2 = height_max
    elseif (t == "WEST") then
      x1 = width_min
      y1 = height_min
      x2 = cell_x
      y2 = height_max
    elseif (t == "N/E") then
      x1 = cell_x
      y1 = height_min
      x2 = width_max
      y2 = cell_y
    elseif (t == "S/E") then
      x1 = cell_x
      y1 = cell_y
      x2 = width_max
      y2 = height_max
    elseif (t == "S/W") then
      x1 = width_min
      y1 = cell_y
      x2 = cell_x
      y2 = height_max
    elseif (t == "N/W") then
      x1 = width_min
      y1 = height_min
      x2 = cell_x
      y2 = cell_y
    elseif (t == "ALL") then
      x1 = width_min
      y1 = height_min
      x2 = width_max
      y2 = height_max
    elseif (t == "FRINGES") then
      local f = self:get_fringes()
      x1 = f.x1
      y1 = f.y1
      x2 = f.x2
      y2 = f.y2
    end
    
    return { x1 = x1, y1 = y1, x2 = x2, y2 = y2 }
  end

end  