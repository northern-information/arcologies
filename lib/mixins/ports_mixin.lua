-- ports are unique and don't follow the menu_getter / menu_setter pattern
-- because that is done directly on the grid
ports_mixin = {}

ports_mixin.init = function(self, x, y)

  self.setup_ports = function(self)
    self.ports = {}
    self:register_save_key("ports")
    self.cardinals = { "n", "e", "s", "w" }
    self:set_available_ports()
  end

  self.set_available_ports = function(self)
    self.available_ports = {
      { self.x, self.y - 1, "n" },
      { self.x + 1, self.y, "e" },
      { self.x, self.y + 1, "s" },
      { self.x - 1, self.y, "w" }
    }
  end

  self.toggle_port = function(self, x, y)
    local port = self:find_port(x, y)
    if not port then return end
    if self:is_port_open(port[3]) then
      self:close_port(port[3])
    else
      self:open_port(port[3])
    end
  end

  self.find_port = function(self, x, y)
    if not fn.in_bounds(x, y) then return false end
    for k, v in pairs(self.available_ports) do
      if v[1] == x  and v[2] == y then
        return v
      end
    end
    return false
  end

  self.is_port_open = function(self, p)
    return tu.contains(self.ports, p)
  end

  self.open_port = function(self, p)
    table.insert(self.ports, p)
  end

  self.close_port = function(self, p)
    table.remove(self.ports, fn.table_find(self.ports, p))
  end

  self.close_all_ports = function(self, p)
    self.ports = {}
  end

  self.invert_ports = function(self)
    for k,v in pairs(self.available_ports) do
      self:toggle_port(v[1], v[2])
    end
  end
end