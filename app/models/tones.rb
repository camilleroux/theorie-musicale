module Tones

  # Takes manually specified key context for this collection or 
  # delegates to th association owner.
  def key
    @key || (proxy_owner.key if defined?(proxy_owner) and proxy_owner.respond_to?(:key))
  end

  # Manually specifies the key context for this tone sequence only.
  def in_key_of(in_key = nil)
    @key = in_key.is_a?(Key) ? in_key : Key[in_key]
    self
  end

  # Shifts indexes to simulate a key change
  def in_key_context!
    self.each do |tone| 
      tone.tone = (tone.tone + key.index) #% 12
      tone.letter_index = (tone.letter_index + key.letter_index) % 7
    end
    true
  end

  # Takes manually specified mode context for this collection or 
  # delegates to the association owner.
  def mode
    @mode || (proxy_owner.mode if defined?(proxy_owner) and proxy_owner.respond_to?(:mode))
  end

  # Manually specifies the mode context for this tone sequence only.
  def in_mode(mode)
    @mode = mode
    self
  end

  # Shifts mode positions to place tone sequence in mode context
  def in_mode_context!
    self.each {|tone| tone.position = (tone.position - mode) % self.count + 1}
    true
  end

  # TODO: Is this needed anymore? Have to use this until we figure out how to override find/default collection result
  def all
    in_key_context! if key
    in_mode_context! if mode
    self.sort_by(&:position)
  end

  # Does the magic in determining the actual note from the tones 
  # with tone and letter indexes. 
  def keys
    return @keys if defined?(@keys)
    @keys = all.map do |tone|
      Key.from_index(tone.tone, tone.letter_index)
    end
  end

  def notes
    keys.map(&:name)
  end

  def octavized_notes(octave = 4, autooctavize=false)
    return [] if keys.empty?

    #octave -= 1 if (8..11).include?(keys.first.index)
    last_index = keys.first.index

    effective_octave = (keys.first.name == "C♭") ? octave + 1 : octave  # Hack for Cb, which is a weird case...

    ["#{notes.first.gsub("♭", "b").gsub("♯", "#")}/#{effective_octave}"] + keys.from(1).map do |key|
      index = key.index > last_index ? key.index : key.index + 12
      if autooctavize
        octave += 1 if  (last_index..index).include?(12)
      else
        octave = key.octave
      end
      last_index = key.index
      effective_octave = (key.name == "C♭") ? octave + 1 : octave  # Hack for Cb, which is a weird case...
      "#{key.name.gsub("♭", "b").gsub("♯", "#")}/#{effective_octave}"
    end
  end

  def intervals
    previous = 0
    keys.map(&:index).map do |index|
      (index - previous).tap { previous = index }
    end[1..-1].map {|i| i % 12 }
  end

  def step_names
    intervals.map {|step| Key::Steps.invert[step] }
  end

  def interval_names
    intervals.map {|step| Key::Intervals.invert[step] }
  end

  # Generate EasyScore notation string
  # @param duration [String] note duration: 'w' (whole), 'h' (half), 'q' (quarter), '8' (eighth)
  # @param as_chord [Boolean] if true, render as chord "(C4 E4 G4)/w", otherwise as sequence "C4/w, E4, G4"
  # @param octave [Integer] starting octave (default 4)
  # @param autooctavize [Boolean] if true, auto-increment octave for ascending scales
  def to_easyscore(duration: 'w', as_chord: false, octave: 4, autooctavize: false)
    return "" if keys.empty?

    last_index = keys.first.index
    current_octave = (keys.first.name == "C♭") ? octave + 1 : octave

    note_names = []
    keys.each_with_index do |k, i|
      if i == 0
        note_names << k.name.gsub('♯','#').gsub('♭','b') + current_octave.to_s
      else
        index = k.index > last_index ? k.index : k.index + 12
        if autooctavize
          current_octave += 1 if (last_index..index).include?(12)
        else
          current_octave = k.octave
        end
        last_index = k.index
        effective_octave = (k.name == "C♭") ? current_octave + 1 : current_octave
        note_names << k.name.gsub('♯','#').gsub('♭','b') + effective_octave.to_s
      end
    end

    if as_chord
      "(#{note_names.join(' ')})/#{duration}"
    else
      note_names.map.with_index { |n, i| i == 0 ? "#{n}/#{duration}" : n }.join(', ')
    end
  end

end
