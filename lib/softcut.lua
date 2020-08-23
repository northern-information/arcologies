s = {}

-- thanks @dndrks & @its_your_bedtime

function s.init()
  softcut.reset()
  softcut.buffer_clear()
  audio.level_cut(1)
  audio.level_adc_cut(1)
  audio.level_eng_cut(1)
  for i=1, 6 do
    softcut.level(i,1)
    softcut.level_input_cut(1, i, 1.0)
    softcut.level_input_cut(2, i, 1.0)
    softcut.pan(i, 0.5)
    softcut.play(i, 0)
    softcut.rate(i, 1)
    softcut.loop_start(i, 0)
    softcut.loop_end(i, 36)
    softcut.loop(i, 0)
    softcut.rec(i, 0)
    softcut.fade_time(i, 0)
    softcut.level_slew_time(i, 0.01)
    softcut.rate_slew_time(i, 0.01)
    softcut.rec_level(i, 1)
    softcut.pre_level(i, 1)
    softcut.position(i, 0)
    softcut.buffer(i, 1)
    softcut.enable(i, 1)
    softcut.filter_dry(i, 1)
    softcut.filter_fc(i, 0)
    softcut.filter_lp(i, 0)
    softcut.filter_bp(i, 0)
    softcut.filter_rq(i, 0)
  end
  s.clip = {}
  for i = 1, 6 do
    s.clip[i] = {}
    s.clip[i]["sample_length"] = 16
    s.clip[i]["max"] = nil
    s.clip[i]["min"] = s:get_crypt_start(i)
  end
end

function s:get_crypt_start(index)
  return 1 + ((index - 1) * 16)
end

function s:crypt_table()
  for i = 1, 6 do
    s.clip[i].min = s:get_crypt_start(i)
    s.clip[i].max = s.clip[i].min + s.clip[i].sample_length
  end
end

function s:crypt_load(index)
  local file = filesystem:get_crypt() .. index .. ".wav"
  local ch, len = audio.file_info(file)
  if (len / 48000) < 16 then
    s.clip[index].sample_length = len / 48000
  else
    s.clip[index].sample_length = 16
  end
  softcut.buffer_clear_region_channel(2, s:get_crypt_start(index), 16)
  softcut.buffer_read_mono(file, 0, s:get_crypt_start(index), s.clip[index].sample_length + 0.05, 1, 2)
  s:crypt_table()
end

function s:one_shot(index, level)
  local voice = index -- voices are hard-coupled for now
  softcut.buffer(voice, 2)
  softcut.play(voice, 0)
  softcut.level(voice, level)
  softcut.position(voice, s.clip[index].min)
  softcut.loop_start(voice, s.clip[index].min)
  softcut.loop_end(voice, s.clip[index].max)
  softcut.loop(voice, 0)
  softcut.play(voice, 1)
end

return s