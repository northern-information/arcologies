-- k1: exit  e1: navigate
--
--
--      e2: select    e3: change
--
--    k2: play      k3: delete
--
--
-- ........................................
-- l.llllllll.co/arcologies
-- <3 @tyleretters
-- v0.0.1

core = {}

include("arcologies/lib/Cell")
include("arcologies/lib/Field")
include("arcologies/lib/functions")
g = include("arcologies/lib/g")
parameters = include("arcologies/lib/parameters")
graphics = include("arcologies/lib/graphics")
page = include("arcologies/lib/page")
dictionary = include("arcologies/lib/dictionary")
counters = include("arcologies/lib/counters")
tu = require("tabutil")

function init()
  audio:pitch_off()
  core.g = g  
  core.Field = Field:new()
  core.parameters = parameters
  core.parameters.init()
  core.graphics = graphics
  core.graphics.init()
  core.dictionary = dictionary
  core.dictionary.init()
  core.counters = counters
  core.counters.init()
  core.page = page
  core.page.init()
  core.page.parameters = parameters
  core.page.graphics = core.graphics
  core.pages = core.dictionary.pages
  core.page.dictionary = core.dictionary
  core.selected_cell = {}
  core.selected_cell_on = false
  select_page(1)
  redraw()
end

function redraw()
  core.graphics:setup()
  core.graphics:top_menu()
  core.graphics:top_menu_static()
  core.graphics:top_menu_tabs()
  core.graphics:select_tab(core.page.active_page)
  core.graphics:top_message(core.pages[core.page.active_page])
  core.page:render(core)
  core.graphics:teardown()
end

function key(k, z)
  if k == 2 and z == 1 then
    core.parameters.toggle_status()
  end
  if k == 3 and z == 1 then
    print('k3')
  end
end

function enc(n, d)
  if n == 1 then
    select_page(util.clamp(core.page.active_page + d, 1, #core.pages))
    if core.page.active_page ~= 2 then
      deselect_cell()
    end
  elseif n == 2 then
    core.page.selected_item = util.clamp(core.page.selected_item + d, 1, core.page.items)
  else
    core.page:change_selected_item_value(d)
  end
  redraw()
end

function cleanup()
    -- core.g.cleanup()
  poll:clear_all() 
end
