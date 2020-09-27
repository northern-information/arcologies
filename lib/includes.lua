-- ships with norns
crow = require("crow")
er = require("er")
fileselect = require("fileselect")
musicutil = require("musicutil")
textentry = require("textentry")
tabutil = require("tabutil")
engine.name = "PolyPerc"


local lib = "arcologies/lib/"

-- stores application configuration and cell composition data
config = include(lib .. "config")
config_ = io.open(_path["code"] .. lib .. "config_.lua", "r")
if config_ ~= nil then
  io.close(config_)
  include(lib .. "config_")
end

-- defines cell structures
include(lib .. "structures")

-- the core concept of arcologies, interact with Signals
include(lib .. "Cell")

--[[
attributes of cells. adding more minimally requires:
 - copy mixins/_template.lua to mixinsfoobar_mixin.lua
 - config in in structures.lua
 - contstructor code in Cell.lua
 - probably some logic in keeper:collision()
 - saveload.lua
]]
local mixins = {
  "bearing_mixin",
  "capacity_mixin",
  "channel_mixin",
  "charge_mixin",
  "clockwise_mixin",
  "crow_out_mixin",
  "crumble_mixin",
  "deflect_mixin",
  "device_mixin",
  "docs_stub_mixin",
  "drift_mixin",
  "duration_mixin",
  "er_mixin",
  "level_mixin",
  "metabolism_mixin",
  "network_mixin",
  "notes_mixin",
  "offset_mixin",
  "operator_mixin",
  "output_mixin",
  "ports_mixin",
  "probability_mixin",
  "pulses_mixin",
  "range_mixin",
  "resilience_mixin",
  "state_index_mixin",
  "structure_stub_mixin",
  "territory_mixin",
  "topography_mixin",
  "turing_mixin",
  "velocity_mixin"
}
for k, v in pairs(mixins) do
  include(lib .. "mixins/" .. v)
end

-- emitted by Cells, "bangs" that move n, e, s, w
include(lib .. "Signal")

-- global functions
fn = include(lib .. "functions")

-- all the save and load routines
saveload = include(lib .. "saveload")

-- the whole murder of them
_crow = include(lib .. "_crow")

-- clocks, metros, timing
counters = include(lib .. "counters")

-- in app documentation
docs = include(lib .. "docs")

-- read & write on norns
filesystem = include(lib .. "filesystem")

-- grid interactions and leds
_grid = include(lib .. "_grid")

-- structure glyph drawings
glyphs = include(lib .. "glyphs")

-- all norns screen rendering
graphics = include(lib .. "graphics")

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
keeper = include(lib .. "keeper")

-- build the side menus for norns pages
menu = include(lib .. "menu")

-- midi interface
_midi = include(lib .. "_midi")

-- controller for norns pages
page = include(lib .. "page")

-- exposed norns parameters
parameters = include(lib .. "parameters")

-- popup menu for selecting complex values
popup = include(lib .. "popup")

-- softcut
_softcut = include(lib .. "_softcut")

-- all things musical
sound = include(lib .. "sound")

-- dev only stuff
dev = io.open(_path["code"] .. lib .. "dev.lua", "r")
if dev ~= nil then
  io.close(dev)
  include(lib .. "dev")
end
