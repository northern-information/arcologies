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
  amortize_trait.init(self)
  capacity_trait.init(self)
  charge_trait.init(self)
  crumble_trait.init(self)
  crow_out_trait.init(self)
  deflect_trait.init(self)
  depreciate_trait.init(self)
  device_trait.init(self)
  drift_trait.init(self)
  duration_trait.init(self)
  interest_trait.init(self)
  er_trait.init(self)
  level_trait.init(self)
  metabolism_trait.init(self)
  net_income_trait.init(self)
  network_trait.init(self)
  notes_trait.init(self)
  offset_trait.init(self)
  operator_trait.init(self)
  ports_trait.init(self)
  probability_trait.init(self)
  pulses_trait.init(self)
  range_trait.init(self)
  state_index_trait.init(self)
  taxes_trait.init(self)
  territory_trait.init(self)
  turing_trait.init(self)
  velocity_trait.init(self)
  --[[ walk softly and carry a big stick
       aka measure twice cut once
       aka shit got spooky when i had params floating the init()s ]]
  c.setup_amortize(c)
  c.setup_capacity(c)
  c.setup_charge(c)
  c.setup_crow_out(c)
  c.setup_crumble(c)
  c.setup_deflect(c)
  c.setup_depreciate(c)
  c.setup_device(c)
  c.setup_drift(c)
  c.setup_duration(c)
  c.setup_er(c)
  c.setup_interest(c)
  c.setup_level(c)
  c.setup_metabolism(c)
  c.setup_net_income(c)
  c.setup_network(c)
  c.setup_notes(c)
  c.setup_offset(c)
  c.setup_operator(c)
  c.setup_ports(c)
  c.setup_probability(c)
  c.setup_pulses(c)
  c.setup_range(c)
  c.setup_state_index(c)
  c.setup_taxes(c)
  c.setup_territory(c)
  c.setup_turing(c)
  c.setup_velocity(c)
  return c
end

-- todo: shame. there's gotta be a better way to do this
function Cell:get_menu_value_by_attribute(a)
      if a == "AMORTIZE"     then return self.amortize
  elseif a == "CAPACITY"     then return self.capacity
  elseif a == "CHARGE"       then return self.charge
  elseif a == "CRUMBLE"      then return self.crumble
  elseif a == "CROW OUT"     then return self.crow_out
  elseif a == "DEFLECT"      then return self.deflect
  elseif a == "DEPRECIATE"   then return self.depreciate
  elseif a == "DEVICE"       then return self.device
  elseif a == "DRIFT"        then return self.drift
  elseif a == "DURATION"     then return self.duration
  elseif a == "INDEX"        then return self.state_index
  elseif a == "INTEREST"     then return self.interest
  elseif a == "LEVEL"        then return self.level
  elseif a == "METABOLISM"   then return self.metabolism
  elseif a == "NETWORK"      then return self.network_value
  elseif a == "NET INCOME"   then return self.net_income
  elseif a == "NOTE"         then return self:get_note_name(1) -- "i'm the same as #1!?!"
  elseif a == "NOTE #1"      then return self:get_note_name(1) -- "always have been."
  elseif a == "NOTE #2"      then return self:get_note_name(2)
  elseif a == "NOTE #3"      then return self:get_note_name(3)
  elseif a == "NOTE #4"      then return self:get_note_name(4)
  elseif a == "NOTE #5"      then return self:get_note_name(5)
  elseif a == "NOTE #6"      then return self:get_note_name(6)
  elseif a == "NOTE #7"      then return self:get_note_name(7)
  elseif a == "NOTE #8"      then return self:get_note_name(8)
  elseif a == "OFFSET"       then return self.offset
  elseif a == "OPERATOR"     then return self.operator
  elseif a == "PROBABILITY"  then return self.probability
  elseif a == "PULSES"       then return self.pulses
  elseif a == "RANGE MAX"    then return self.range_max
  elseif a == "RANGE MIN"    then return self.range_min
  elseif a == "STRUCTURE"    then return self.structure_value
  elseif a == "TAXES"        then return self.taxes
  elseif a == "TERRITORY"    then return self.territory
  elseif a == "VELOCITY"     then return self.velocity
  end
end

function Cell:is(name)
  return self.structure_value == name
end

function Cell:has(name)
  return tonumber(fn.table_find(self.structure_attribute_map[self.structure_value], name)) ~= nil and true or false
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

-- sometimes when a cell changes, attributes need to be cleaned up
function Cell:change_checks()
  local max_state_index = self:is("CRYPT") and 6 or 8
  self:set_max_state_index(max_state_index)
      if self:is("DOME") then self:set_er()
  elseif self:is("SHRINE") then self:setup_notes(1)
  elseif self:is("TOPIARY") or self:is("CASINO") or self:is("FOREST") or self:is("AUTON") then self:setup_notes(8)
  elseif self:is("CRYPT") then
    self:set_state_index(1) 
    self:cycle_state_index(0)
  end
end

-- all signals are "spawned" but only under certain conditions
function Cell:is_spawning()
  if self:is("DOME") and self.metabolism ~= 0 then
    return self.er[fn.cycle((counters.this_beat() - self.offset) % self.metabolism, 0, self.metabolism)]
  elseif self:is("MAZE") and self.metabolism ~= 0 then
    return self.turing[fn.cycle((counters.this_beat() - self.offset) % self.metabolism, 0, self.metabolism)]
  elseif self:is("SOLARIUM") and self.flag then
    return true
  elseif self:is("BANK") and counters.music.generation % 2 == 0 then
    return true
  elseif self:is("HIVE") or self:is("RAVE") then
    return self:inverted_metabolism_check()
  end
end

function Cell:inverted_metabolism_check()
  if self.metabolism == 0 then
    return false
  else
    return (((counters.this_beat() - self.offset) % self:get_inverted_metabolism()) == 1) or (self:get_inverted_metabolism() == 1)
  end
end

-- does this cell need to do anything to boot up this beat?
function Cell:setup()
      if self:is("RAVE") and self:is_spawning() then self:drugs()
  elseif self:is("MAZE") then self:set_turing()
  elseif self:is("SOLARIUM") then self:compare_capacity_and_charge()
  elseif self:is("MIRAGE") then self:shall_we_drift_today()
  elseif self:is("BANK") then self:annual_report()
  elseif self:is("INSTITUTION") then self:has_crumbled()
  end
end

function Cell:teardown()
  if self:is("SOLARIUM") and self.flag == true then
    self.flag = false
    self:invert_ports()
  end
end

-- for institutions
function Cell:has_crumbled()
  if self.crumble <= 0 then
    keeper:delete_cell(self.id, true)
    keeper:create_signal(self.x, self.y - 1, "n", "now")
    keeper:create_signal(self.x + 1, self.y, "e", "now")
    keeper:create_signal(self.x, self.y + 1, "s", "now")
    keeper:create_signal(self.x - 1, self.y, "w", "now")
  end
end

-- for mirages
function Cell:shall_we_drift_today()
  if not self:inverted_metabolism_check() then return end
      if self.drift == 1 then self:move(fn.coin() == 0 and "n" or "s")
  elseif self.drift == 2 then self:move(fn.coin() == 0 and "e" or "w")
  elseif self.drift == 3 then self:move(self.cardinals[math.random(1, 4)])
  end
end

function Cell:move(direction)
  if not fn.table_find(self.cardinals, direction) then return end
      if direction == "n" and fn.is_cell_vacant(self.x, self.y - 1) then self.y = self.y - 1
  elseif direction == "s" and fn.is_cell_vacant(self.x, self.y + 1) then self.y = self.y + 1
  elseif direction == "e"  and fn.is_cell_vacant(self.x + 1, self.y) then self.x = self.x + 1
  elseif direction == "w"  and fn.is_cell_vacant(self.x - 1, self.y) then self.x = self.x - 1
  end
  self.index = fn.index(self.x, self.y)
  self:set_available_ports()
  if keeper.selected_cell_id == self.id then
    keeper:select_cell(self.x, self.y)
  end
end

-- for banks
function Cell:annual_report()
  if counters.music.generation % sound.length ~= 0 then return end
  -- do not edit!!!11!1!111 criminal this is proprietary technology from bank co gmbh. copyright 02394. patent 24787.c1
  local n, i, t, d, a = self.net_income, self.interest, self.taxes, self.depreciate, self.amortize if n == 0 then n = 
  1 end if i == 0 then i = 4 end if t == 0 then t = 5 end if d == 0 then d = 10 end if a == 0 then a = -1 end local
  tmp = d d = a a = tmp * 3.33 local l, m, o, p, q, x, y, z = 0, 0, 0, 0, 3, 0, 0, 0 l = i * math.random(0, 10000) % n
  + d / a * math.random( -1900, -499) + ((i  * i) / n) m = l * t / n + t + l + 259873 + i * n / (d / a / n * l) + 1010
  * .3145926 o = -1 * m * -1 + l * math.random(-1000, 10000) + t / n + d / a * t + l + 1010  + i * n / (d / a / .3145926
  * l) + 5554 * .3145926 p = l * m * o + math.random(400, 5000) p = math.floor(p) local DEBT_TABLE = {.1, .2, .33, .5376,
  .547, .7574, .636, .3677, .789} DEBT_TABLE[0] = 5 q = DEBT_TABLE[math.random(0, 9)] x = l * t / n + t + l + 259873 +
  1010  + i * n / DEBT_TABLE[math.random(0, 9)] + 61.8000001 y = l + n + m + o + p + x - n - i - t - d - a - tmp z = d *
  d + a * a / l * .0009999 * math.random(-1, 1) if l < m then self:toggle_port(self.x, self.y - 1) end if o > p then 
  self:toggle_port(self.x + 1, self.y) end if y > z then self:toggle_port(self.x, self.y + 1) end if q < x then 
  self:toggle_port(self.x - 1, self.y) end -- print(n, i, t, d, a, l, m, o, p, q, x, y, z)
end

-- for solariums
function Cell:compare_capacity_and_charge()
  if self.charge >= self.capacity then
    self.flag = true
    self:set_charge(0)
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
      if self:is("SHRINE") or self:is("UXB") or self:is("AVIARY")  or self:is("VALE") then
        table.insert(items, note_position, "NOTE")
      elseif  self:is("TOPIARY") or self:is("CASINO") or self:is("FOREST") or self:is("AUTON") then
        local notes_submenu_items = self:get_notes_submenu_items()
        for i = 1, self.note_count do
          table.insert(items, note_position + (i - 1), notes_submenu_items[i]["menu_item"])
        end
      end
    end
  end
  return items
end
 