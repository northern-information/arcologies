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

-- defines cell structures
include("arcologies/lib/structures")

-- the core concept of arcologies, interact with Signals
include("arcologies/lib/Cell")

--[[
attributes of cells. adding more minimally requires:
 - copy mixins/_template.lua to mixinsfoobar_mixin.lua
 - config in in structures.lua
 - contstructor code in Cell.lua
 - probably some logic in keeper:collision()
 - saveload.lua
]]
include("arcologies/lib/mixins/capacity_mixin")
include("arcologies/lib/mixins/channel_mixin")
include("arcologies/lib/mixins/charge_mixin")
include("arcologies/lib/mixins/crow_out_mixin")
include("arcologies/lib/mixins/crumble_mixin")
include("arcologies/lib/mixins/deflect_mixin")
include("arcologies/lib/mixins/device_mixin")
include("arcologies/lib/mixins/drift_mixin")
include("arcologies/lib/mixins/duration_mixin")
include("arcologies/lib/mixins/er_mixin")
include("arcologies/lib/mixins/level_mixin")
include("arcologies/lib/mixins/metabolism_mixin")
include("arcologies/lib/mixins/network_mixin")
include("arcologies/lib/mixins/notes_mixin")
include("arcologies/lib/mixins/offset_mixin")
include("arcologies/lib/mixins/operator_mixin")
include("arcologies/lib/mixins/ports_mixin")
include("arcologies/lib/mixins/probability_mixin")
include("arcologies/lib/mixins/pulses_mixin")
include("arcologies/lib/mixins/range_mixin")
include("arcologies/lib/mixins/resilience_mixin")
include("arcologies/lib/mixins/state_index_mixin")
include("arcologies/lib/mixins/territory_mixin")
include("arcologies/lib/mixins/turing_mixin")
include("arcologies/lib/mixins/velocity_mixin")

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
