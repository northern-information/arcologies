Cell = {}

function Cell:new(x, y, g)
  local c = setmetatable({}, { __index = Cell })
  c.x = x ~= nil and x or 0
  c.y = y ~= nil and y or 0
  c.generation = g ~= nil and g or 0
  c.structure_key = 1 -- new cells default to hives
  c.structures = config.structures
  c.attributes = config.attributes
  c.structure_attribute_map = config.structure_attribute_map
  c.structure_value = c.structures[c.structure_key]
  c.id = "cell-" .. fn.id() -- unique identifier for this cell
  c.index = fn.index(c.x, c.y) -- location on the grid
  c.flag = false -- multipurpse flag used through the keeper:collision() lifecycle
  capacity_trait.init(self)
  charge_trait.init(self)
  er_trait.init(self)
  level_trait.init(self)
  metabolism_trait.init(self)
  network_trait.init(self)
  notes_trait.init(self)
  offset_trait.init(self)
  ports_trait.init(self)
  probability_trait.init(self)
  pulses_trait.init(self)
  range_trait.init(self)
  state_index_trait.init(self)
  turing_trait.init(self)
  velocity_trait.init(self)
  --[[ walk softly and carry a big stick
       aka measure twice cut once
       aka shit got spooky when i had params floating the init()s ]]
  c.setup_capacity(c)
  c.setup_charge(c)
  c.setup_er(c)
  c.setup_level(c)
  c.setup_metabolism(c)
  c.setup_network(c)
  c.setup_notes(c)
  c.setup_offset(c)
  c.setup_ports(c)
  c.setup_probability(c)
  c.setup_pulses(c)
  c.setup_range(c)
  c.setup_state_index(c)
  c.setup_turing(c)
  c.setup_velocity(c)
  return c
end

function Cell:is(name)
  return self.structure_value == name
end

function Cell:has(name)
  return fn.table_find(self.structure_attribute_map[self.structure_value], name) ~= nil or false
end

function Cell:change(name)
  self:set_structure_by_key(fn.table_find(self.structures, name))
end

function Cell:set_structure_by_key(key)
  self.structure_key = util.clamp(key, 1, #self.structures)
  self.structure_value = self.structures[self.structure_key]
  self:change_checks()
end

function Cell:prepare_for_paste(x, y, g)
  self.x = x
  self.y = y
  self.generation = g
  self.id = "cell-" .. fn.id()
  self.index = fn.index(self.x, self.y)
  self.flag = false
  self:set_available_ports()
end

--[[
from here out we get into what is essentially "descendent class behaviors"
since all cells can change structures at any time, it makes no sense to
actually implement classes for each one. that would result in lots of
creating and destroying objects for no real benefit other than having these
behaviors encapsulated in their own classes. and as of writing this
theres  only ~40 lines of code below...
]]

-- somtimes when a cell changes, attributes need to be cleaned up
function Cell:change_checks()
  if self:is("SHRINE") then self:setup_notes(1) end
  if self:is("TOPIARY") then self:setup_notes(8) end
  self:set_max_state_index(self:is("CRYPT") and 6 or 8)
  self:cycle_state_index(0)
end

-- all signals are "spawned" but only under certain conditions
function Cell:is_spawning()
  if self:is("DOME") and self.metabolism ~= 0 then
    return self.er[fn.cycle((counters.this_beat() - self.offset) % self.metabolism, 0, self.metabolism)]
  elseif self:is("MAZE") and self.metabolism ~= 0 then
    return self.turing[fn.cycle((counters.this_beat() - self.offset) % self.metabolism, 0, self.metabolism)]
  elseif (((counters.this_beat() - self.offset) % self.metabolism) == 1 and self.metabolism ~= 0)or self.metabolism == 1 then
    if self:is("HIVE") or self:is("RAVE") then return true end
  elseif self:is("SOLARIUM") and self.flag then
    return true
  end
  return false
end

-- does this cell need to do anything to boot up this beat?
function Cell:setup()
      if self:is("RAVE") and self:is_spawning() then self:drugs()
  elseif self:is("DOME") then self:set_er()
  elseif self:is("MAZE") then self:set_turing()
  elseif self:is("SOLARIUM") then self:compare_capacity_and_charge()
  end
end

function Cell:teardown()
  if self:is("SOLARIUM") and self.flag == true then
    self.flag = false
    self:invert_ports()
  end
end

-- turn on, tune in, drop out... close all the ports, then flip coins to open them
function Cell:compare_capacity_and_charge()
  if self.charge >= self.capacity then
    self.flag = true
    self.charge = 0
    self:invert_ports()
  end
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

-- to keep traits reasonably indempotent, even though the have to interact with one another
function Cell:callback(method)
  if method == "set_state_index" then
    if self:is("CRYPT") then s:crypt_load(self.state_index) end
  elseif method == "set_metabolism" then
    if self:has("PULSES") and self.pulses > self.metabolism then self.pulses = self.metabolism end
    if self:is("DOME") then self:set_er() end
  elseif method == "set_pulses" then
    if self:is("DOME") then self:set_er() end
  end
end

-- menu and submenu junk. gross.
function Cell:menu_items()
  local items = self.structure_attribute_map[self.structure_value]
  if self:has("NOTES") then
    local note_position = fn.table_find(items, "NOTES")
    if type(note_position) == "number" then
      table.remove(items, note_position)
      if self.note_count == 1 then
        table.insert(items, note_position, "NOTE")
      elseif  self.note_count > 1 then
        local notes_submenu_items = self:get_notes_submenu_items()
        for i = 1, self.note_count do
          table.insert(items, note_position + (i - 1), notes_submenu_items[i]["menu_item"])
        end
      end
    end
  end
  return items
end

-- todo: shame. there's gotta be a better way to do this
function Cell:get_menu_value_by_attribute(a)
      if a == "CAPACITY"    then return self.capacity
  elseif a == "CHARGE"      then return self.charge
  elseif a == "CROW OUT"    then return --print("todo")
  elseif a == "DESTINATION" then return --print("todo")
  elseif a == "INDEX"       then return self.state_index
  elseif a == "LEVEL"       then return self.level
  elseif a == "METABOLISM"  then return self.metabolism
  elseif a == "NETWORK"     then return self.network_value
  elseif a == "NOTE"        then return self:get_note_name(1) -- "i'm the same as #1!?!"
  elseif a == "NOTE #1"     then return self:get_note_name(1) -- "always have been."
  elseif a == "NOTE #2"     then return self:get_note_name(2)
  elseif a == "NOTE #3"     then return self:get_note_name(3)
  elseif a == "NOTE #4"     then return self:get_note_name(4)
  elseif a == "NOTE #5"     then return self:get_note_name(5)
  elseif a == "NOTE #6"     then return self:get_note_name(6)
  elseif a == "NOTE #7"     then return self:get_note_name(7)
  elseif a == "NOTE #8"     then return self:get_note_name(8)
  elseif a == "OFFSET"      then return self.offset
  elseif a == "PROBABILITY" then return self.probability
  elseif a == "PULSES"      then return self.pulses
  elseif a == "RANGE MAX"   then return self.range_max
  elseif a == "RANGE MIN"   then return self.range_min
  elseif a == "STRUCTURE"   then return self.structure_value
  elseif a == "VELOCITY"    then return self.velocity
  end
end
 