local dev = {}

function rerun(option)
  if option == 1 then 
    print("option 1")
  end
  norns.script.load(norns.state.script)
end

function dev:scene(i)
  
  sound:toggle_playback()

  keeper:select_cell(6, 4)
  keeper.selected_cell:open_port("n")
  keeper.selected_cell:open_port("e")
  keeper.selected_cell:open_port("s")
  keeper.selected_cell:open_port("w")
  keeper.selected_cell:set_metabolism(16)
  -- keeper.selected_cell:set_structure(1)
  
  keeper:select_cell(12, 6)
  keeper.selected_cell:open_port("n")
  keeper.selected_cell:open_port("e")
  keeper.selected_cell:open_port("s")
  keeper.selected_cell:open_port("w")
  keeper.selected_cell:set_offset(1)
  keeper.selected_cell:set_metabolism(16)

  -- keeper:select_cell(10, 4)
  -- keeper.selected_cell:set_structure(3)
  -- keeper.selected_cell:open_port("w")

  -- keeper.selected_cell:open_port("n")
  -- keeper:select_cell(10, 4)
  -- keeper.selected_cell:open_port("e")
  -- keeper.selected_cell:open_port("w")
  -- keeper:select_cell(13, 4)
  -- keeper.selected_cell:open_port("w")
  page:select(2)
  -- menu:select_item(3)
  -- sound:toggle_playback()
  params:set("bpm", 240)
  -- keeper:select_cell(6, 4)

  keeper:deselect_cell()
  -- menu.selected_item = 3
end

return dev