# Guitar chord shape, imported from chords-db (https://github.com/tombatossals/chords-db, MIT)
# with `rake guitar:import`. Frets are relative to base_fret, -1 = muted string.
class GuitarVoicing
  DATA_PATH = Rails.root.join('db/data/guitar_voicings.json')

  CHORDS_DB_SUFFIXES = {
    'majeur' => 'major', 'majeur-7' => 'maj7', 'majeur-6' => '6',
    'mineur' => 'minor', 'mineur-7' => 'm7', 'mineur-6' => 'm6', 'mineur-septieme-majeure' => 'mmaj7',
    'septieme-de-dominante' => '7', '7-diese5' => 'aug7', '7-bemol5' => '7b5', '7-sus-4' => '7sus4',
    'triade-diminuee' => 'dim', 'demi-diminue' => 'm7b5', 'septieme-diminuee' => 'dim7',
    'triade-augmentee' => 'aug', 'augmente-septieme-majeure' => 'maj7#5',
    'add-9' => 'add9', 'majeur-9' => 'maj9', 'majeur-6-9' => '69', 'mineur-9' => 'm9',
    'neuvieme' => '9', '7-bemol9' => '7b9', '7-diese9' => '7#9', 'treizieme' => '13',
    'sus-2' => 'sus2', 'sus-4' => 'sus4'
  }

  STRINGS = 6
  FRETS = 4

  attr_reader :frets, :fingers, :base_fret, :barres

  def self.data
    @data ||= File.exist?(DATA_PATH) ? JSON.parse(File.read(DATA_PATH)) : {}
  end

  def self.for(chord)
    key = chord.key || Key.default
    (data.dig(chord.slug, key.index.to_s) || []).map { |attributes| new(attributes) }
  end

  def initialize(attributes)
    @frets = attributes['frets']
    @fingers = attributes['fingers']
    @base_fret = attributes['baseFret']
    @barres = attributes['barres'] || []
  end

  # Absolute frets, low E to high E, e.g. "x02010" or "x-12-14-12-13-12"
  def tablature
    absolute = frets.map { |f| f < 0 ? 'x' : (f.zero? ? 0 : f + base_fret - 1).to_s }
    absolute.any? { |f| f.size > 1 } ? absolute.join('-') : absolute.join
  end

  def to_svg(title:)
    left, top, string_gap, fret_gap = 28, 34, 16, 24
    width = left * 2 + string_gap * (STRINGS - 1)
    height = top + fret_gap * FRETS + 14
    x = ->(string) { left + string * string_gap }
    y = ->(fret) { top + (fret - 0.5) * fret_gap }
    right = x.(STRINGS - 1)
    bottom = top + fret_gap * FRETS

    svg = []
    svg << %(<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 #{width} #{height}" width="#{width * 2}" height="#{height * 2}" font-family="Lato, Helvetica, Arial, sans-serif">)
    svg << %(<title>#{ERB::Util.h(title)}</title>)
    svg << %(<rect width="#{width}" height="#{height}" fill="#fff"/>)
    (0..FRETS).each { |f| svg << %(<line x1="#{left}" y1="#{top + f * fret_gap}" x2="#{right}" y2="#{top + f * fret_gap}" stroke="#16202b" stroke-width="1"/>) }
    (0...STRINGS).each { |s| svg << %(<line x1="#{x.(s)}" y1="#{top}" x2="#{x.(s)}" y2="#{bottom}" stroke="#16202b" stroke-width="1"/>) }

    if base_fret == 1
      svg << %(<rect x="#{left - 1}" y="#{top - 4}" width="#{right - left + 2}" height="4" fill="#16202b"/>)
    else
      svg << %(<text x="#{left - 8}" y="#{y.(1) + 4}" font-size="11" text-anchor="end" fill="#16202b">#{base_fret}fr</text>)
    end

    frets.each_with_index do |fret, s|
      next unless fret <= 0
      svg << if fret < 0
        %(<text x="#{x.(s)}" y="#{top - 10}" font-size="11" text-anchor="middle" fill="#16202b">×</text>)
      else
        %(<circle cx="#{x.(s)}" cy="#{top - 14}" r="4" fill="none" stroke="#16202b" stroke-width="1"/>)
      end
    end

    barres.each do |barre|
      strings = (0...STRINGS).select { |s| frets[s] == barre }
      next if strings.size < 2
      svg << %(<rect x="#{x.(strings.first) - 7}" y="#{y.(barre) - 7}" width="#{x.(strings.last) - x.(strings.first) + 14}" height="14" rx="7" fill="#16202b"/>)
    end

    frets.each_with_index do |fret, s|
      next unless fret > 0
      svg << %(<circle cx="#{x.(s)}" cy="#{y.(fret)}" r="7" fill="#16202b"/>)
      svg << %(<text x="#{x.(s)}" y="#{y.(fret) + 4}" font-size="10" text-anchor="middle" fill="#fff">#{fingers[s]}</text>) if fingers[s].to_i > 0
    end

    svg << %(</svg>)
    svg.join("\n")
  end
end
