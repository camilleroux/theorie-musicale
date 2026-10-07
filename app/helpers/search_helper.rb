module SearchHelper
  # C pages are canonicalized to the key-less URL
  def search_result_path(record)
    key = record.key if record.respond_to?(:key) && record.key && !record.is_a?(Key) && !record.key.main?
    case record
    when Chord then key ? key_chord_path(key, record) : chord_path(record)
    when Mode then key ? key_scale_mode_path(key, record.scale, record) : scale_mode_path(record.scale, record)
    when Scale then scale_path(record)
    when Interval then interval_path(record)
    when Key then note_path(record)
    when Progression then progression_path(record)
    end
  end

  def search_result_label(record)
    case record
    when Chord then record.heading(display: true)
    when Mode then record.heading
    when Scale then "Gamme #{record.name.downcase}"
    when Interval then "Intervalle : #{record.long_name.downcase}"
    when Key then "Note #{record.name} (#{record.french_long_name})"
    when Progression then record.name
    end
  end

  def search_result_kind(record)
    { Chord => 'Accord', Mode => 'Gamme / mode', Scale => 'Gamme', Interval => 'Intervalle', Key => 'Note', Progression => 'Progression' }[record.class]
  end
end
