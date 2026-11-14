module CircleOfFifthsHelper
  SIZE = 400
  CENTER = SIZE / 2

  # The circle as inline SVG: one clickable wedge per key, major key outside, relative minor and signature inside.
  # Each wedge links to the key's panel (#tonalite-g), the script only shows that panel instead of scrolling to it.
  def circle_of_fifths_svg(positions)
    wedges = positions.map do |position|
      angle = position.index * 30
      label = "#{position.tonic.french_long_name} majeur (#{position.name}), relative #{position.relative_minor.french_long_name} mineur, #{position.signature_text}"
      tag.a(href: "##{position.anchor}", class: 'circle__wedge', data: { circle_key: position.anchor }, aria: { label: label }) do
        safe_join([
          tag.path(d: wedge_path(angle - 15, angle + 15, 62, 192)),
          circle_text(position.name, 160, angle, 'circle__major'),
          circle_text(position.minor_name, 116, angle, 'circle__minor'),
          circle_text(position.signature_label, 82, angle, 'circle__signature')
        ])
      end
    end
    center = [tag.circle(cx: CENTER, cy: CENTER, r: 60, class: 'circle__center'),
              tag.text('quintes ↻', x: CENTER, y: CENTER + 5, class: 'circle__center-label', 'text-anchor': 'middle')]
    tag.svg(safe_join(wedges + center), viewBox: "0 0 #{SIZE} #{SIZE}", class: 'circle', role: 'group',
      aria: { label: 'Cycle des quintes : choisissez une tonalité' })
  end

  # Link to a chord page, C pages being canonicalized to the key-less URL
  def circle_chord_link(chord)
    link_to chord.display_symbol, search_result_path(chord), title: chord.heading(display: true)
  end

  # Major scale mode (ionien, eolien…) built on a major key
  def circle_mode_path(tonic, mode_slug)
    scale = Scale.friendly.find('majeure')
    mode = scale.modes.friendly.find(mode_slug)
    tonic.main? ? scale_mode_path(scale, mode) : key_scale_mode_path(tonic, scale, mode)
  end

  def progression_in_key_path(slug, tonic)
    return unless Key.primaries.include?(tonic)

    progression_path(slug, tonalite: (tonic.to_param unless tonic.main?))
  end

  def circle_of_fifths_faq
    [
      Faq::Item.new("Comment mémoriser l'ordre des dièses et des bémols ?", "Les dièses apparaissent dans l'ordre fa, do, sol, ré, la, mi, si, chacun une quinte au-dessus du précédent. Les bémols suivent l'ordre inverse : si, mi, la, ré, sol, do, fa. Le dernier dièse de l'armure est un demi-ton sous la tonique ; l'avant-dernier bémol donne le nom de la tonalité."),
      Faq::Item.new("Comment trouver la relative mineure d'une tonalité ?", "La relative mineure part du 6e degré de la gamme majeure, une tierce mineure sous la tonique : la mineur pour do majeur, mi mineur pour sol majeur. Les deux tonalités ont la même armure."),
      Faq::Item.new("Dans quel sens tourner pour enchaîner un II-V-I ?", "Dans le sens inverse des aiguilles d'une montre : chaque fondamentale est une quinte sous la précédente. En do, Dm7, G7 et Cmaj7 occupent trois cases voisines."),
      Faq::Item.new("Qu'est-ce que la substitution tritonique ?", "C'est le remplacement d'un accord de septième de dominante par celui qui se trouve à un triton, à l'opposé sur le cercle : D♭7 à la place de G7. Les deux accords partagent leur tierce et leur septième (fa et si, ou do♭), ce qui permet une ligne de basse chromatique : Dm7 – D♭7 – Cmaj7.")
    ]
  end

  private

  def point(radius, angle)
    radians = angle * Math::PI / 180
    [(CENTER + radius * Math.sin(radians)).round(2), (CENTER - radius * Math.cos(radians)).round(2)]
  end

  def wedge_path(from, to, inner, outer)
    a, b, c, d = point(outer, from), point(outer, to), point(inner, to), point(inner, from)
    "M#{a.join(',')} A#{outer},#{outer} 0 0 1 #{b.join(',')} L#{c.join(',')} A#{inner},#{inner} 0 0 0 #{d.join(',')} Z"
  end

  def circle_text(text, radius, angle, css_class)
    x, y = point(radius, angle)
    tag.text(text, x: x, y: y, class: css_class, 'text-anchor': 'middle', 'dominant-baseline': 'central')
  end
end
