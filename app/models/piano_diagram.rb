# Keyboard of at least two octaves (from C of the first key's octave) with the given keys highlighted, as SVG
class PianoDiagram
  MIN_OCTAVES = 2
  WHITE_WIDTH, WHITE_HEIGHT = 24, 110
  BLACK_WIDTH, BLACK_HEIGHT = 14, 68
  LINE_COLOR, HIGHLIGHT_COLOR = '#16202b', '#1864ab'
  # Semitone offsets in an octave, and the white key a black key sits after
  WHITE_OFFSETS = [0, 2, 4, 5, 7, 9, 11]
  BLACK_OFFSETS = {1 => 0, 3 => 1, 6 => 3, 8 => 4, 10 => 5}

  def initialize(keys)
    @keys = keys
    @first_octave = keys.first&.octave || 4
    @octaves = [MIN_OCTAVES, (keys.map(&:octave).max || @first_octave) - @first_octave + 1].max
  end

  def width
    WHITE_WIDTH * WHITE_OFFSETS.size * @octaves + 2
  end

  def height
    WHITE_HEIGHT + 2
  end

  def to_svg(title:)
    svg = []
    svg << %(<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 #{width} #{height}" width="#{width * 2}" height="#{height * 2}" font-family="Lato, Helvetica, Arial, sans-serif">)
    svg << %(<title>#{ERB::Util.h(title)}</title>)
    svg << %(<rect width="#{width}" height="#{height}" fill="#fff"/>)

    @octaves.times do |octave|
      WHITE_OFFSETS.each_with_index do |offset, i|
        x = 1 + (octave * WHITE_OFFSETS.size + i) * WHITE_WIDTH
        key = highlighted_key(octave, offset)
        svg << %(<rect x="#{x}" y="1" width="#{WHITE_WIDTH}" height="#{WHITE_HEIGHT}" fill="#{key ? HIGHLIGHT_COLOR : '#fff'}" stroke="#{LINE_COLOR}" stroke-width="1.5"/>)
        svg << label(key, x + WHITE_WIDTH / 2.0, WHITE_HEIGHT - 8) if key
      end
    end

    @octaves.times do |octave|
      BLACK_OFFSETS.each do |offset, white_index|
        x = 1 + (octave * WHITE_OFFSETS.size + white_index + 1) * WHITE_WIDTH - BLACK_WIDTH / 2.0
        key = highlighted_key(octave, offset)
        svg << %(<rect x="#{x}" y="1" width="#{BLACK_WIDTH}" height="#{BLACK_HEIGHT}" fill="#{key ? HIGHLIGHT_COLOR : LINE_COLOR}" stroke="#{LINE_COLOR}" stroke-width="1"/>)
        svg << label(key, x + BLACK_WIDTH / 2.0, BLACK_HEIGHT - 8, size: 8) if key
      end
    end

    svg << %(</svg>)
    svg.join("\n")
  end

  private

  def highlighted_key(octave, offset)
    @keys.find { |key| key.index == offset && key.octave == @first_octave + octave }
  end

  def label(key, x, y, size: 10)
    %(<text x="#{x}" y="#{y}" font-size="#{size}" font-weight="bold" text-anchor="middle" fill="#fff">#{ERB::Util.h(key.name)}</text>)
  end
end
