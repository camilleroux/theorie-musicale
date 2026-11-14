module PlayerHelper
  LABELS = {chord: 'Écouter', arpeggio: 'Arpège', scale: 'Écouter'}

  # Buttons playing notes written as on the staff ("Eb/4"), see app/assets/javascripts/player.js
  # The first one plays with the Space bar
  def play_buttons(notes, *kinds)
    tag.div(class: 'play-buttons', role: 'group', aria: {label: 'Écouter'}) do
      safe_join(kinds.each_with_index.map { |kind, i| play_button(LABELS.fetch(kind), play: kind, notes: notes.to_json, shortcut: (true if i.zero?)) })
    end
  end

  # A button playing a progression in a key (Progression#playback), lighting up the
  # cells of that key's data-play-key elements; `text: nil` makes it an icon only,
  # with the tempo, loop switch and keyboard of the page's progression player
  def progression_play_button(progression, tonic, text: 'Écouter', shortcut: false)
    play_button(text, label: "Écouter #{progression.short_name} en #{tonic}", play: :sequence,
      steps: progression.playback(tonic).to_json, highlight: %([data-play-key="#{tonic.to_param}"]),
      loop: 'progression-loop', tempo: 'progression-tempo', keyboard: 'progression-keyboard', shortcut: (true if shortcut))
  end

  private

  def play_button(text, label: nil, **data)
    content = text ? play_icon + tag.span(text) : play_icon
    tag.button(content, type: 'button', class: ['play-button', 'btn', 'btn-sm', text ? 'btn-outline-primary' : 'btn-link'],
      title: (label unless text), aria: {pressed: false, label: (label unless text)}, data: data)
  end

  # A triangle that becomes a square while its button is pressed
  def play_icon
    tag.svg(tag.path(class: 'icon-play', d: 'M4.5 2.8v10.4L13 8z') + tag.rect(class: 'icon-stop', x: 3.5, y: 3.5, width: 9, height: 9, rx: 1),
      class: 'play-icon', viewBox: '0 0 16 16', aria: {hidden: true})
  end
end
