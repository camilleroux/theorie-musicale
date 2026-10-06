module ChordsHelper
  def guitar_diagram_url(chord, position)
    chord.key ? guitar_key_chord_url(chord.key, chord, position: position, format: :svg) : guitar_chord_url(chord, position: position, format: :svg)
  end

  def piano_diagram_url(chord)
    chord.key ? piano_key_chord_url(chord.key, chord, format: :svg) : piano_chord_url(chord, format: :svg)
  end

  def guitar_diagram_alt(chord, position, voicing)
    "Accord #{diagram_symbol(chord)} à la guitare, position #{position} (#{voicing.tablature})"
  end

  def piano_diagram_alt(chord)
    "Accord #{diagram_symbol(chord)} au piano : #{chord.keys.map(&:to_s).to_sentence} (#{chord.keys.map(&:french_name).to_sentence})"
  end

  private

  # Key-less chord pages show diagrams in C
  def diagram_symbol(chord)
    chord.key ? chord.search_symbol : Key.default.name + chord.search_symbol
  end
end
