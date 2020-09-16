counters = {}


function counters.init()
  counters.playback = config.settings.playback
  counters.message = 0
  counters.default_message_length = 40
  counters.music_generation = 0

  counters.ui = metro.init()
  counters.ui.time = 1 / 30
  counters.ui.count = -1
  counters.ui.play = 1
  counters.ui.frame = 1
  counters.ui.quarter_frame = 1
  counters.ui.event = counters.optician

  counters.grid = metro.init()
  counters.grid.time = 1 / 30
  counters.grid.count = -1
  counters.grid.play = 1
  counters.grid.frame = 1
  counters.grid.event = counters.gridmeister
end

function counters.conductor()
  while true do
    clock.sync(1)
    if counters.playback == 1 then
      counters.music_generation = counters.music_generation + 1
      m:setup()
      keeper:setup()
      keeper:spawn_signals()
      keeper:propagate_signals()
      keeper:deflect_signals()
      keeper:collide_signals()
      keeper:collide_signals_and_cells()
      keeper:delete_signals()
      keeper:teardown()
      redraw()
    end
  end
end

function counters:set_playback(i)
  self.playback = util.clamp(i, 0, 1)
end

function clock.transport.start()
  counters:start()
end

function counters:start()
  self:set_playback(1)
  graphics:set_message("PLAYING", self.default_message_length)
end

function clock.transport.stop()
  counters:stop()
end

function counters:stop()
  self:set_playback(0)
  graphics:set_message("PAUSED", self.default_message_length)
end

function counters:toggle_playback()
    if self.playback == 0 then
      self:start()
    else
      self:stop()
    end
end

function counters.redraw_clock()
  while true do
    if fn.dirty_screen() then
      redraw()
      fn.dirty_screen(false)
    end
    if fn.dirty_grid() then
      g:grid_redraw()
    end
    clock.sleep(1 / 30)
  end
end

function counters:this_beat()
  if self.music_generation == 0 then
    return 0
  elseif self.music_generation % sound.length == 0 then
    return sound.length
  else
    return (self.music_generation % sound.length)
  end
end

function counters.optician()
  if counters.ui ~= nil then
    counters.ui.frame = counters.ui.frame + 1
    if counters.ui.frame % 4 == 0 then
      counters.ui.quarter_frame = counters.ui.quarter_frame +1
    end
    if not g.disconnect_dismissed then page:set_error(1) else page:clear_error() end
    fn.dirty_screen(true)
    redraw()
  end
end

function counters.gridmeister()
  if counters.grid ~= nil then
    counters.grid.frame = counters.grid.frame + 1
  end
end

function counters.grid_frame()
  return counters.grid.frame
end

function counters:reset_enc(e)
  enc_counter[e] = {
    this_clock = nil,
    waiting = false
  }
end

return counters