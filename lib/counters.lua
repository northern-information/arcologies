local counters = {}

function counters.init()
  counters.message = 0

  counters.ui = metro.init()
  counters.ui.time = 1 / 30
  counters.ui.count = -1
  counters.ui.play = 1
  counters.ui.microframe = 1
  counters.ui.frame = 1
  counters.ui.event = counters.optician
  counters.ui:start()

  counters.music = metro.init()
  counters.music.time = 60 / params:get("bpm")
  counters.music.count = -1
  counters.music.play = 1
  counters.music.generation = 1
  counters.music.event = counters.conductor
  counters.music:start()

  counters.grid = metro.init()
  counters.grid.time = 1 / 30
  counters.grid.count = -1
  counters.grid.play = 1
  counters.grid.frame = 1
  counters.grid.event = counters.gridmeister
  counters.grid:start()
end

function counters.redraw_clock()
  while true do
    if dirty_screen() then
      redraw()
      dirty_screen(false)
    end
    clock.sleep(1 / 30)
  end
end

function counters.optician()
  counters.ui.microframe = counters.ui.microframe + 1
  if counters.ui.microframe % 4 == 0 then
    counters.ui.frame = counters.ui.frame + 1
  end
  dirty_screen(true)
  redraw()
end

function counters.conductor()
  counters.music.time = parameters.bpm_to_seconds
  counters.music.generation = counters.music.generation + 1
  keeper:spawn_signals()
  keeper:propagate_signals()
  keeper:collide_signals()
  keeper:collide_signals_and_cells()
  redraw()
end

function counters.gridmeister()
  counters.grid.frame = counters.grid.frame + 1 
end

return counters