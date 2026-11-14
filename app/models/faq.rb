# Questions answered on chord and mode pages, shown on the page and repeated as FAQPage JSON-LD.
# Answers are plain text built from the data, so the markup always matches what visitors read.
module Faq
  Item = Data.define(:question, :answer)

  def self.for_chord(chord)
    c = chord.in_c
    symbol = c.display_symbol
    notes = "#{c.keys.map(&:to_s).to_sentence} (#{c.keys.map(&:french_name).to_sentence})"
    items = [Item.new("Quelles sont les notes de l'accord #{symbol} ?", "L'accord #{symbol} se compose des notes #{notes}.")]

    modes = chord.chord_scales.includes(mode: :scale).map do |chord_scale|
      chord_scale.mode.in_key_of((chord.key || Key.default).shifted(chord_scale.offset)).heading_with_article
    end.uniq
    if modes.any?
      items << Item.new("Quelle gamme jouer sur #{symbol} ?", "Pour improviser sur #{symbol}, on peut jouer #{modes.to_sentence(last_word_connector: ' ou ', two_words_connector: ' ou ')}.")
    end

    voicings = GuitarVoicing.for(chord).map(&:tablature)
    if voicings.any?
      others = voicings.size > 1 ? " Autres positions : #{voicings.from(1).to_sentence}." : ''
      items << Item.new("Comment jouer #{symbol} à la guitare ?",
        "Le doigté le plus courant est #{voicings.first}, de la corde de mi grave à la corde de mi aigu (x : corde non jouée, 0 : corde à vide).#{others}")
    end

    items << Item.new("Comment jouer #{symbol} au piano ?", piano_answer(c, symbol))
    items
  end

  def self.for_mode(mode)
    name = mode.heading_with_article
    notes = "#{mode.keys.map(&:to_s).to_sentence} (#{mode.keys.map(&:french_name).to_sentence})"
    start = mode.key ? '' : " en partant de #{mode.mode_key.french_long_name}"
    # Steps up to the octave, the last one closing the scale
    steps = mode.step_names + [Key::Steps.invert[(mode.keys.first.index - mode.keys.last.index) % 12]]
    items = [
      Item.new("Quelles sont les notes #{mode.heading_with_article('de')} ?", "#{name.upcase_first}#{start} se compose des notes #{notes}."),
      Item.new("Quels sont les intervalles #{mode.heading_with_article('de')} ?",
        "De note en note et jusqu'à l'octave, #{name} enchaîne les intervalles suivants, en tons : #{steps.join(' – ')}.")
    ]
    chords = mode.related_chords.map(&:display_symbol).uniq
    if chords.any?
      items << Item.new("Sur quels accords jouer #{name} ?", "On joue #{name} sur #{chords.to_sentence}.")
    end
    items
  end

  def self.for_scale(scale)
    name = scale.name_in_key
    start = scale.key ? '' : ', en partant de do,'
    notes = "#{scale.keys.map(&:to_s).to_sentence} (#{scale.keys.map(&:french_name).to_sentence})"
    modes = scale.modes.sort_by(&:mode).map { |mode| mode.in_key_of(scale.key || Key.default).heading.sub(/\A\w/, &:downcase) }
    items = [
      Item.new("Quelles sont les notes de la #{name} ?", "La #{name}#{start} se compose des notes #{notes}."),
      Item.new("Combien de modes a la #{name} ?",
        if modes.one?
          "Un seul : sa structure symétrique redonne la même gamme sur chaque degré."
        else
          "#{modes.size} modes#{', un par degré' if scale.heptatonic?} : #{modes.to_sentence}."
        end)
    ]
    if scale.heptatonic?
      chords = scale.modes.sort_by(&:mode).filter_map { |mode| Chord.find_by_keys(mode.in_key_of(scale.key || Key.default).thirds[0..3])&.display_symbol }
      items << Item.new("Quels accords construit-on sur la #{name} ?", "En empilant des tierces sur chaque degré, on obtient #{chords.to_sentence}.")
    end
    items
  end

  def self.for_progression(progression, tonic)
    chords = ->(key) { progression.chords_in(key).map(&:display_symbol).join(' – ') }
    others = %w[G F B♭ D].map { |name| Key.all.find { |key| key.name == name } }.reject { |key| key == tonic }.first(3)
    [
      Item.new("Quels sont les accords de la progression #{progression.short_name} en #{tonic.french_long_name} ?",
        "En #{tonic.french_long_name} : #{chords.(tonic)} (#{progression.roman_numerals})."),
      Item.new("Comment transposer la progression #{progression.short_name} ?",
        "Les chiffres romains donnent le degré de la gamme sur lequel est construit chaque accord : il suffit de changer de tonique. " \
        "#{others.map { |key| "en #{key.french_long_name} : #{chords.(key)}" }.join(' ; ').upcase_first}.")
    ]
  end

  def self.for_interval(interval)
    name = interval.long_name.downcase
    article = name.start_with?('o') ? "l'" : 'la '
    items = [Item.new("Combien de tons dans une #{name} ?", "#{(article + name).upcase_first} compte #{interval.tones_label}, soit #{interval.semitones} demi-ton#{'s' if interval.semitones > 1}.")]
    first, last = interval.keys.first, interval.keys.last
    items << Item.new("Quelle note est à une #{name} au-dessus de #{first.french_long_name} ?", "Une #{name} au-dessus de #{first.french_long_name} (#{first}), c'est #{last.french_name} (#{last}).")
    unless interval.compound?
      inversion = interval.inversion.long_name.downcase
      items << Item.new("Quel est le renversement de #{article}#{name} ?", "Renversée, #{article}#{name} devient une #{inversion} : les deux intervalles réunis forment une octave.")
    end
    if (songs = IntervalSong.for(interval))
      list = ->(direction) { songs[direction].map { |song| "#{song.title} (#{song.composer})" }.to_sentence }
      items << Item.new("Quel standard de jazz commence par une #{name} ?", "En montant : #{list.(:up)}. En descendant : #{list.(:down)}.")
    end
    items
  end

  def self.for_note(key)
    items = [Item.new("Comment s'appelle la note #{key.name} en français ?",
      "#{key.name} correspond au #{key.french_long_name}. En notation anglaise, A = la, B = si, C = do, D = ré, E = mi, F = fa et G = sol.")]
    enharmonics = Key.all.uniq(&:name).select { |k| k.index == key.index && k.name != key.name }.map(&:to_s)
    if enharmonics.any?
      items << Item.new("Quelles sont les enharmonies de #{key.name} ?", "#{enharmonics.to_sentence} #{enharmonics.one? ? 'sonne' : 'sonnent'} comme #{key.name} : même touche au piano, nom différent.")
    end
    if (position = CircleOfFifths.position_for(key))
      items << Item.new("Combien d'altérations à l'armure de #{key.french_long_name} majeur ?", "La tonalité de #{key.french_long_name} majeur a #{position.signature.zero? ? 'une armure sans altération' : "#{position.signature_text} à l'armure"}.")
    end
    items
  end

  def self.piano_answer(chord, symbol)
    answer = "Jouez #{chord.keys.map(&:to_s).to_sentence} en même temps, en partant de la fondamentale #{chord.keys.first}."
    shell = JazzVoicing.for(chord).first
    return answer unless shell

    notes = shell.notes.map { |note| note.split('/').first.tr('#b', '♯♭') }
    "#{answer} En jazz, la main gauche se contente souvent d'un shell, #{notes.to_sentence} (#{shell.formula.tr('–', '-').delete(' ')}), et laisse les autres notes à la main droite."
  end
  private_class_method :piano_answer
end
