ChordQuality.create!(:name => 'Majeur', :code => 'MAJ').tap do |q|
  q.chords.create!(:name => 'Majeure', :specify_tones => "1 3 5").tap do |c|
    c.symbols.create!(:name => 'M', :case_sensitive => true, :primary => true)
    c.symbols.create!(:name => 'MAJ')
    c.symbols.create!(:name => 'Majeur')

    c.chord_scales << ChordScale.new(:mode => Scale['Majeure'].modes.find_by(mode:1), :offset => 0)
  end

  q.chords.create!(:name => 'Majeur 7', :specify_tones => "1 3 5 7").tap do |c|
    c.symbols.create!(:name => 'Δ', :primary => true)
    c.symbols.create!(:name => 'Δ7')
    c.symbols.create!(:name => 'maj7')
    c.symbols.create!(:name => 'majeur7')
    c.symbols.create!(:name => 'Maj 7')
    c.symbols.create!(:name => '7 Maj')
    c.symbols.create!(:name => 'M7', :case_sensitive => true)

    # c.children.create!(:chord_quality => q, :name => 'Majeur 7 ♯11', :specify_tones => "u 3 ♯4 5 7").tap do |cc|
    #   cc.symbols.create!(:name => 'maj7♯11', :primary => true)
    #   cc.symbols.create!(:name => 'M7♯11')
    #   cc.symbols.create!(:name => 'majeur7♯11')
    #   cc.symbols.create!(:name => 'lyd')
    #   cc.symbols.create!(:name => 'lydien')
    #
    #   cc.chord_scales << ChordScale.new(:mode => Scale['Majeure'].modes.find_by(mode:4), :offset => -5)
    # end
    #
    # c.children.create!(:chord_quality => q, :name => 'Majeur 7 ♯4♯5', :specify_tones => "u 3 ♯4 ♯5 7").tap do |cc|
    #   cc.symbols.create!(:name => 'maj7♯4♯5', :primary => true)
    #   cc.symbols.create!(:name => 'lydaug')
    #   cc.symbols.create!(:name => 'maj7♯11♯5')
    #
    #   cc.chord_scales << ChordScale.new(:mode => Scale['Mineure mélodique'].modes.find_by(mode:3), :offset => -3)
    # end

    c.chord_scales << ChordScale.new(:mode => Scale['Majeure'].modes.find_by(mode:1), :offset => 0)
    c.chord_scales << ChordScale.new(:mode => Scale['Majeure'].modes.find_by(mode:4), :offset => -5)
  end

  q.chords.create!(:name => 'Majeur 6', :specify_tones => "1 3 5 6").tap do |c|
    c.symbols.create!(:name => 'M6', :case_sensitive => true, :primary => true)
    c.symbols.create!(:name => '6')
    c.symbols.create!(:name => 'maj6')

    c.chord_scales << ChordScale.new(:mode => Scale['Pentatonique'].modes.find_by(mode:1), :offset => 0)
    c.chord_scales << ChordScale.new(:mode => Scale['Majeure'].modes.find_by(mode:1), :strength => 2, :offset => 0)
  end
end


ChordQuality.create!(:name => 'Mineur', :code => 'MIN').tap do |q|
  q.chords.create!(:name => 'Mineure', :specify_tones => "1 3m 5").tap do |c|
    c.symbols.create!(:name => 'min')
    c.symbols.create!(:name => 'm', :case_sensitive => true, :primary => true)
    c.symbols.create!(:name => '-')

    c.chord_scales << ChordScale.new(:mode => Scale['Majeure'].modes.find_by(mode:2), :offset => -2)
    c.chord_scales << ChordScale.new(:mode => Scale['Majeure'].modes.find_by(mode:6), :strength => 2, :offset => 3)
    c.chord_scales << ChordScale.new(:mode => Scale['Majeure'].modes.find_by(mode:3), :strength => 3, :offset => -4)
  end

  q.chords.create!(:name => 'Mineur septième', :specify_tones => "1 3m 5 7m").tap do |c|
    c.symbols.create!(:name => 'm7', :case_sensitive => true, :primary => true)
    c.symbols.create!(:name => 'min7')
    c.symbols.create!(:name => '-7')

    c.chord_scales << ChordScale.new(:mode => Scale['Majeure'].modes.find_by(mode:2), :offset => -2)
    c.chord_scales << ChordScale.new(:mode => Scale['Majeure'].modes.find_by(mode:6), :strength => 2, :offset => 3)
    c.chord_scales << ChordScale.new(:mode => Scale['Majeure'].modes.find_by(mode:3), :offset => -4)
  end

  q.chords.create!(:name => 'Mineur 6', :specify_tones => "1 3m 5 6").tap do |c|
    c.symbols.create!(:name => 'min6')
    c.symbols.create!(:name => 'm6', :case_sensitive => true, :primary => true)
    c.symbols.create!(:name => '-6')

    c.chord_scales << ChordScale.new(:mode => Scale['Majeure'].modes.find_by(mode:2), :offset => -2)
    c.chord_scales << ChordScale.new(:mode => Scale['Majeure'].modes.find_by(mode:6), :strength => 2, :offset => 3)
  end

  q.chords.create!(:name => 'Phrygien', :specify_tones => "1 2m 3m 5 6m").tap do |c|
    c.symbols.create!(:name => 'phryg', :primary => true)
    c.symbols.create!(:name => 'minb2')
    c.symbols.create!(:name => 'mb2')
    c.symbols.create!(:name => 'minorb2')
    c.symbols.create!(:name => 'phrygien')
    c.symbols.create!(:name => 'susb9')
    c.chord_scales << ChordScale.new(:mode => Scale['Majeure'].modes.find_by(mode:3), :offset => -4)
  end

  q.chords.create!(:name => 'Mineur ♭6', :specify_tones => "1 3m 5 6m").tap do |c|
    c.symbols.create!(:name => 'minb6', :primary => true)
    c.symbols.create!(:name => 'mb6', :case_sensitive => true)
    c.symbols.create!(:name => '-b6')
    c.symbols.create!(:name => 'minorb6')
    c.symbols.create!(:name => 'aeolien')

    c.chord_scales << ChordScale.new(:mode => Scale['Majeure'].modes.find_by(mode:6), :offset => 3)
  end

  q.chords.create!(:name => 'Mineur septième majeure', :specify_tones => "1 3m 5 7").tap do |c|
    c.symbols.create!(:name => 'mΔ', :primary => true)
    c.symbols.create!(:name => '-Δ')
    c.symbols.create!(:name => '-M7', :case_sensitive => true)
    c.symbols.create!(:name => 'min7Δ')
    c.symbols.create!(:name => '-Maj7')

    c.chord_scales << ChordScale.new(:mode => Scale['Mineure mélodique'].modes.find_by(mode:1), :offset => 0)
  end
end


ChordQuality.create!(:name => 'Septième de dominante', :code => 'DOM').tap do |q|
  q.chords.create!(:name => 'Septième de dominante', :specify_tones => "1 3 5 7m").tap do |c|
    c.symbols.create!(:name => '7', :primary => true)
    c.symbols.create!(:name => 'dom')
    c.symbols.create!(:name => 'dom.7')

    c.chord_scales << ChordScale.new(:mode => Scale['Majeure'].modes.find_by(mode:5), :offset => 5)

    c.children.create!(:chord_quality => q, :name => '7 ♯5', :specify_tones => "1 3 5aug 7m").tap do |cc|
      cc.symbols.create!(:name => '+7', :primary => true)
      cc.symbols.create!(:name => '7 aug.')

      #TODO:
      #cc.chord_scales << ChordScale.new(:mode => Scale['Major'].modes.find_by(mode:5), :offset => 5)
    end

    c.children.create!(:chord_quality => q, :name => '7 ♭5', :specify_tones => "1 3 5dim 7m").tap do |cc|
      cc.symbols.create!(:name => '7 (♭5)', :primary => true)

      cc.chord_scales << ChordScale.new(:mode => Scale['Mineure mélodique'].modes.find_by(mode:4), :offset => -5)
    end

    c.children.create!(:chord_quality => q, :name => '7 sus 4', :specify_tones => "1 4 5 7m").tap do |cc|
      cc.symbols.create!(:name => '7 sus', :primary => true)
      cc.symbols.create!(:name => 'suspendu')
      cc.symbols.create!(:name => 'sus 4')

      #TODO:
      #cc.chord_scales << ChordScale.new(:mode => Scale['Major'].modes.find_by(mode:5), :offset => 5)
    end

    # c.children.create!(:chord_quality => q, :name => 'Dominant 9', :specify_tones => "u 3 5 ♭7 2").tap do |cc|
    #   cc.symbols.create!(:name => '9', :primary => true)
    #   cc.symbols.create!(:name => 'dom9')
    #
    #   cc.chord_scales << ChordScale.new(:mode => Scale['Major'].modes.find_by(mode:5), :offset => 5)
    # end
    #
    # c.children.create!(:chord_quality => q, :name => 'Dominant 6/9', :specify_tones => "u 3 5 6 ♭7 2").tap do |cc|
    #   cc.symbols.create!(:name => '6/9', :primary => true)
    #   cc.symbols.create!(:name => '69')
    #
    #   cc.chord_scales << ChordScale.new(:mode => Scale['Major'].modes.find_by(mode:5), :offset => 5)
    #   cc.chord_scales << ChordScale.new(:mode => Scale['Major'].modes.find_by(mode:1), :offset => 0)
    # end
    #
    # c.children.create!(:chord_quality => q, :name => 'Dominant b9', :specify_tones => "u 3 5 ♭7 ♭2").tap do |cc|
    #   cc.symbols.create!(:name => '7b9', :primary => true)
    #
    #   cc.chord_scales << ChordScale.new(:mode => Scale['Diminished'].modes.find_by(mode:1), :offset => 0)
    #   cc.chord_scales << ChordScale.new(:mode => Scale['Major'].modes.find_by(mode:5), :strength => 2, :offset => 5)
    # end
    #
    # c.children.create!(:chord_quality => q, :name => 'Dominant ♯9', :specify_tones => "u 3 5 ♭7 ♯2").tap do |cc|
    #   cc.symbols.create!(:name => '7♯9', :primary => true)
    #
    #   cc.chord_scales << ChordScale.new(:mode => Scale['Melodic Minor'].modes.find_by(mode:7), :offset => 1)
    #   cc.chord_scales << ChordScale.new(:mode => Scale['Diminished'].modes.find_by(mode:1), :strength => 2, :offset => 0)
    # end
    #
    # c.children.create!(:chord_quality => q, :name => 'Dominant ♯11', :specify_tones => "u 3 5 ♭7 ♯4").tap do |cc|
    #   cc.symbols.create!(:name => '7♯11', :primary => true)
    #   cc.symbols.create!(:name => 'lyd7')
    #   cc.symbols.create!(:name => 'lydiandom')
    #
    #   cc.chord_scales << ChordScale.new(:mode => Scale['Melodic Minor'].modes.find_by(mode:4), :offset => -5)
    # end
    #
    # c.children.create!(:chord_quality => q, :name => 'Mixoylidian b6', :specify_tones => "u 3 5 ♭6 ♭7").tap do |cc|
    #   cc.symbols.create!(:name => '7b6', :primary => true)
    #
    #   cc.chord_scales << ChordScale.new(:mode => Scale['Melodic Minor'].modes.find_by(mode:5), :offset => 5)
    # end
    #
    # c.children.create!(:chord_quality => q, :name => 'Altered', :specify_tones => "u 3 ♯5 ♭7 ♭2 ♯2").tap do |cc|
    #   cc.symbols.create!(:name => '7alt', :primary => true)
    #   cc.symbols.create!(:name => '7altered')
    #   cc.symbols.create!(:name => 'alt')
    #   cc.symbols.create!(:name => 'altered')
    #   cc.symbols.create!(:name => '7♯9♯5')
    #   cc.symbols.create!(:name => '7♯5♯9')
    #   cc.symbols.create!(:name => '7b9♯9')
    #   cc.symbols.create!(:name => '7♯9b9')
    #   cc.symbols.create!(:name => '7♯5')
    #
    #   cc.chord_scales << ChordScale.new(:mode => Scale['Melodic Minor'].modes.find_by(mode:7), :offset => 1)
    # end

  end
end


ChordQuality.create!(:name => 'Diminué', :code => 'DIM').tap do |q|
  q.chords.create!(:name => 'Triade diminuée', :specify_tones => "1 3m 5dim").tap do |c|
    c.symbols.create!(:name => 'dim', :primary => true)
    c.symbols.create!(:name => 'b5')
    c.symbols.create!(:name => 'd')
    c.symbols.create!(:name => '°')
    c.symbols.create!(:name => 'triade dim.')

    c.chord_scales << ChordScale.new(:mode => Scale['Diminuée'].modes.find_by(mode:1), :offset => 0)
    c.chord_scales << ChordScale.new(:mode => Scale['Diminuée'].modes.find_by(mode:2), :offset => 0)
  end

  q.chords.create!(:name => 'Demi-diminué', :specify_tones => "1 3m 5dim 7m").tap do |c|
    c.symbols.create!(:name => 'Ø', :primary => true)
    c.symbols.create!(:name => 'dim7')
    c.symbols.create!(:name => 'm7 5-')
    c.symbols.create!(:name => '-7 ♭5')
    c.symbols.create!(:name => '7b5')
    c.symbols.create!(:name => 'min7 (♭5)')


    c.chord_scales << ChordScale.new(:mode => Scale['Majeure'].modes.find_by(mode:7), :offset => 1)
    c.chord_scales << ChordScale.new(:mode => Scale['Mineure mélodique'].modes.find_by(mode:6), :offset => 1)
  end

  q.chords.create!(:name => 'Diminué', :specify_tones => "1 3m 5dim 7m").tap do |c|
    c.symbols.create!(:name => '°7', :primary => true)
    c.symbols.create!(:name => '°')
    c.symbols.create!(:name => 'dim7')

    c.chord_scales << ChordScale.new(:mode => Scale['Diminuée'].modes.find_by(mode:1), :offset => 0)
    c.chord_scales << ChordScale.new(:mode => Scale['Diminuée'].modes.find_by(mode:2), :offset => 0)
  end
end

ChordQuality.create!(:name => 'Augmenté', :code => 'DIM').tap do |q|
  q.chords.create!(:name => 'Triade augmentée', :specify_tones => "1 3 5aug").tap do |c|
    c.symbols.create!(:name => 'Aug', :primary => true)
    c.symbols.create!(:name => 'augm.')
    c.symbols.create!(:name => '+')
    c.symbols.create!(:name => 'triade aug.')

    #TODO :
    #c.chord_scales << ChordScale.new(:mode => Scale['Diminished'].modes.find_by(mode:1), :offset => 0)
    #c.chord_scales << ChordScale.new(:mode => Scale['Diminished'].modes.find_by(mode:2), :offset => 0)
  end

  q.chords.create!(:name => 'Augmenté septième majeure', :specify_tones => "1 3 5aug 7").tap do |c|
    c.symbols.create!(:name => 'Δ ♯5', :primary => true)

    #TODO :
    #c.chord_scales << ChordScale.new(:mode => Scale['Major'].modes.find_by(mode:7), :offset => 1)
    #c.chord_scales << ChordScale.new(:mode => Scale['Melodic Minor'].modes.find_by(mode:6), :offset => 1)
  end
end