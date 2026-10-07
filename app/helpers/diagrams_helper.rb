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
    when Interval
      record.key ? piano_key_interval_url(record.key, record, format: :svg) : piano_interval_url(record, format: :svg)
    when Key
      piano_note_url(record, format: :svg)
    end
  end

  def piano_image_tag(record)
    diagram = PianoDiagram.new(record.is_a?(Key) ? [record] : record.keys)
    image_tag piano_diagram_url(record), alt: piano_diagram_alt(record), width: diagram.width, height: diagram.height,
      loading: 'lazy', class: 'img-fluid d-block mx-auto', style: "width: #{diagram.width * 720 / 338}px"
  end

  def guitar_diagram_alt(chord, position, voicing)
    "Accord #{diagram_symbol(chord)} à la guitare, position #{position} (#{voicing.tablature})"
  end

  def piano_diagram_alt(record)
    keys = record.is_a?(Key) ? [record] : record.keys
    notes = "#{keys.map(&:to_s).to_sentence} (#{keys.map(&:french_name).to_sentence})"
    name = case record
           when Chord then "Accord #{diagram_symbol(record)}"
           when Key then "Note #{record.name}"
           else record.seo_title.split(' : ').first
           end
    "#{name} au piano : #{notes}"
  end

  private

  # Key-less chord pages show diagrams in C
  def diagram_symbol(chord)
    chord.key ? chord.search_symbol : Key.default.name + chord.search_symbol
  end
end
