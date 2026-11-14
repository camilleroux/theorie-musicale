# What a chord is used for, in a jazz musician's words. Shown under the chord definition.
# A role tied to a progression names the chord's step in it, the progression then being spelled in the right key.
class ChordRole
  ROLES = {
    'majeur' => "Accord parfait de base, il se trouve sur les degrés I, IV et V de la gamme majeure : c'est l'accord de la pop, du rock et de toute la musique tonale.",
    'majeur-7' => { progression: 'ii-v-i-majeur', step: 2, text: "En jazz, c'est l'accord de tonique par excellence, celui sur lequel se résout le" },
    'majeur-6' => "En jazz, il remplace souvent le majeur 7 sur la tonique, surtout quand la mélodie joue la fondamentale ou pour conclure un morceau : sa sixte sonne plus swing que la septième majeure.",
    'add-9' => "La neuvième ajoutée sans septième adoucit l'accord majeur sans changer sa fonction : on l'entend beaucoup en pop, en folk et dans les ballades.",
    'majeur-9' => "C'est un majeur 7 enrichi d'une neuvième : il garde sa fonction de tonique avec une couleur plus moderne, très courante au piano jazz.",
    'majeur-6-9' => "Accord de tonique très stable, sans septième, apprécié en jazz et en bossa-nova pour conclure un morceau. Ses cinq notes forment une gamme pentatonique majeure.",
    'mineur' => "Accord parfait mineur, il se trouve sur les degrés II, III et VI de la gamme majeure et sur la tonique des tonalités mineures.",
    'mineur-7' => { progression: 'ii-v-i-majeur', step: 0, text: "En jazz, on le joue le plus souvent comme accord du deuxième degré, au début du" },
    'mineur-9' => "Version enrichie du mineur 7, on la joue souvent sur le deuxième degré d'un II-V-I ou sur les vamps modaux, avec le mode dorien.",
    'mineur-6' => { progression: 'ii-v-i-mineur', step: 2, text: "En jazz, c'est l'accord de tonique mineure qui conclut le" },
    'phrygien' => "Sa seconde mineure, au-dessus de la fondamentale, donne la couleur espagnole du mode phrygien, dont il reprend les notes principales.",
    'mineur-bemol6' => "Sa sixte mineure évoque le mode éolien (gamme mineure naturelle) : on l'entend sur une tonique mineure ou dans une ligne chromatique descendante sous un accord mineur.",
    'mineur-septieme-majeure' => "Accord de tonique mineure à la couleur sombre, typique des musiques de film et des ballades jazz. Il se joue avec la gamme mineure mélodique.",
    'septieme-de-dominante' => { progression: 'ii-v-i-majeur', step: 1, text: "C'est l'accord de tension qui appelle une résolution, la base du blues. En jazz, il occupe le cinquième degré du" },
    '7-diese5' => "Dominante altérée : sa quinte augmentée renforce l'attraction vers l'accord de résolution. On l'accompagne de la gamme par tons.",
    '7-bemol5' => "Dominante à la quinte diminuée, cousine de la substitution tritonique. On la colore avec le mode lydien ♭7 ou la gamme par tons.",
    '7-sus-4' => "Dominante suspendue : la quarte prend la place de la tierce et retarde la résolution. Très présente dans le jazz modal, elle remplace parfois un II-V entier.",
    'neuvieme' => "Dominante enrichie d'une neuvième, très courante en jazz, en funk et en blues.",
    '7-bemol9' => "Dominante tendue qui se résout souvent vers un accord mineur, sur le cinquième degré d'un II-V-I mineur. On l'accompagne de la gamme diminuée demi-ton/ton.",
    '7-diese9' => "Dominante à la fois majeure et mineure (tierce majeure et neuvième augmentée), emblématique du blues, du funk et du rock.",
    'treizieme' => "Dominante très riche, typique du jazz, du gospel et de la soul. On en joue rarement toutes les notes : la tierce, la septième et la treizième suffisent à la faire entendre.",
    'triade-diminuee' => "Triade instable formée de deux tierces mineures. Sur le septième degré de la gamme majeure, elle joue le rôle d'une dominante.",
    'demi-diminue' => { progression: 'ii-v-i-mineur', step: 0, text: "En jazz, c'est l'accord du deuxième degré des tonalités mineures, au début du" },
    'septieme-diminuee' => "Accord symétrique de quatre tierces mineures superposées : ses renversements redonnent le même accord, ce qui en fait un accord de passage idéal. On l'accompagne de la gamme diminuée ton/demi-ton.",
    'triade-augmentee' => "Triade symétrique de deux tierces majeures, souvent utilisée comme accord de passage ou comme dominante altérée.",
    'augmente-septieme-majeure' => "Accord à la couleur lydienne augmentée (3e mode de la gamme mineure mélodique), utilisé en jazz moderne à la place d'un majeur 7.",
    'sus-2' => "Sans tierce, il n'est ni majeur ni mineur : la seconde remplace la tierce et donne une couleur ouverte, très utilisée en pop et en jazz modal.",
    'sus-4' => "Sans tierce, il n'est ni majeur ni mineur : la quarte remplace la tierce et appelle souvent une résolution vers l'accord majeur."
  }.freeze

  attr_reader :text, :progression, :tonic

  def self.for(chord)
    role = ROLES[chord.slug] or return
    role.is_a?(String) ? new(role) : new(role[:text], chord.in_c, Progression.find(role[:progression]), role[:step])
  end

  def initialize(text, chord = nil, progression = nil, step = nil)
    @text, @progression = text, progression
    return unless progression

    # Tonic of the progression in which the chord plays this step, spelled from the scale degree
    step = progression.steps[step]
    root = chord.key
    @tonic = Key.from_index(root.index - step.semitones, root.letter_index - step.degree + 1)
  end

  # "Dm7 – G7 – Cmaj7"
  def chords
    progression.chords_in(tonic).map(&:display_symbol).join(' – ')
  end

  # "do majeur", "do mineur"
  def tonality
    "#{tonic.french_long_name} #{progression.slug.end_with?('mineur') ? 'mineur' : 'majeur'}"
  end
end
