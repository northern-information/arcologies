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
grid_dirty = true
screen_dirty = true
cell_selected = false
selected_cell_id = {}

include("arcologies/lib/Cell")

include("arcologies/lib/functions")
g = include("arcologies/lib/g")
tu = require("tabutil")
field = include("arcologies/lib/field")
parameters = include("arcologies/lib/parameters")
graphics = include("arcologies/lib/graphics")
page = include("arcologies/lib/page")
dictionary = include("arcologies/lib/dictionary")
counters = include("arcologies/lib/counters")



function init()
  audio:pitch_off()
  core.g = g
  core.g.init()
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
  core.field = field
  core.field.init()
  select_page(1)
  redraw()
end

function redraw()
  if not dirty_screen() then return end
  core.graphics:setup()
  core.graphics:ui()
  core.graphics:select_tab(core.page.active_page)
  core.graphics:top_message(core.dictionary.pages[core.page.active_page])
  core.page:render()
  core.graphics:teardown()
  dirty_screen(false)
end

function key(k, z)
  if k == 2 and z == 1 then
    core.parameters.toggle_status()
  end
  if k == 3 and z == 1 then
    if cell_selected then
      delete_cell(selected_cell_id[1], selected_cell_id[2])
    end
  end
end

function enc(n, d)
  if n == 1 then
    select_page(util.clamp(core.page.active_page + d, 1, #core.dictionary.pages))
    if core.page.active_page ~= 2 then
      deselect_cell()
    end
  elseif n == 2 then
    core.page.selected_item = util.clamp(core.page.selected_item + d, 1, core.page.items)
  else
    core.page:change_selected_item_value(d)
  end
end

function cleanup()
  core.g.all(0)
  poll:clear_all()
end
