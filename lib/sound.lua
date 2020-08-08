local sound = {}

function sound.init()

end

function sound:play(note, velocity)
  print('note: ' .. note .. ' velocity: ' .. velocity)
end

return sound