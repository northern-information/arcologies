local counters = {}

function counters.init()
  counters.ui = metro.init()
  counters.ui.time = .25
  counters.ui.count = -1
  counters.ui.play = 1
  counters.ui.microframe = 1
  counters.ui.frame = 1
  counters.ui.event = counters.tick
  counters.ui:start()

  counters.music = metro.init()
  counters.music.time = 60 / params:get("bpm")
  counters.music.count = -1
  counters.music.play = 1
  counters.music.location = 1
  counters.music.event = counters.conductor
  counters.music:start()

  -- counters.grid = metro.init()
  -- counters.grid.time = 0.02
  -- counters.grid -1
  -- counters.grid.play = 1
  -- counters.grid.frame = 0
  -- counters.grid.event = counters.gridmeister
  -- counters.grid:start()
end

-- function counters.grid_redraw()
--   counters.g:all(0)
--   led_blink_selected_cell()
--   counters.g:refresh()
-- end

function counters.conductor()
  counters.music.time = parameters.bpm_to_seconds
  counters.music.location = counters.music.location + 1 
  redraw()
end

function counters.tick()
  counters.ui.microframe = counters.ui.microframe + 1
  if counters.ui.microframe % 4 == 0 then
    counters.ui.frame = counters.ui.frame + 1
  end
  redraw()
end

-- function counters.gridmeister()
--   counters.grid.frame = counters.grid.frame + 1
--   counters.grid_redraw()
-- end

return counters