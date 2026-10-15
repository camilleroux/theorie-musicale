module PlayerHelper
  LABELS = {chord: 'Écouter', arpeggio: 'Arpège', scale: 'Écouter'}

  # Buttons playing notes written as on the staff ("Eb/4"), see app/assets/javascripts/player.js
  def play_buttons(notes, *kinds)
    tag.div(class: 'play-buttons', role: 'group', aria: {label: 'Écouter'}) do
      safe_join(kinds.map { |kind| play_button(notes, kind) })
    end
  end

  private

  def play_button(notes, kind)
    tag.button(play_icon + tag.span(LABELS.fetch(kind)), type: 'button', class: 'play-button btn btn-outline-primary btn-sm',
      aria: {pressed: false}, data: {play: kind, notes: notes.to_json})
  end

  # A triangle that becomes a square while its button is pressed
  def play_icon
    tag.svg(tag.path(class: 'icon-play', d: 'M4.5 2.8v10.4L13 8z') + tag.rect(class: 'icon-stop', x: 3.5, y: 3.5, width: 9, height: 9, rx: 1),
      class: 'play-icon', viewBox: '0 0 16 16', aria: {hidden: true})
  end
end
