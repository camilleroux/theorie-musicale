# Common chord progressions, defined by degrees so they can be rendered in every key
class Progression
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  # A step of the progression: degree (1-7) of the major scale, semitones above the tonic, chord slug
  Step = Data.define(:degree, :semitones, :chord_slug, :roman)

  attr_reader :slug, :name, :short_name, :steps, :bars, :summary, :paragraphs

  def initialize(slug:, name:, short_name:, steps:, summary:, paragraphs:, bars: nil)
    @slug, @name, @short_name, @steps, @summary, @paragraphs, @bars = slug, name, short_name, steps, summary, paragraphs, bars
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

  def seo_title
    SeoTitle.fit(name, [" : accords dans les 12 tonalités", " : accords et tonalités", " : accords"])
  end

  def seo_description
    "#{summary} Accords dans les 12 tonalités, avec liens vers la composition de chaque accord."
  end

  ALL = [
    new(
      slug: 'ii-v-i-majeur', name: 'Progression II-V-I majeur', short_name: 'II-V-I majeur',
      steps: [Step.new(2, 2, 'mineur-7', 'IIm7'), Step.new(5, 7, 'septieme-de-dominante', 'V7'), Step.new(1, 0, 'majeur-7', 'IΔ')],
      summary: "Le II-V-I (ou 2-5-1) est l'enchaînement d'accords le plus utilisé en jazz : en do, Dm7 – G7 – Cmaj7.",
      paragraphs: [
        "Le II-V-I enchaîne l'accord mineur 7 construit sur le 2e degré, l'accord de septième de dominante du 5e degré et l'accord majeur 7 de la tonique. Les fondamentales descendent par quintes, ce qui crée une forte sensation de résolution.",
        "La septième de l'accord II descend d'un demi-ton vers la tierce de l'accord V, tandis que la tierce du II reste en place et devient la septième du V, qui descend à son tour vers la tierce du I. C'est ce mouvement des voix (les « guide tones ») qu'il faut entendre et viser en improvisation.",
        "Pour improviser, on peut jouer le mode dorien sur le II, le mode mixolydien sur le V et le mode ionien (la gamme majeure) sur le I, qui partagent tous les notes de la gamme majeure de la tonalité."
      ]
    ),
    new(
      slug: 'ii-v-i-mineur', name: 'Progression II-V-I mineur', short_name: 'II-V-I mineur',
      steps: [Step.new(2, 2, 'demi-diminue', 'IIø'), Step.new(5, 7, 'septieme-de-dominante', 'V7'), Step.new(1, 0, 'mineur-6', 'Im6')],
      summary: "Le II-V-I mineur résout vers un accord mineur : en do mineur, Dm7b5 – G7 – Cm6.",
      paragraphs: [
        "En mineur, l'accord du 2e degré est demi-diminué (m7♭5) et l'accord du 5e degré reste un accord de septième de dominante, souvent enrichi d'une neuvième mineure (G7♭9). La tonique peut être un accord mineur 6 ou mineur septième majeure.",
        "Ces accords viennent de la gamme mineure harmonique : le demi-diminué est son 2e degré et l'accord de dominante son 5e degré. Le mode mixolydien ♭9 ♭13 (5e mode de la mineure harmonique) ou le mode altéré conviennent bien sur le V.",
        "Sur le I mineur, la gamme mineure mélodique donne la couleur jazz classique (sixte et septième majeures)."
      ]
    ),
    new(
      slug: 'anatole', name: 'Anatole (I-VI-II-V)', short_name: 'Anatole',
      steps: [Step.new(1, 0, 'majeur-7', 'IΔ'), Step.new(6, 9, 'mineur-7', 'VIm7'), Step.new(2, 2, 'mineur-7', 'IIm7'), Step.new(5, 7, 'septieme-de-dominante', 'V7')],
      summary: "L'anatole (I-VI-II-V) est le turnaround qui relance une grille vers la tonique : en do, Cmaj7 – Am7 – Dm7 – G7.",
      paragraphs: [
        "L'anatole, appelé turnaround en anglais, tourne en boucle autour de la tonique en enchaînant des fondamentales qui descendent par quintes à partir du VI. On le trouve dans les deux premières mesures des « rhythm changes » (I Got Rhythm) et à la fin de très nombreuses grilles.",
        "Le VIm7 est souvent remplacé par un VI7 (A7 en do), dominante secondaire qui renforce l'attraction vers le II. On rencontre aussi des substitutions tritoniques (I – ♭III7 – II – ♭II7).",
        "C'est un excellent exercice pour travailler les enchaînements II-V dans toutes les tonalités."
      ]
    ),
    new(
      slug: 'blues', name: 'Grille de blues 12 mesures', short_name: 'Blues 12 mesures',
      steps: [Step.new(1, 0, 'septieme-de-dominante', 'I7'), Step.new(4, 5, 'septieme-de-dominante', 'IV7'), Step.new(5, 7, 'septieme-de-dominante', 'V7')],
      bars: [0, 1, 0, 0, 1, 1, 0, 0, 2, 1, 0, 2],
      summary: "La grille de blues tient en 12 mesures et trois accords de septième de dominante : en do, C7, F7 et G7.",
      paragraphs: [
        "Le blues utilise des accords de septième de dominante sur les degrés I, IV et V, même sur la tonique : c'est cette couleur « bluesy » qui le distingue. La grille de base dure 12 mesures et se répète en boucle.",
        "En jazz, la grille est souvent enrichie : IV7 en 2e mesure, II-V vers le IV en 4e mesure, ♯IV diminué en 6e mesure, puis II-V en mesures 9-10 et anatole dans les deux dernières mesures.",
        "Pour improviser, la gamme blues (et la pentatonique mineure) de la tonique fonctionne sur toute la grille ; le mode mixolydien de chaque accord permet de mieux souligner les changements."
      ]
    ),
    new(
      slug: 'i-v-vi-iv', name: 'Progression I-V-VI-IV', short_name: 'I-V-VI-IV',
      steps: [Step.new(1, 0, 'majeur', 'I'), Step.new(5, 7, 'majeur', 'V'), Step.new(6, 9, 'mineur', 'VIm'), Step.new(4, 5, 'majeur', 'IV')],
      summary: "Le I-V-VI-IV est la grille la plus courante de la pop : en do, C – G – Am – F.",
      paragraphs: [
        "Ces quatre accords parfaits de la gamme majeure accompagnent un nombre impressionnant de chansons pop et rock. En la commençant sur le VI (VI-IV-I-V), on obtient une variante à la couleur plus mélancolique.",
        "Toutes les notes de la grille appartiennent à la gamme majeure de la tonalité, qu'on peut utiliser pour improviser ou composer une mélodie, de même que la pentatonique majeure."
      ]
    )
  ].freeze
end
