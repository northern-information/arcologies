local core = {}

local g = include("arcologies/lib/g")
local parameters = include("arcologies/lib/parameters")
local graphics = include("arcologies/lib/graphics")
local ui = include("arcologies/lib/ui")
local page = include("arcologies/lib/page")
local dictionary = include("arcologies/lib/dictionary")


function core.init()
  audio:pitch_off()
  params:bang();
  
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
  core.music_counter.time = 60 / params:get("BPM")
  core.music_counter.count = -1
  core.music_counter.play = 1
  core.music_counter.location = 0
  core.music_counter.event = core.conductor
  core.music_counter:start()

  core.g = g

  core.graphics = graphics
  core.graphics.init()

  core.ui = ui
  core.ui.init()
  core.ui.graphics = core.graphics

  core.dictionary = dictionary
  core.dictionary.init()


  core.page = page
  core.page.parameters = parameters
  core.page.init()
  core.page.ui = core.ui
  core.pages = core.dictionary.pages

  core.redraw()
end

function core.conductor()
  core.music_counter.time = parameters.bpm_to_seconds
  core.music_counter.location = core.music_counter.location + 1 
  redraw()
end

function core.tick()
  core.ui_counter.microframe = core.ui_counter.microframe + 1
  if core.ui_counter.microframe % 4 == 0 then
    core.ui_counter.frame = core.ui_counter.frame + 1
  end
  redraw()
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
    core.page.active_page = util.clamp(core.page.active_page + d, 1, #core.pages)
    core.page.items = page_items[page.active_page]
  elseif n == 2 then
    core.page.selected_item = util.clamp(core.page.selected_item + d, 1, core.page.items)
  else
    core.page:change_selected_item_value(d)
  end
  core.redraw()
end

function core.redraw()
  core.graphics.setup()

  core.ui:top_menu()
  core.ui:select_tab(core.page.active_page)
  core.ui:top_message(core.pages[core.page.active_page])

  core.page:render(core.page.active_page, core.page.selected_item, core.ui_counter.microframe, core.music_counter.location)

  core.graphics.teardown()

  -- core.g:led(1, 8, 15)
  core.g:refresh()
end

function core.cleanup()
  
end

return core