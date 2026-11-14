# Common jazz voicings of a chord, written note by note so they can be shown on a staff and played:
# shells (root, third, seventh) for the left hand, drop 2 for four-note chords, rootless voicings for
# chords with a ninth. Notes are VexFlow strings ("Eb/4"), octave of the letter as on the staff.
class JazzVoicing
  LETTERS = { 'C' => 0, 'D' => 2, 'E' => 4, 'F' => 5, 'G' => 7, 'A' => 9, 'B' => 11 }.freeze

  Voicing = Data.define(:name, :formula, :clef, :notes, :description)

  # A chord tone: its degree (1, 3, 7, 9…), the key spelling it and its pitch class
  Tone = Data.define(:degree, :key, :pitch_class)

  def self.for(chord)
    new(chord).voicings
  end

  def initialize(chord)
    @chord = chord.in_c
    keys = @chord.keys
    degrees = [1] + @chord.intervals.map(&:degree)
    @tones = keys.zip(degrees).map { |key, degree| Tone.new(degree, key, key.index % 12) }
  end

  def voicings
    return [] if @tones.size < 4

    root, third, fifth, seventh = tone(1), tone(3) || tone(4), tone(5), tone(7) || tone(6)
    ninth, thirteenth = tone(9), tone(13)
    return [] unless third && seventh

    list = [
      build('Shell', :bass, [root, third, seventh], -14..-3,
        "Fondamentale, tierce et septième (ou leurs remplaçantes, quarte ou sixte) : les trois notes qui définissent l'accord. C'est le voicing de base de la main gauche au piano, et celui des guitaristes en accompagnement."),
      build('Shell renversé', :bass, [root, seventh, third], -14..-3,
        "Les mêmes notes, la septième sous la tierce. En alternant les deux formes, on enchaîne un II-V-I presque sans bouger : la septième de chaque accord descend sur la tierce du suivant.")
    ]
    if @tones.size == 4 && fifth
      list << build('Drop 2', :treble, [fifth, root, third, seventh], -8..3,
        "L'accord serré dont la deuxième voix en partant du haut descend d'une octave : un voicing ouvert, facile à jouer à la guitare et très utilisé dans les arrangements pour big band.")
    end
    if ninth && fifth && thirteenth.nil?
      list << build('Sans fondamentale (A)', :treble, [third, fifth, seventh, ninth], -3..8,
        "La fondamentale est laissée à la contrebasse : tierce, quinte, septième et neuvième, le son du piano jazz depuis Bill Evans et Wynton Kelly.")
      list << build('Sans fondamentale (B)', :treble, [seventh, ninth, third, fifth], -6..5,
        "Le renversement de la forme A, septième en bas. On alterne A et B d'un accord à l'autre pour garder les voix proches.")
    end
    if ninth && thirteenth
      list << build('Sans fondamentale', :treble, [third, seventh, ninth, thirteenth], -3..8,
        "Tierce et septième pour la couleur de dominante, neuvième et treizième pour la richesse : la quinte et la fondamentale ne manquent pas à l'oreille.")
    end
    list
  end

  private

  def tone(degree)
    @tones.find { |t| t.degree == degree }
  end

  # Stacks the tones upwards, the lowest one within `range` (semitones from C4)
  def build(name, clef, tones, range, description)
    pitch = range.find { |p| p % 12 == tones.first.pitch_class }
    pitches = tones.map do |t|
      pitch += 1 until pitch % 12 == t.pitch_class if t != tones.first
      pitch.tap { pitch += 1 }
    end
    Voicing.new(name, tones.map { |t| degree_label(t) }.join(' – '), clef, tones.zip(pitches).map { |t, p| vexflow(t.key, p) }, description)
  end

  NATURAL_STEPS = { 1 => 0, 2 => 2, 3 => 4, 4 => 5, 5 => 7, 6 => 9, 7 => 11, 9 => 2, 11 => 5, 13 => 9 }.freeze

  # "♭3", "7", "♯9": the degree, altered from the major scale
  def degree_label(tone)
    shift = (tone.pitch_class - @tones.first.pitch_class - NATURAL_STEPS.fetch(tone.degree)) % 12
    shift -= 12 if shift > 6
    ('♯' * [shift, 0].max) + ('♭' * [-shift, 0].max) + tone.degree.to_s
  end

  # "Bb/3" for B♭ at 10 semitones under C4; the octave is the letter's, so B♯ above B4 is "B#/4"
  def vexflow(key, pitch)
    letter = key.name[0]
    accidental = key.name.count('♯') - key.name.count('♭')
    octave = 4 + ((pitch - accidental - LETTERS[letter]) / 12.0).round
    "#{letter}#{key.name[1..].tr('♯♭', '#b')}/#{octave}"
  end
end
