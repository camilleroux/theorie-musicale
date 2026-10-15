# Common chord progressions, written as a chart in roman numerals so they can be rendered in every key
class Progression
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  # A chord of the progression: degree (1-7) of the major scale, semitones above the tonic, chord slug
  Step = Data.define(:degree, :semitones, :chord_slug, :roman)

  FAMILIES = ['Cadences classiques', 'Cadences jazz', 'Turnarounds', 'Blues', 'Pop']
  MAJOR_SCALE = [0, 2, 4, 5, 7, 9, 11]
  ROMANS = %w[I II III IV V VI VII]
  # Chord suffixes after the roman numeral, as written in French method books
  SUFFIXES = {
    '' => 'majeur', 'm' => 'mineur', '6' => 'majeur-6', 'Δ' => 'majeur-7', 'm6' => 'mineur-6', 'm7' => 'mineur-7',
    '7' => 'septieme-de-dominante', '7♭9' => '7-bemol9', 'ø' => 'demi-diminue', '°7' => 'septieme-diminuee'
  }

  attr_reader :slug, :name, :short_name, :family, :chart, :steps, :bars, :summary, :paragraphs

  # `chart` has barlines between bars, chords sharing a bar evenly and % repeating the bar before:
  # "| IIm7 | V7 | IΔ | % |". `steps` are its distinct chords, `bars` their indexes bar by bar.
  def initialize(slug:, name:, short_name:, family:, chart:, summary:, paragraphs:)
    @slug, @name, @short_name, @family, @chart, @summary, @paragraphs = slug, name, short_name, family, chart, summary, paragraphs
    romans = chart.split('|').map(&:split).reject(&:empty?)
    romans = romans.each_with_object([]) { |bar, done| done << (bar == ['%'] ? done.last : bar) }
    @steps = romans.flatten.uniq.map { |roman| self.class.step(roman) }
    @bars = romans.map { |bar| bar.map { |roman| @steps.index { |step| step.roman == roman } } }
  end

  def self.step(roman)
    match = /\A([♭♯]?)(VII|VI|V|IV|III|II|I)(.*)\z/.match(roman) or raise ArgumentError, "bad chord #{roman}"
    accidental, numeral, suffix = match.captures
    degree = ROMANS.index(numeral) + 1
    semitones = (MAJOR_SCALE[degree - 1] + {'♭' => -1, '♯' => 1}.fetch(accidental, 0)) % 12
    Step.new(degree, semitones, SUFFIXES.fetch(suffix), roman)
  end

  def self.all
    ALL
  end

  def self.find(slug)
    ALL.find { |p| p.slug == slug } or raise ActiveRecord::RecordNotFound
  end

  def to_param
    slug
  end

  def roman_numerals
    steps.map(&:roman).join(' – ')
  end

  # Chords of the progression in a key, spelled from the scale degrees (C♯m7 in B, not D♭m7)
  def chords_in(tonic)
    steps.map do |step|
      key = Key.from_index(tonic.index + step.semitones, tonic.letter_index + step.degree - 1)
      Chord.friendly.find(step.chord_slug).in_key_of(key)
    end
  end

  # What a player plays (app/assets/javascripts/player.js): each bar's chords voiced
  # and sharing its 4 beats. `step` and `bar` say what to light up.
  def playback(tonic)
    chords = chords_in(tonic)
    order = bars.each_with_index.flat_map { |steps, bar| steps.map { |step| [step, bar, 4 / steps.size] } }
    voiced = VoiceLeading.new(order.map { |step, _, _| chords[step] }).voiced

    order.zip(voiced).map do |(step, bar, beats), notes|
      {notes: notes, beats: beats, step: step, bar: bar}
    end
  end

  def seo_title
    SeoTitle.fit(name, [" : accords dans les 12 tonalités", " : accords et tonalités", " : accords"])
  end

  def seo_description
    "#{summary} Accords dans les 12 tonalités, avec liens vers la composition de chaque accord."
  end

  ALL = [
    new(
      slug: 'ii-v-i-majeur', name: 'Progression II-V-I majeur', short_name: 'II-V-I majeur', family: 'Cadences jazz',
      chart: '| IIm7 | V7 | IΔ | % |',
      summary: "Le II-V-I (ou 2-5-1) est l'enchaînement d'accords le plus utilisé en jazz : en do, Dm7 – G7 – Cmaj7.",
      paragraphs: [
        "Le II-V-I enchaîne l'accord mineur 7 construit sur le 2e degré, l'accord de septième de dominante du 5e degré et l'accord majeur 7 de la tonique. Les fondamentales descendent par quintes, ce qui crée une forte sensation de résolution.",
        "La septième de l'accord II descend d'un demi-ton vers la tierce de l'accord V, tandis que la tierce du II reste en place et devient la septième du V, qui descend à son tour vers la tierce du I. C'est ce mouvement des voix (les « guide tones ») qu'il faut entendre et viser en improvisation.",
        "Pour improviser, on peut jouer le mode dorien sur le II, le mode mixolydien sur le V et le mode ionien (la gamme majeure) sur le I, qui partagent toutes les notes de la gamme majeure de la tonalité."
      ]
    ),
    new(
      slug: 'ii-v-i-mineur', name: 'Progression II-V-I mineur', short_name: 'II-V-I mineur', family: 'Cadences jazz',
      chart: '| IIø | V7 | Im6 | % |',
      summary: "Le II-V-I mineur résout vers un accord mineur : en do mineur, Dm7b5 – G7 – Cm6.",
      paragraphs: [
        "En mineur, l'accord du 2e degré est demi-diminué (m7♭5) et l'accord du 5e degré reste un accord de septième de dominante, souvent enrichi d'une neuvième mineure (G7♭9). La tonique peut être un accord mineur 6 ou mineur septième majeure.",
        "Ces accords viennent de la gamme mineure harmonique : le demi-diminué est son 2e degré et l'accord de dominante son 5e degré. Le mode mixolydien ♭9 ♭13 (5e mode de la mineure harmonique) ou le mode altéré conviennent bien sur le V.",
        "Sur le I mineur, la gamme mineure mélodique donne la couleur jazz classique (sixte et septième majeures)."
      ]
    ),
    new(
      slug: 'anatole', name: 'Anatole (I-VI-II-V)', short_name: 'Anatole', family: 'Turnarounds',
      chart: '| IΔ VIm7 | IIm7 V7 |',
      summary: "L'anatole (I-VI-II-V) est le turnaround qui relance une grille vers la tonique : en do, Cmaj7 – Am7 – Dm7 – G7.",
      paragraphs: [
        "L'anatole, appelé turnaround en anglais, tourne en boucle autour de la tonique en enchaînant des fondamentales qui descendent par quintes à partir du VI. On le trouve dans les deux premières mesures des « rhythm changes » (I Got Rhythm) et à la fin de très nombreuses grilles.",
        "Le VIm7 est souvent remplacé par un VI7 (A7 en do), dominante secondaire qui renforce l'attraction vers le II. On rencontre aussi des substitutions tritoniques (I – ♭III7 – II – ♭II7).",
        "C'est un excellent exercice pour travailler les enchaînements II-V dans toutes les tonalités."
      ]
    ),
    new(
      slug: 'blues', name: 'Grille de blues 12 mesures', short_name: 'Blues 12 mesures', family: 'Blues',
      chart: '| I7 | IV7 | I7 | % | IV7 | % | I7 | % | V7 | IV7 | I7 | V7 |',
      summary: "La grille de blues tient en 12 mesures et trois accords de septième de dominante : en do, C7, F7 et G7.",
      paragraphs: [
        "Le blues utilise des accords de septième de dominante sur les degrés I, IV et V, même sur la tonique : c'est cette couleur « bluesy » qui le distingue. La grille de base dure 12 mesures et se répète en boucle.",
        "En jazz, la grille est souvent enrichie : IV7 en 2e mesure, II-V vers le IV en 4e mesure, ♯IV diminué en 6e mesure, puis II-V en mesures 9-10 et anatole dans les deux dernières mesures.",
        "Pour improviser, la gamme blues (et la pentatonique mineure) de la tonique fonctionne sur toute la grille ; le mode mixolydien de chaque accord permet de mieux souligner les changements."
      ]
    ),
    new(
      slug: 'i-v-vi-iv', name: 'Progression I-V-VI-IV', short_name: 'I-V-VI-IV', family: 'Pop',
      chart: '| I | V | VIm | IV |',
      summary: "Le I-V-VI-IV est la grille la plus courante de la pop : en do, C – G – Am – F.",
      paragraphs: [
        "Ces quatre accords parfaits de la gamme majeure accompagnent un nombre impressionnant de chansons pop et rock. En la commençant sur le VI (VI-IV-I-V), on obtient une variante à la couleur plus mélancolique.",
        "Toutes les notes de la grille appartiennent à la gamme majeure de la tonalité, qu'on peut utiliser pour improviser ou composer une mélodie, de même que la pentatonique majeure."
      ]
    ),
    new(
      slug: 'cadence-parfaite', name: 'Cadence parfaite (V-I)', short_name: 'Cadence parfaite', family: 'Cadences classiques',
      chart: '| V7 | I | % |',
      summary: "La cadence parfaite enchaîne la dominante et la tonique (en do, G7 – C) : la plus conclusive des cadences.",
      paragraphs: [
        "Une cadence est un enchaînement d'accords qui ponctue une phrase musicale, comme la ponctuation d'un texte. La cadence parfaite, V-I, joue le rôle du point final : elle affirme la tonalité et donne une impression de repos complet.",
        "Sa force vient de la sensible (la tierce de l'accord V, si en do) qui monte d'un demi-ton vers la tonique, et de la septième de l'accord V7 (fa en do) qui descend vers la tierce de l'accord I. La basse, elle, descend d'une quinte (ou monte d'une quarte).",
        "En formation musicale, on parle de cadence parfaite quand les deux accords sont à l'état fondamental et que la mélodie se termine sur la tonique ; avec un accord renversé, la cadence est dite imparfaite. En jazz, la cadence parfaite est le plus souvent précédée de l'accord du 2e degré : c'est le II-V-I."
      ]
    ),
    new(
      slug: 'cadence-plagale', name: 'Cadence plagale (IV-I)', short_name: 'Cadence plagale', family: 'Cadences classiques',
      chart: '| IV | I | % |',
      summary: "La cadence plagale enchaîne le 4e degré et la tonique (en do, F – C) : la cadence de l'« amen ».",
      paragraphs: [
        "La cadence plagale conclut, comme la cadence parfaite, mais sans sensible : l'accord IV et l'accord I ont une note commune (la tonique, do en do), et les autres voix descendent doucement par degrés (la vers sol, fa vers mi).",
        "On l'appelle souvent cadence de l'« amen » parce qu'elle termine de nombreux cantiques. Elle est aussi très présente dans le rock, le gospel et la soul, souvent juste après une cadence parfaite pour prolonger la fin d'un morceau.",
        "Une variante très expressive, la cadence plagale mineure, remplace l'accord IV par un IV mineur (Fm en do) : le la♭ glisse vers le sol, une couleur qu'on retrouve dans beaucoup de ballades."
      ]
    ),
    new(
      slug: 'cadence-rompue', name: 'Cadence rompue (V-VI)', short_name: 'Cadence rompue', family: 'Cadences classiques',
      chart: '| V7 | VIm | % |',
      summary: "La cadence rompue (ou évitée) va de la dominante au 6e degré au lieu de la tonique : en do, G7 – Am.",
      paragraphs: [
        "Après un accord de dominante, l'oreille attend la tonique. La cadence rompue trompe cette attente en résolvant sur l'accord du 6e degré, mineur en majeur (Am en do), qui partage deux notes avec l'accord I (do et mi).",
        "La sensible monte bien vers la tonique, comme dans une cadence parfaite : seule la basse change, en montant d'un ton au lieu de descendre d'une quinte. C'est ce qui donne à la cadence rompue son effet de surprise sans rupture.",
        "Les compositeurs l'utilisent pour retarder la conclusion d'une phrase et la prolonger jusqu'à une vraie cadence parfaite. En jazz, on la rencontre souvent sous la forme II-V-VI, qui relance une grille au lieu de la conclure."
      ]
    ),
    new(
      slug: 'demi-cadence', name: 'Demi-cadence (sur le V)', short_name: 'Demi-cadence', family: 'Cadences classiques',
      chart: '| I | IV | V | % |',
      summary: "La demi-cadence s'arrête sur l'accord du 5e degré (en do, C – F – G) : la phrase reste en suspens.",
      paragraphs: [
        "La demi-cadence (ou cadence suspensive) se termine sur l'accord de dominante, quel que soit l'accord qui le précède (I, IV ou II le plus souvent). L'accord V appelle la tonique : la phrase n'est pas finie.",
        "On la trouve typiquement au milieu d'une période musicale : une première phrase s'arrête sur une demi-cadence (la question), la seconde reprend le même début et conclut par une cadence parfaite (la réponse).",
        "Pour bien l'entendre, comparez-la avec la cadence parfaite : la même mélodie s'arrêtant sur le V puis sur le I donne une impression d'attente puis de repos."
      ]
    ),
    new(
      slug: 'substitution-tritonique', name: 'Substitution tritonique (II-♭II-I)', short_name: 'Substitution tritonique', family: 'Cadences jazz',
      chart: '| IIm7 | ♭II7 | IΔ | % |',
      summary: "La substitution tritonique remplace le V7 par l'accord de septième un triton plus loin : en do, Dm7 – D♭7 – Cmaj7.",
      paragraphs: [
        "G7 et D♭7 ont la même tierce et la même septième, inversées : si et fa pour G7, fa et do♭ (qui sonne si) pour D♭7. Ce triton, qui fait la tension de l'accord de dominante, est donc le même, et les deux accords peuvent résoudre sur Cmaj7.",
        "Ce qui change, c'est la basse : au lieu de sauter de sol à do, elle descend chromatiquement de ré à ré♭ puis à do. C'est un des sons les plus caractéristiques de l'harmonie jazz, utilisé par les accompagnateurs comme par les arrangeurs.",
        "Pour improviser sur le ♭II7, la gamme par tons ou le mode lydien ♭7 (4e mode de la mineure mélodique) conviennent ; le lydien ♭7 de D♭ contient les mêmes notes que la gamme altérée de G."
      ]
    ),
    new(
      slug: 'backdoor', name: 'Backdoor II-V (IVm7-♭VII7-I)', short_name: 'Backdoor II-V', family: 'Cadences jazz',
      chart: '| IVm7 | ♭VII7 | IΔ | % |',
      summary: "Le backdoor II-V arrive sur la tonique « par la porte de derrière » : en do, Fm7 – B♭7 – Cmaj7.",
      paragraphs: [
        "Au lieu du II-V habituel (Dm7 – G7), le backdoor utilise le IVm7 et le ♭VII7, empruntés à la tonalité homonyme mineure (do mineur en do majeur). L'accord de dominante n'a pas de sensible : la résolution est plus douce, un peu nostalgique.",
        "On l'entend dans de nombreux standards, comme « Lady Bird » ou « Misty ». Le la♭ du Fm7 qui descend vers le sol de Cmaj7 en est la note caractéristique.",
        "Fm7 et B♭7 forment eux-mêmes le II-V de mi♭ majeur, une tierce mineure au-dessus de la tonique : on peut donc y transposer tout son vocabulaire de II-V."
      ]
    ),
    new(
      slug: 'rhythm-changes', name: 'Rhythm changes (grille de I Got Rhythm)', short_name: 'Rhythm changes', family: 'Turnarounds',
      chart: '| IΔ VI7 | IIm7 V7 | IΔ VI7 | IIm7 V7 | IΔ I7 | IVΔ ♯IV°7 | IΔ VI7 | IIm7 V7 |' \
        ' IΔ VI7 | IIm7 V7 | IΔ VI7 | IIm7 V7 | IΔ I7 | IVΔ ♯IV°7 | IΔ VI7 | IIm7 V7 |' \
        ' III7 | % | VI7 | % | II7 | % | V7 | % |' \
        ' IΔ VI7 | IIm7 V7 | IΔ VI7 | IIm7 V7 | IΔ I7 | IVΔ ♯IV°7 | IΔ VI7 | IIm7 V7 |',
      summary: "Les rhythm changes, grille de « I Got Rhythm » de Gershwin : 32 mesures AABA d'anatoles et de dominantes.",
      paragraphs: [
        "Après le blues, c'est la grille la plus jouée du jazz : des dizaines de thèmes bebop ont été écrits dessus (« Anthropology », « Oleo », « Moose the Mooche »…). On la joue traditionnellement en si bémol, à un tempo rapide.",
        "Les sections A enchaînent des anatoles (I-VI-II-V, deux accords par mesure), puis passent par le IV et le ♯IV diminué avant de revenir à la tonique. Le pont (B) est une suite de dominantes, deux mesures chacune, qui descendent par quintes jusqu'au V : D7 – G7 – C7 – F7 en si bémol.",
        "Pour la travailler, apprenez d'abord les A en jouant les arpèges des accords, puis le pont en visant les tierces et les septièmes de chaque dominante. Les musiciens remplacent volontiers les VI7 par des VIm7 ou ajoutent des substitutions tritoniques."
      ]
    ),
    new(
      slug: 'blues-mineur', name: 'Grille de blues mineur', short_name: 'Blues mineur', family: 'Blues',
      chart: '| Im7 | % | % | % | IVm7 | % | Im7 | % | ♭VI7 | V7♭9 | Im7 | IIø V7♭9 |',
      summary: "Le blues mineur en 12 mesures, avec des accords mineurs sur les degrés I et IV : en do, Cm7, Fm7, A♭7, G7♭9.",
      paragraphs: [
        "Les quatre premières mesures restent sur l'accord Im7, les mesures 5 et 6 passent sur le IVm7 puis on revient au Im7, comme dans un blues majeur. La différence est dans les mesures 9 et 10 : l'accord ♭VI7 (A♭7 en do mineur) descend d'un demi-ton vers la dominante V7♭9.",
        "La dernière mesure enchaîne un II-V mineur (Dm7♭5 – G7♭9) qui relance la grille. On retrouve cette forme dans « Mr. P.C. » de John Coltrane, « Equinox » ou « Footprints » (avec quelques variantes).",
        "Pour improviser, la gamme blues et la pentatonique mineure de la tonique fonctionnent sur toute la grille ; le mode dorien sur les accords mineurs, et la gamme mineure harmonique sur le V7♭9, permettent de mieux faire entendre les changements d'accords."
      ]
    ),
    new(
      slug: 'blues-jazz', name: 'Grille de blues jazz', short_name: 'Blues jazz', family: 'Blues',
      chart: '| I7 | IV7 | I7 | % | IV7 | ♯IV°7 | I7 | VI7 | IIm7 | V7 | I7 VI7 | IIm7 V7 |',
      summary: "Le blues jazz enrichit la grille de 12 mesures de II-V, d'un diminué de passage et d'un anatole final.",
      paragraphs: [
        "La structure reste celle du blues : I7 pendant quatre mesures, IV7 en mesures 5 et 6, retour au I7. Mais on passe sur le IV7 dès la 2e mesure, l'accord ♯IV°7 de la 6e mesure fait monter la basse chromatiquement vers le I, et le VI7 de la 8e mesure prépare le II-V des mesures 9 et 10.",
        "Les deux dernières mesures forment un anatole (I-VI-II-V) qui relance la grille. On la joue le plus souvent en fa ou en si bémol, sur des thèmes comme « Billie's Bounce », « Now's the Time », « Blue Monk » ou « Straight, No Chaser ».",
        "C'est un excellent exercice de transition entre le blues et le jazz : la gamme blues fonctionne toujours, mais les II-V et le diminué invitent à suivre les accords de plus près, avec leurs arpèges et leurs notes guides (tierces et septièmes)."
      ]
    ),
    new(
      slug: 'cadence-andalouse', name: 'Cadence andalouse (Im-♭VII-♭VI-V)', short_name: 'Cadence andalouse', family: 'Pop',
      chart: '| Im | ♭VII | ♭VI | V |',
      summary: "La cadence andalouse descend de la tonique mineure à la dominante : en la mineur, Am – G – F – E.",
      paragraphs: [
        "La basse descend la moitié haute de la gamme mineure, degré par degré (la, sol, fa, mi en la mineur), jusqu'à un accord de dominante majeur. Cet accord final, qui sonne comme une tonique en mode phrygien, donne au flamenco sa couleur caractéristique.",
        "On la retrouve aussi bien dans la musique de la Renaissance que dans le rock et la variété : « Hit the Road Jack », « Walk Don't Run », « Stray Cat Strut », de nombreux tangos et chansons.",
        "Pour improviser, la gamme mineure naturelle (mode éolien) fonctionne sur les trois premiers accords ; sur l'accord V, le mode phrygien dominant (5e mode de la mineure harmonique) fait entendre sa tierce majeure."
      ]
    )
  ].freeze
end
