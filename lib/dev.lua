dev = {}

function rerun(option)
  if option == 1 then
    print("option 1")
  end
  norns.script.load(norns.state.script)
end

function dev:scene(i)

  if i == 1 then
    
    keeper:select_cell(9, 1)
    kc():change("TOPIARY")
    kc():open_port("w")
    keeper:select_cell(1, 1)
    kc():change("DOME")
    kc():open_port("e")
    kc():set_metabolism(8)
    -- kc():set_offset(1)
    kc():set_pulses(4)
    -- kc():set_probability(0)
    
    -- menu:select_item(2)
    page:select(2)

    sound:toggle_playback()
    params:set("bpm", 120)


  elseif i == 2 then
    -- sound:set_random_root()
    -- sound:set_random_scale()

    
    keeper:select_cell(8, 4)
    kc():open_port("w")

    keeper:select_cell(4, 4)
    kc():change("INSTITUTION")    
    kc():set_deflect(2)
    -- kc():open_port("e")
    -- kc():open_port("s")
    -- kc():open_port("w")
    -- kc():set_state_index(1)
    page:select(2)
    -- menu:select_item(5)
    -- keeper:deselect_cell()
    params:set("bpm", 120)
    sound:toggle_playback()

  elseif i == 3 then
    fn.seed_cells()
    sound:toggle_playback()
    keeper:select_cell(1, 1)
    kc():open_port("e")
    kc():open_port("w")
    keeper:deselect_cell()
    keeper:select_cell(4, 1)
    kc():set_metabolism(1)
    kc():change("SOLARIUM")
    kc():open_port("e")
    kc():open_port("w")
    page:select(3)

  elseif i == 4 then
    -- params:set("seed_cell_count", 4)
    fn.seed_cells()
    page:select(3)
    -- sound:toggle_playback()

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
  print("name: " .. arcology_name)
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