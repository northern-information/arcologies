_crow = {}

function _crow.init()
  initASL()
  crow.ii.jf.mode(1)
end

norns.crow.add = function()
  norns.crow.init()
  crow.ii.jf.mode(1)
end

function _crow:jf(note)
  crow.ii.jf.play_note((sound:snap_note(sound:transpose_note(note)) - 60) / 12, 5)
end

function _crow:play(note, pair)
  initASL()
  local output_pairs = {{1,2},{3,4}}
  crow.output[output_pairs[pair][1]].volts = (note - 60) / 12
  -- setting the action before triggering fixes the problem where 
  -- power cycling crow results in default ASL after arcologies has already initialized, better way?

  crow.output[output_pairs[pair][2]]()
  -- power cycle crow sets default ASL loaded on outputs, that's why only note is working
  -- action is triggering on 2, there's just nothing there
  -- reload script, it initializes crow output ASL actions
end

function initASL()
  crow.output[2].action = "pulse(.025, 5)"
  crow.output[4].action = "pulse(.025, 5)"
end

return _crow