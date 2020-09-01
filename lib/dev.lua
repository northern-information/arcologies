local dev = {}

function rerun(option)
  if option == 1 then
    print("option 1")
  end
  norns.script.load(norns.state.script)
end

function dev:scene(i)

  if i == 1 then
    page:select(2)
    menu:select_item(4)
    keeper:select_cell(4, 4)
    keeper.selected_cell:open_port("n")
    keeper.selected_cell:open_port("e")
    keeper.selected_cell:open_port("s")
    keeper.selected_cell:open_port("w")
    -- keeper:deselect_cell()
    params:set("bpm", 120)

  elseif i == 2 then
    sound:set_random_root()
    sound:set_random_scale()
    keeper:select_cell(4, 4)
    -- keeper.selected_cell:change("FOREST")
    -- keeper.selected_cell:open_port("n")
    -- keeper:select_cell(4, 1)
    -- keeper.selected_cell:open_port("s")

    -- keeper.selected_cell:open_port("e")
    -- keeper.selected_cell:open_port("s")
    -- keeper.selected_cell:open_port("w")
    -- keeper.selected_cell:set_state_index(1)
    page:select(2)
    menu:select_item(1)
    -- keeper:deselect_cell()
    params:set("bpm", 120)
    sound:toggle_playback()

  elseif i == 3 then
    -- fn.seed_cells()
    sound:toggle_playback()
    keeper:select_cell(1, 1)
    keeper.selected_cell:open_port("e")
    keeper.selected_cell:open_port("w")
    keeper:deselect_cell()
    keeper:select_cell(4, 1)
    keeper.selected_cell:set_metabolism(1)
    keeper.selected_cell:change("SOLARIUM")
    keeper.selected_cell:open_port("e")
    keeper.selected_cell:open_port("w")
    
    page:select(2)

  elseif i == 4 then
    -- params:set("seed", 4)
    fn.seed_cells()
    page:select(3)
    sound:toggle_playback()

  else
    print('else block')

  end
end


order = 0

-- thank you @dndrks
function screenshot()
  --_norns.screen_export_png("/home/we/"..menu.."-"..os.time()..".png")
  local which_screen = string.match(string.match(string.match(norns.state.script,"/home/we/dust/code/(.*)"),"/(.*)"),"(.+).lua")
  _norns.screen_export_png("/home/we/dust/".. order .. "-" .. which_screen .. "-" .. os.time() .. ".png")
  order = order + 1
end

function wtfscale()
  for i = 1, #sound.scale_notes do
    print(sound.scale_notes[i], mu.note_num_to_name(sound.scale_notes[i]))
  end
end

function kc()
    return keeper.selected_cell
end

function arcdebug()
  print(" ")
  print(" ")
  print(" ")
  print("start arcologies debug -------------------------------")
  print(" ")
  print("generated at: " .. os.date("%Y_%m_%d_%H_%M_%S") .. " / " .. os.time())
  print("version: " .. fn.get_arcology_version())
  print("bpm: " .. params:get("bpm"))
  print("root: " .. sound.root)
  print("scale: " .. sound.scale_name)
  print("generation: " .. counters.music.generation)
  print("cell count: " .. #keeper.cells)
  print("signal count: " .. #keeper.signals)
  print(" ")
  print("cell census:")
  for k,cell in pairs(keeper.cells) do
    local coords = "x" .. cell.x .. "y" .. cell.y
    print(coords, cell.id, cell.structure_value)
  end
  print(" ")
  print("signal census:")
  for k,signal in pairs(keeper.signals) do
    local coords = "x" .. signal.x .. "y" .. signal.y
    print(coords, signal.id, signal.heading)
  end
  print(" ")
  print("end arcologies debug -------------------------------")
  print(" ")
  print(" ")
  print(" ")
end

return dev