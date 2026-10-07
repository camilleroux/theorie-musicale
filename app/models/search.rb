# Finds the pages matching what visitors type: chord symbols ("Am7", "Bbmaj7", "F#m7b5"),
# French names ("la mineur 7", "si bémol majeur", "ré dorien"), scales, modes, intervals,
# notes and progressions ("2 5 1", "blues"). Returns records ready for polymorphic URLs.
class Search
  FRENCH_NOTES = { 'do' => 'C', 're' => 'D', 'mi' => 'E', 'fa' => 'F', 'sol' => 'G', 'la' => 'A', 'si' => 'B' }
  ACCIDENTALS = { '#' => '♯', '♯' => '♯', 'diese' => '♯', 'b' => '♭', '♭' => '♭', 'bemol' => '♭' }
  # Usual ways of writing a chord suffix, mapped to Chord::SEARCH_SYMBOLS
  SUFFIX_ALIASES = {
    'M' => '', 'maj' => '', 'min' => 'm', '-' => 'm', 'M7' => 'maj7', 'Δ' => 'maj7', 'Δ7' => 'maj7', 'ma7' => 'maj7',
    'min7' => 'm7', '-7' => 'm7', 'ø' => 'm7b5', 'Ø' => 'm7b5', 'ø7' => 'm7b5', 'min7b5' => 'm7b5', '-7b5' => 'm7b5',
    '°' => 'dim', '°7' => 'dim7', 'o7' => 'dim7', '+' => 'aug', '+5' => 'aug', '7+5' => '7#5', '+7' => '7#5',
    'sus' => 'sus4', '7sus' => '7sus4', '69' => '6/9', 'mmaj7' => 'mMaj7', 'mΔ' => 'mMaj7', '-Δ' => 'mMaj7'
  }
  PROGRESSION_ALIASES = {
    'ii-v-i-majeur' => ['251', 'iivi', '2-5-1', 'ii-v-i', 'deux cinq un', 'ii v i'],
    'ii-v-i-mineur' => ['251 mineur', 'ii-v-i mineur', '2-5-1 mineur', 'ii v i mineur'],
    'anatole' => ['anatole', 'turnaround', '1625', 'i-vi-ii-v', 'rythm changes', 'rhythm changes'],
    'blues' => ['blues', 'grille blues', 'blues 12 mesures', 'douze mesures'],
    'i-v-vi-iv' => ['i-v-vi-iv', '1564', 'pop']
  }

  attr_reader :query

  def initialize(query)
    @query = query.to_s.strip.gsub(/\s+/, ' ')[0, 60]
  end

  def results
    return [] if query.blank?

    @results ||= [*chords, *modes, *scales, *intervals, *notes, *progressions].uniq { |r| [r.class, r.to_param, (r.key.to_param if r.respond_to?(:key) && r.key)] }
  end

  private

  def normalized
    @normalized ||= I18n.transliterate(query.downcase)
      .sub(/\A(accords?|gammes?|modes?|intervalles?|notes?|progressions?|grilles?)\s+(de |d')?/, '')
  end

  # "Am7", "Bbm7b5", "F#7", "C♯m"
  def chords
    if (m = query.match(/\A([A-Ga-g])(#|♯|b|♭)?\s*(.*)\z/))
      key = key_for(m[1], m[2])
      chord = chord_for_suffix(m[3])
      return [chord.in_key_of(key)] if key && chord
    end
    with_french_note { |key, rest| chord_for_name(rest)&.in_key_of(key) }
  end

  # "ré dorien", "gamme de la mineur harmonique", "dorien", "mode lydien"
  def modes
    with_note = with_french_note do |key, rest|
      mode = mode_for_name(rest)
      mode&.in_key_of(key.shifted(-mode_offset(mode)))
    end
    with_note.presence || [mode_for_name(normalized)].compact
  end

  def scales
    Scale.all.select { |s| [s.name, "gamme #{s.name}"].map { |n| simplify(n) }.include?(simplify(normalized)) }
  end

  def intervals
    Interval.all.select { |i| simplify(i.long_name) == simplify(normalized) }
  end

  # "do", "si bémol", "C", "F#"
  def notes
    if (m = query.match(/\A([A-Ga-g])(#|♯|b|♭)?\z/))
      key = key_for(m[1], m[2])
      return [key].compact
    end
    with_french_note { |key, rest| key if rest.empty? }
  end

  def progressions
    q = simplify(normalized).delete(' ')
    Progression.all.select do |p|
      [p.slug, p.short_name, *PROGRESSION_ALIASES[p.slug]].any? { |a| simplify(a).delete(' ') == q }
    end
  end

  # Yields the key and the rest of the query when it starts with a French note name ("la", "si bémol")
  def with_french_note
    m = normalized.match(/\A(do|re|mi|fa|sol|la|si)(?:\s*(diese|bemol|#|b)(?![a-z]))?\s*(.*)\z/)
    return [] unless m

    key = key_for(FRENCH_NOTES[m[1]], m[2])
    key ? [yield(key, m[3].strip)].compact : []
  end

  def key_for(letter, accidental)
    Key.all.find { |k| k.name == "#{letter.upcase}#{ACCIDENTALS[accidental.to_s]}" }
  end

  def chord_for_suffix(suffix)
    suffix = suffix.strip.tr('♭♯', 'b#')
    suffix = SUFFIX_ALIASES.fetch(suffix) { SUFFIX_ALIASES.fetch(suffix.downcase, suffix) }
    slug = Chord::SEARCH_SYMBOLS.find { |_slug, symbol| symbol.downcase == suffix.downcase }&.first
    Chord.find_by(slug: slug) if slug
  end

  # "mineur 7", "majeur", "septieme de dominante", "m7", "" (major)
  def chord_for_name(name)
    return chord_for_suffix('') if name.empty?

    Chord.all.find { |c| simplify(c.name) == simplify(name) } || chord_for_suffix(name)
  end

  def mode_for_name(name)
    return if name.blank?

    target = simplify(name).sub(/\Amineure? naturel(le)?\z/, 'eolien').sub(/\Amineur /, 'mineure ').sub(/\Amajeur\z/, 'ionien')
    Mode.includes(:scale).find { |m| simplify(m.name) == target }
  end

  # The URL key is the key of the parent scale, not of the mode itself (D dorien is in C major)
  def mode_offset(mode)
    mode.scale.tones.map(&:tone)[mode.mode - 1] % 12
  end

  def simplify(text)
    I18n.transliterate(text.to_s.downcase).gsub(/[^a-z0-9#\/ ]/, ' ').squeeze(' ').strip
  end
end
