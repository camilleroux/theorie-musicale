module DiagramsHelper
  def guitar_diagram_url(chord, position)
    chord.key ? guitar_key_chord_url(chord.key, chord, position: position, format: :svg) : guitar_chord_url(chord, position: position, format: :svg)
  end

  def piano_diagram_url(record)
    case record
    when Chord
      record.key ? piano_key_chord_url(record.key, record, format: :svg) : piano_chord_url(record, format: :svg)
    when Mode
      record.key ? piano_key_scale_mode_url(record.key, record.scale, record, format: :svg) : piano_scale_mode_url(record.scale, record, format: :svg)
    end
  end

  def guitar_diagram_alt(chord, position, voicing)
    "Accord #{diagram_symbol(chord)} à la guitare, position #{position} (#{voicing.tablature})"
  end

  def piano_diagram_alt(record)
    notes = "#{record.keys.map(&:to_s).to_sentence} (#{record.keys.map(&:french_name).to_sentence})"
    name = record.is_a?(Chord) ? "Accord #{diagram_symbol(record)}" : record.seo_title.split(' : ').first
    "#{name} au piano : #{notes}"
  end

  private

  # Key-less chord pages show diagrams in C
  def diagram_symbol(chord)
    chord.key ? chord.search_symbol : Key.default.name + chord.search_symbol
  end
end
