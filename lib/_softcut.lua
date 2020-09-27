_softcut = {}

-- thanks @dndrks & @its_your_bedtime

function _softcut.init()
  softcut.reset()
  softcut.buffer_clear()
  audio.level_cut(1)
  audio.level_adc_cut(1)
  audio.level_eng_cut(1)
  for i = 1, 6 do
    softcut.level(i, 1)
    softcut.level_input_cut(1, i, 1.0)
    softcut.level_input_cut(2, i, 1.0)
    softcut.pan(i, 0)
    softcut.play(i, 0)
    softcut.rate(i, 1)
    softcut.loop_start(i, 0)
    softcut.loop_end(i, 36)
    softcut.loop(i, 0)
    softcut.rec(i, 0)
    softcut.fade_time(i, 0.02)
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
  _softcut.clip = {}
  for i = 1, 6 do
    _softcut.clip[i] = {}
    _softcut.clip[i]["sample_length"] = 16
    _softcut.clip[i]["max"] = nil
    _softcut.clip[i]["min"] = _softcut:get_crypt_start(i)
  end
end

function _softcut:get_crypt_start(index)
  return 1 + ((index - 1) * 16)
end

function _softcut:crypt_table()
  for i = 1, 6 do
    self.clip[i].min = self:get_crypt_start(i)
    self.clip[i].max = self.clip[i].min + self.clip[i].sample_length
  end
end

function _softcut:crypt_load(index)
  local file = filesystem:get_crypt() .. index .. ".wav"
  local ch, len = audio.file_info(file)
  if (len / 48000) < 16 then
    self.clip[index].sample_length = len / 48000
  else
    self.clip[index].sample_length = 16
  end
  softcut.buffer_clear_region_channel(2, self:get_crypt_start(index), 16)
  softcut.buffer_read_mono(file, 0, self:get_crypt_start(index), self.clip[index].sample_length + 0.05, 1, 2)
  self:crypt_table()
end

function _softcut:one_shot(index, level)
  local voice = index -- voices are hard-coupled for now
  if tonumber(index) then -- some edge cases were happening where nil indexes were coming in
    softcut.buffer(voice, 2)
    softcut.play(voice, 0)
    softcut.level(voice, level)
    softcut.position(voice, self.clip[index].min)
    softcut.loop_start(voice, self.clip[index].min)
    softcut.loop_end(voice, self.clip[index].max)
    softcut.loop(voice, 0)
    softcut.play(voice, 1)
  end
end

return _softcut