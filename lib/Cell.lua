Cell = {}

function Cell:new(x, y, g)
  local c = setmetatable({}, { __index = Cell })
  c.x = x ~= nil and x or 0
  c.y = y ~= nil and y or 0
  c.generation = g ~= nil and g or 0
  c.structures = config.structures
  c.attributes = config.attributes
  c.structure_attribute_map = config.structure_attribute_map
  c.id = "cell-" .. fn.id() -- unique identifier for this cell
  c.index = fn.index(c.x, c.y) -- location on the grid
  c.state_index = 1  -- keeps track of cell state i.e. which note to play next
  c.max_state_index = 8
  c.structure_key = 1
  c.structure_value = c.structures[c.structure_key]
  c.ports = {}
  c.cardinals = { "n", "e", "s", "w" }
  c.available_ports = {
    { c.x, c.y - 1, "n" },
    { c.x + 1, c.y, "e" },
    { c.x, c.y + 1, "s" },
    { c.x - 1, c.y, "w" }
  }
  er_trait.init(self)
  metabolism_trait.init(self)
  notes_trait.init(self)
  offset_trait.init(self)
  probability_trait.init(self)
  pulses_trait.init(self)
  turing_trait.init(self)
  velocity_trait.init(self)
  return c
end

function Cell:is(name)
  return self.structure_value == name
end

function Cell:has(name)
  return fn.table_find(self.structure_attribute_map[self.structure_value], name) or false
end

function Cell:change(name)
  self:set_structure_by_key(fn.table_find(self.structures, name))
end

function Cell:set_structure_by_key(key)
  self.structure_key = util.clamp(key, 1, #self.structures)
  self.structure_value = self.structures[self.structure_key]
  self:callback("set_structure_by_key")
end

function Cell:cycle_state_index(i)
  self.state_index = fn.cycle(self.state_index + i, 1, self.max_state_index)
end

function Cell:toggle_port(x, y)
  local port = self:find_port(x, y)
  if not port then return end
  if self:is_port_open(port[3]) then
    self:close_port(port[3])
  else
    self:open_port(port[3])
  end
end

function Cell:find_port(x, y)
  if not fn.in_bounds(x, y) then return false end
  for k,v in pairs(self.available_ports) do
    if v[1] == x and v[2] == y then
      return v
    end
  end
  return false
end

function Cell:is_port_open(p)
  return tu.contains(self.ports, p)
end

function Cell:open_port(p)
  table.insert(self.ports, p)
end

function Cell:close_port(p)
  table.remove(self.ports, fn.table_find(self.ports, p))
end

function Cell:invert_ports()
  for k,v in pairs(self.available_ports) do
    self:toggle_port(v[1], v[2])
  end
end

-- menu junk
function Cell:menu_items()
 return self.structure_attribute_map[self.structure_value]
end

-- todo: there's gotta be a better way to do this
function Cell:get_menu_value_by_attribute(a)
      if a == "INDEX"       then return self.state_index  
  elseif a == "METABOLISM"  then return self.metabolism
  elseif a == "OFFSET"      then return self.offset
  elseif a == "PROBABILITY" then return self.probability
  elseif a == "PULSES"      then return self.pulses
  elseif a == "STRUCTURE"   then return self.structure_value  
  elseif a == "VELOCITY"    then return self.velocity
  elseif a == "NOTE 1"      then return self:get_note_name(1)
  elseif a == "NOTE 2"      then return self:get_note_name(2)
  elseif a == "NOTE 3"      then return self:get_note_name(3)
  elseif a == "NOTE 4"      then return self:get_note_name(4)
  elseif a == "NOTE 5"      then return self:get_note_name(5)
  elseif a == "NOTE 6"      then return self:get_note_name(6)
  elseif a == "NOTE 7"      then return self:get_note_name(7)
  elseif a == "NOTE 8"      then return self:get_note_name(8)
  end
end



--[[
from here out we get into what is essentially "descendent class behaviors"
since all cells can change structures at any time, it makes no sense to 
actually implement classes for each one. that would result in lots of
creating and destroying objects for no real benefit other than having these
behaviors encapsulated in their own classes. and as of writing this
theres  only ~40 lines of code below... 
]]


-- does this cell need to do anything to boot up this beat?
function Cell:setup()
  if self:is("RAVE") then self:drugs() end
  if self:is("DOME") then self:set_er() end
  if self:is("MAZE") then self:set_turing() end
end

-- turn on, tune in, drop out... close all the ports, then flip coins to open them
function Cell:drugs()
  self.ports = {}
  for i = 1,4 do
    if fn.coin() == 1 then
      self:open_port(self.cardinals[i])
    end
  end
end

-- all signals are "spawned" but only under certain conditions
function Cell:is_spawning()
  if self.metabolism == 0 then
    return false
  elseif self:is("DOME") then
    return self.er[fn.cycle((counters.this_beat() - self.offset) % self.metabolism, 0, self.metabolism)]
  elseif self:is("MAZE") then
    return self.turing[fn.cycle((counters.this_beat() - self.offset) % self.metabolism, 0, self.metabolism)]
  elseif ((counters.this_beat() - self.offset) % self.metabolism) == 1 then
        if self:is("HIVE") then return true
    elseif self:is("RAVE") then return true
       end
  end
  return false
end

-- to keep traits reasonably indempotent, even though the have to interact with one another
function Cell:callback(method)
  if method == "set_structure_by_key" then
    self:set_note_count()
  elseif method == "set_metabolism" then
    if self:has("PULSES") and self.pulses > self.metabolism then self.pulses = self.metabolism end
    if self:is("DOME") then self:set_er() end
  elseif method == "set_pulses" then
    if self:is("DOME") then self:set_er() end
  elseif method == "set_notes" then
    self:set_note_count(self:is("TOPIARY") and 8 or 1)
  end
end