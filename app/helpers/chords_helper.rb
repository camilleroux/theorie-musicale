module ChordsHelper
  def guitar_diagram_url(chord, position)
    chord.key ? guitar_key_chord_url(chord.key, chord, position: position, format: :svg) : guitar_chord_url(chord, position: position, format: :svg)
  end

  def guitar_diagram_alt(chord, position, voicing)
    # Key-less chord pages show voicings in C
    symbol = chord.key ? chord.search_symbol : Key.default.name + chord.search_symbol
    "Accord #{symbol} à la guitare, position #{position} (#{voicing.tablature})"
  end
end
