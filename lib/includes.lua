-- ships with norns
crow = require("crow")
er = require("er")
fs = require("fileselect")
mu = require("musicutil")
te = require("textentry")
tu = require("tabutil")
engine.name = "PolyPerc"


-- stores application configuration and cell composition data
config = include("arcologies/lib/config")
config_ = io.open(_path["code"] .. "arcologies/lib/config_.lua", "r")
if config_ ~= nil then
  io.close(config_)
  include("arcologies/lib/config_")
end

-- the core concept of arcologies, interact with Signals
include("arcologies/lib/Cell")

--[[
traits of cells. adding more minimallly requires:
 - configruration in in config.lua
 - contstructor code in Cell.lua
 - probably some logic in keeper:collision()
 - and i'm not happy about it but work in menu:scroll_value()
   along with Cell:get_menu_value_by_attribute() 
   and fn.load()!
todo: break up get_menu_value_by_attribute into traits...
]]
include("arcologies/lib/traits/amortize_trait")
include("arcologies/lib/traits/capacity_trait")
include("arcologies/lib/traits/channel_trait")
include("arcologies/lib/traits/charge_trait")
include("arcologies/lib/traits/crow_out_trait")
include("arcologies/lib/traits/crumble_trait")
include("arcologies/lib/traits/deflect_trait")
include("arcologies/lib/traits/depreciate_trait")
include("arcologies/lib/traits/device_trait")
include("arcologies/lib/traits/drift_trait")
include("arcologies/lib/traits/duration_trait")
include("arcologies/lib/traits/er_trait")
include("arcologies/lib/traits/interest_trait")
include("arcologies/lib/traits/level_trait")
include("arcologies/lib/traits/network_trait")
include("arcologies/lib/traits/net_income_trait")
include("arcologies/lib/traits/metabolism_trait")
include("arcologies/lib/traits/notes_trait")
include("arcologies/lib/traits/offset_trait")
include("arcologies/lib/traits/operator_trait")
include("arcologies/lib/traits/ports_trait")
include("arcologies/lib/traits/probability_trait")
include("arcologies/lib/traits/pulses_trait")
include("arcologies/lib/traits/range_trait")
include("arcologies/lib/traits/state_index_trait")
include("arcologies/lib/traits/taxes_trait")
include("arcologies/lib/traits/territory_trait")
include("arcologies/lib/traits/turing_trait")
include("arcologies/lib/traits/velocity_trait")

-- emitted by Cells, "bangs" that move n, e, s, w
include("arcologies/lib/Signal")

-- global functions
fn = include("arcologies/lib/functions")

-- all the save and load routines
saveload = include("arcologies/lib/saveload")

-- the whole murder of them
c = include("arcologies/lib/crow")

-- clocks, metros, timing
counters = include("arcologies/lib/counters")

-- in app documentation
docs = include("arcologies/lib/docs")

-- read & write on norns
filesystem = include("arcologies/lib/filesystem")

-- grid interactions and leds
g = include("arcologies/lib/g")

-- structure glyph drawings
glyphs = include("arcologies/lib/glyphs")

-- all norns screen rendering
graphics = include("arcologies/lib/graphics")

--[[
"keeper" is state machine for Cells and Signals

a lot of the "higher order" logic happens here
for example, solariums absorb signals to increase
their charge, then invert their ports and release
once capacity is met. - solariums have charge and
capacity, but don't know exactly what to do with
them. this is where keeper comes in.

furthermore, Signals know nothing about Cells. Cells
know nothing about Signals. keeper:collide() is
the great atom smasher.
]]
keeper = include("arcologies/lib/keeper")

-- build the side menus for norns pages
menu = include("arcologies/lib/menu")

-- midi interface
m = include("arcologies/lib/midi")

-- controller for norns pages
page = include("arcologies/lib/page")

-- exposed norns parameters
parameters = include("arcologies/lib/parameters")

-- popup menu for selecting complex values
popup = include("arcologies/lib/popup")

-- softcut
s = include("arcologies/lib/softcut")

-- all things musical
sound = include("arcologies/lib/sound")

-- dev only stuff
dev = io.open(_path["code"] .. "arcologies/lib/dev.lua", "r")
if dev ~= nil then
  io.close(dev)
  include("arcologies/lib/dev")
end
