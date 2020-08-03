core = {}

-- includes
--------------------------------------------------------------------------------
g = include("arcologies/lib/g")
parameters = include("arcologies/lib/parameters")
graphics = include("arcologies/lib/graphics")
page = include("arcologies/lib/page")
dictionary = include("arcologies/lib/dictionary")

-- classes
--------------------------------------------------------------------------------
include("arcologies/lib/Cell")
include("arcologies/lib/Field")

-- core
--------------------------------------------------------------------------------
function core.init()
  audio:pitch_off()
  parameters.init()
  core.Field = Field:new()
  core.selected_cell = {}
  core.selected_cell_on = false

  -- ui & graphics counter
  core.ui_counter = metro.init()
  core.ui_counter.time = .25
  core.ui_counter.count = -1
  core.ui_counter.play = 1
  core.ui_counter.microframe = 0
  core.ui_counter.frame = 0
  core.ui_counter.event = core.tick
  core.ui_counter:start()

  -- musical counter
  core.music_counter = metro.init()
  core.music_counter.time = 60 / params:get("bpm")
  core.music_counter.count = -1
  core.music_counter.play = 1
  core.music_counter.location = 0
  core.music_counter.event = core.conductor
  core.music_counter:start()

  -- grid counter
  core.grid_counter = metro.init()
  core.grid_counter.time = 0.02
  core.grid_count = -1
  core.grid_counter.play = 1
  core.grid_counter.frame = 0
  core.grid_counter.event = core.gridmeister
  core.grid_counter:start()

  -- grid
  core.g = g

  -- ultilities
  core.graphics = graphics
  core.graphics.init()
  core.dictionary = dictionary
  core.dictionary.init()

  -- page rendering
  core.page = page
  core.page.init()
  core.page.parameters = parameters
  core.page.graphics = core.graphics
  core.pages = core.dictionary.pages
  core.page.dictionary = core.dictionary
  select_page(1)

  core.redraw()
end

function core.key(k,z)
  if k == 2 and z == 1 then
    parameters.toggle_status()
  end
  if k == 3 and z == 1 then
    print('k3')
  end
end

function core.enc(n,d)
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
  core.redraw()
end

function core.redraw()
  core.graphics.setup()
  core.graphics:top_menu()
  core.graphics:top_menu_static() -- todo throttle
  core.graphics:top_menu_tabs()
  core.graphics:select_tab(core.page.active_page)
  core.graphics:top_message(core.pages[core.page.active_page])
  core.page:render(
    core.page.active_page,
    core.page.selected_item,
    core.ui_counter.microframe,
    core.music_counter.location,
    core.selected_cell
  )
  core.graphics.teardown()
end

function core.grid_redraw()
  core.g:all(0)
  led_blink_selected_cell()
  core.g:refresh()
end

function core.conductor()
  core.music_counter.time = parameters.bpm_to_seconds
  core.music_counter.location = core.music_counter.location + 1 
  core.redraw()
end

function core.tick()
  core.ui_counter.microframe = core.ui_counter.microframe + 1
  if core.ui_counter.microframe % 4 == 0 then
    core.ui_counter.frame = core.ui_counter.frame + 1
  end
  core.redraw()
end

function core.gridmeister()
  core.grid_counter.frame = core.grid_counter.frame + 1
  core.grid_redraw()
end

function core.cleanup()
  -- core.g.cleanup()
  poll:clear_all() 
end

-- global functions
--------------------------------------------------------------------------------
function select_page(x)
  core.page.active_page = x
  core.page.items = page_items[page.active_page]
  core.page.selected_item = 1
end

function create_cell(x, y)
  c = Cell:new(x, y, core.music_counter.location)
  core.Field:add_cell(c)
end

function select_cell(x, y)
  core.selected_cell = {x, y}
  local cell_exists = core.Field:lookup(x, y)
  if not cell_exists then
    create_cell(x, y)
  end
  core.g:refresh()
end

function cell_is_selected()
  return (#core.selected_cell == 2) and true or false
end

function led_blink_selected_cell()
  if not cell_is_selected() then return end

  if core.grid_counter.frame % 15 == 0 then
    core.selected_cell_on = not core.selected_cell_on
  end

  local level = (core.selected_cell_on == false) and core.graphics.levels["h"] or core.graphics.levels["l"]
  core.g:led(core.selected_cell[1], core.selected_cell[2], level)
end

function deselect_cell()
  core.selected_cell = {}
  core.selected_cell_on = false
  core.g:refresh()
end

-- return core
--------------------------------------------------------------------------------
return core
