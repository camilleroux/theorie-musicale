# The 12 major keys clockwise by ascending fifths, with their relative minor and key signature.
# Each position knows the chords a jazz musician needs in that key: diatonic seventh chords, II-V-I,
# tritone substitution of the dominant and minor II-V-I of the relative minor.
class CircleOfFifths
  SHARPS = %w[F C G D A E B].freeze
  FLATS = %w[B E A D G C F].freeze

  # Major key, enharmonic spelling shown next to it, signature (positive: sharps, negative: flats)
  POSITIONS = [['C', nil, 0], ['G', nil, 1], ['D', nil, 2], ['A', nil, 3], ['E', nil, 4], ['B', nil, 5],
               ['G♭', 'F♯', -6], ['D♭', nil, -5], ['A♭', nil, -4], ['E♭', nil, -3], ['B♭', nil, -2], ['F', nil, -1]].freeze

  # Major keys that can be written with a key signature, and their signature (positive: sharps, negative: flats)
  SIGNATURES = { 'C' => 0, 'G' => 1, 'D' => 2, 'A' => 3, 'E' => 4, 'B' => 5, 'F♯' => 6, 'C♯' => 7,
                 'F' => -1, 'B♭' => -2, 'E♭' => -3, 'A♭' => -4, 'D♭' => -5, 'G♭' => -6, 'C♭' => -7 }.freeze

  # Triads on each degree of the major scale and their harmonic function
  TRIADS = [['majeur', 'I'], ['mineur', 'IIm'], ['mineur', 'IIIm'], ['majeur', 'IV'], ['majeur', 'V'], ['mineur', 'VIm'], ['triade-diminuee', 'VII°']].freeze
  FUNCTIONS = %w[Tonique Sous-dominante Tonique Sous-dominante Dominante Tonique Dominante].freeze

  # Seventh chords on each degree of the major scale: semitones above the tonic, chord slug, roman numeral
  DIATONIC = [[0, 'majeur-7', 'IΔ'], [2, 'mineur-7', 'IIm7'], [4, 'mineur-7', 'IIIm7'], [5, 'majeur-7', 'IVΔ'],
              [7, 'septieme-de-dominante', 'V7'], [9, 'mineur-7', 'VIm7'], [11, 'demi-diminue', 'VIIø']].freeze

  Position = Struct.new(:index, :tonic, :enharmonic, :signature, keyword_init: true) do
    def name
      [tonic.name, enharmonic].compact.join('/')
    end

    def anchor
      "tonalite-#{tonic.to_param}"
    end

    def relative_minor
      Key.from_index(tonic.index + 9, tonic.letter_index + 5)
    end

    def minor_name
      enharmonic ? "#{relative_minor.name}m/D♯m" : "#{relative_minor.name}m"
    end

    # "2♯", "3♭", "0"
    def signature_label
      signature.zero? ? '0' : "#{signature.abs}#{signature.positive? ? '♯' : '♭'}"
    end

    # "2 dièses (fa♯ et do♯)", "aucune altération"
    def signature_text
      return 'aucune altération' if signature.zero?

      sign, word, order = signature.positive? ? ['♯', 'dièse', SHARPS] : ['♭', 'bémol', FLATS]
      notes = order.first(signature.abs).map { |letter| "#{Key::FrenchNames[letter]}#{sign}" }
      "#{signature.abs} #{word.pluralize(signature.abs)} (#{notes.to_sentence})"
    end

    # Seventh chords of the key with their roman numeral
    def diatonic_chords
      DIATONIC.each_with_index.map do |(semitones, slug, roman), degree|
        [roman, Chord.friendly.find(slug).in_key_of(Key.from_index(tonic.index + semitones, tonic.letter_index + degree))]
      end
    end

    def degree_key(degree)
      semitones = DIATONIC[degree].first
      Key.from_index(tonic.index + semitones, tonic.letter_index + degree)
    end

    def diatonic_triads
      TRIADS.each_with_index.map { |(slug, roman), degree| [roman, Chord.friendly.find(slug).in_key_of(degree_key(degree))] }
    end

    # The major key a fifth above and below, when it has a key signature
    def neighbour_keys
      [[tonic.index + 5, tonic.letter_index + 3], [tonic.index + 7, tonic.letter_index + 4]].filter_map do |index, letter|
        key = Key.from_index(index, letter)
        key if SIGNATURES.key?(key.name)
      end
    end

    def ii_v_i
      diatonic_chords.values_at(1, 4, 0).map(&:last)
    end

    # Dominant a tritone away from V7 (D♭7 for G7), the key across the circle, spelled the usual way (G7, not A♭♭7)
    def tritone_substitute
      Chord.friendly.find('septieme-de-dominante').in_key_of(ii_v_i[1].key.shifted(6))
    end

    def minor_ii_v_i
      Progression.find('ii-v-i-mineur').chords_in(relative_minor)
    end
  end

  def self.positions
    POSITIONS.each_with_index.map do |(name, enharmonic, signature), index|
      Position.new(index: index, tonic: Key.all.find { |key| key.name == name }, enharmonic: enharmonic, signature: signature)
    end
  end

  # Position of any major key with a key signature (F♯ and C♯ included), nil for theoretical keys (G♯ major)
  def self.position_for(key)
    signature = SIGNATURES[key.name] or return
    index = POSITIONS.index { |name, enharmonic, _| [name, enharmonic].include?(key.name) }
    Position.new(index: index, tonic: key, enharmonic: nil, signature: signature)
  end

  # Neighbours on the circle share all notes but one: the keys a fifth above and below
  def self.neighbours(position, positions = self.positions)
    [positions[(position.index - 1) % 12], positions[(position.index + 1) % 12]]
  end
end
