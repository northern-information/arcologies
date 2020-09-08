territory_trait = {}

territory_trait.init = function(self)

  self.setup_territory = function(self)
    self.territory = 1
    self.territory_values = {"N", "E", "S", "W", "N/E", "S/E", "S/W", "N/W", "ALL"}
  end

  self.set_territory = function(self, i)
    self.territory = util.clamp(i, 1, 9)
    self.callback(self, "set_territory")
  end

  self.get_territory_value = function(self)
    return self.territory_values[self.territory]
  end

  self.has_other_cell_in_territory = function(self, serf_cell)
    local t = self.territory
    local x, y, sx, sy = self.x, self.y, serf_cell.x, serf_cell.y
    if (t == 1 and y >= sy) -- n
    or (t == 2 and x <= sx) -- e
    or (t == 3 and y <= sy) -- s
    or (t == 4 and x >= sx) -- w
    or (t == 5 and y >= sy and x <= sx) -- ne
    or (t == 6 and y <= sy and x <= sx) -- se
    or (t == 7 and y <= sy and x >= sx) -- sw
    or (t == 8 and y >= sy and x >= sx) -- nw
    or (t == 9) then
      return true
    else
      return false
    end
  end

end