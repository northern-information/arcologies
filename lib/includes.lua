-- ships with norns
mu = require("musicutil")
tu = require("tabutil")
er = require("er")
engine.name = "PolyPerc"

-- stores application configuration and cell composition data
include("arcologies/lib/config")

-- the core concept of arcologies, interact with Signals
include("arcologies/lib/Cell")

-- the non-universal traits of cells
include("arcologies/lib/traits/er_trait")
include("arcologies/lib/traits/metabolism_trait")
include("arcologies/lib/traits/notes_trait")
include("arcologies/lib/traits/offset_trait")
include("arcologies/lib/traits/pulses_trait")
include("arcologies/lib/traits/velocity_trait")

-- emitted by Cells, "bangs" that move n, e, s, w
include("arcologies/lib/Signal")

-- global functions
fn = include("arcologies/lib/functions")

-- clocks, metros, timing
counters = include("arcologies/lib/counters")

-- grid interactions and leds
g = include("arcologies/lib/g")

-- structure glyph drawings
glyphs = include("arcologies/lib/glyphs")

-- all norns screen rendering
graphics = include("arcologies/lib/graphics")

-- state machine for Cells and Signals
keeper = include("arcologies/lib/keeper")

-- build the side menus for norns pages
menu = include("arcologies/lib/menu")

-- controller for norns pages
page = include("arcologies/lib/page")

-- exposed norns parameters
parameters = include("arcologies/lib/parameters")

-- popup menu for selecting complex values
popup = include("arcologies/lib/popup")

-- all sound, midi, samples
sound = include("arcologies/lib/sound")

-- dev only stuff
dev = include("arcologies/lib/dev") 