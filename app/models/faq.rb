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

  def self.piano_answer(chord, symbol)
    "Jouez #{chord.keys.map(&:to_s).to_sentence} en même temps, en partant de la fondamentale #{chord.keys.first}."
  end
  private_class_method :piano_answer
end
