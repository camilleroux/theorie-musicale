class Chord < ApplicationRecord
  extend FriendlyId
  include KeyContext
  include Toneable
  
  acts_as_tree
  friendly_id :name_for_url, :use => :slugged
  
  belongs_to :chord_quality

  has_many :symbols, :class_name => 'ChordSymbol'
  has_one :primary_symbol, -> { where(:primary => true) }, :class_name => 'ChordSymbol'

  has_many :chord_scales
  has_many :modes, :through => :chord_scales
  has_many :voicings
  has_many :voice_leadings_to, :through => :voicings
  has_many :voice_leadings_from, :through => :voicings

  validates :name, :presence => true
  validates :chord_quality, :presence => true


  def to_s
    name
  end

  def name_for_url
    name.gsub('♯','diese').gsub('♭','bemol')
  end

  def short_name
    "#{key}#{primary_symbol}"
  end

  def title(forseo=false)
    if key
      "Accord #{forseo ? key.name_for_seo : key} #{name}"
    else
      "Accord #{name}"
    end
  end

  # Symbols as typed in search engines (ASCII, e.g. "Am7", "Fmaj7"), by chord slug
  SEARCH_SYMBOLS = {
    'majeur' => '', 'majeur-7' => 'maj7', 'majeur-6' => '6',
    'mineur' => 'm', 'mineur-7' => 'm7', 'mineur-6' => 'm6',
    'mineur-bemol6' => 'mb6', 'mineur-septieme-majeure' => 'mMaj7',
    'septieme-de-dominante' => '7', '7-diese5' => '7#5', '7-bemol5' => '7b5', '7-sus-4' => '7sus4',
    'triade-diminuee' => 'dim', 'demi-diminue' => 'm7b5', 'septieme-diminuee' => 'dim7',
    'triade-augmentee' => 'aug', 'augmente-septieme-majeure' => 'maj7#5',
    'add-9' => 'add9', 'majeur-9' => 'maj9', 'majeur-6-9' => '6/9', 'mineur-9' => 'm9',
    'neuvieme' => '9', '7-bemol9' => '7b9', '7-diese9' => '7#9', 'treizieme' => '13',
    'sus-2' => 'sus2', 'sus-4' => 'sus4'
  }

  # Symbol with ♯/♭ for display, e.g. "C♯m7", "B♭m7♭5"; the search symbol stays ASCII for titles
  def display_symbol
    "#{key}#{display_suffix}"
  end

  def display_suffix
    SEARCH_SYMBOLS.fetch(slug) { primary_symbol.to_s }.gsub(/b(?=\d)/, '♭').tr('#', '♯')
  end

  def search_symbol
    suffix = SEARCH_SYMBOLS.fetch(slug) { primary_symbol.to_s }
    key ? "#{key.name.tr('♯♭', '#b')}#{suffix}" : suffix
  end

  # "la mineur 7", or "mineur 7" without key
  def full_name
    key ? "#{key.french_long_name} #{name.downcase}" : name.downcase
  end

  # The page without a key is the C page (C is the main key, /tonalite/c/... canonicalizes to it):
  # it must answer "Cmaj7" and "do majeur 7" searches as well as the generic "accord majeur 7"
  def in_c
    key ? self : clone.in_key_of(Key.default)
  end

  # "Accord Am7 (la mineur 7)" with a key, "Accord majeur 7 (Cmaj7, do majeur 7)" without:
  # ASCII symbol for page titles, ♯/♭ symbol on the page
  def heading(display: false)
    c = in_c
    symbol = display ? c.display_symbol : c.search_symbol
    key ? "Accord #{symbol} (#{full_name})" : "Accord #{name.downcase} (#{symbol}, #{c.full_name})"
  end

  # Chord pages in a key show the title and description they had until 2026-10-07: with
  # "Accord Am7 (la mineur 7) : notes, guitare et piano", their click-through rate fell
  # by a third at the same position (GSC review of 2026-11-14)
  def legacy_snippet?
    key.present?
  end

  def seo_title
    return title(true) if legacy_snippet?

    suffixes = guitar? ? [" : notes, guitare et piano", " : guitare et piano", " : guitare"] : [" : notes et piano", " : notes"]
    SeoTitle.fit(heading, suffixes)
  end

  def seo_description
    if legacy_snippet?
      return "L'accord #{title} (#{main_symbol_name}) est composé des intervalles suivants : " \
        "#{tones.from(1).map(&:to_interval).map(&:long_name).to_sentence}"
    end

    intervals_sentence = intervals.map { |i| i.long_name.downcase }.to_sentence
    c = in_c
    notes = "notes #{c.keys.map(&:to_s).to_sentence} (#{c.keys.map(&:french_name).to_sentence})"
    if key
      "Accord #{search_symbol} (#{full_name}) : #{notes}. " \
        "Intervalles : #{intervals_sentence}. #{guitar? ? 'Diagrammes guitare, position' : 'Position'} au piano, gammes et modes associés."
    else
      "Accord #{name.downcase} : en do, #{c.search_symbol} (#{c.full_name}), #{notes}. Intervalles : #{intervals_sentence}. " \
        "#{guitar? ? 'Diagrammes guitare, position' : 'Position'} au piano et accord dans les 12 tonalités."
    end
  end

  NOTE_COUNTS = { 3 => 'trois notes (c\'est une triade)', 4 => 'quatre notes (c\'est une tétrade)', 5 => 'cinq notes', 6 => 'six notes' }

  # "L'accord Am7 (la mineur 7) compte quatre notes (c'est une tétrade) : la, do, mi et sol, soit la fondamentale,
  # une tierce mineure, une quinte juste et une septième mineure." Key-less pages define the chord, then give it in C.
  def definition
    c = in_c
    count = NOTE_COUNTS.fetch(c.keys.size) { "#{c.keys.size} notes" }
    structure = (['la fondamentale'] + intervals.map { |i| "une #{i.long_name.downcase}" }).to_sentence
    notes = c.keys.map(&:french_name).to_sentence
    if key
      "L'accord #{c.display_symbol} (#{full_name}) compte #{count} : #{notes}, soit #{structure}."
    else
      "L'accord #{name.downcase} compte #{count} : #{structure}. En do, #{c.display_symbol} se compose de #{notes}."
    end
  end

  # "Tétrade (4 notes)"
  def kind
    { 3 => 'Triade (3 notes)', 4 => 'Tétrade (4 notes)' }.fetch(keys.size) { "Accord de #{keys.size} notes" }
  end

  # Modes to improvise on the chord, built on its root
  def related_modes
    root = key || Key.default
    chord_scales.includes(mode: :scale).map { |chord_scale| chord_scale.mode.in_key_of(root.shifted(chord_scale.offset)) }
  end

  TENSION_NAMES = { 1 => '♭9', 2 => '9', 3 => '♯9', 5 => '11', 6 => '♯11', 8 => '♭13', 9 => '13' }.freeze
  Tensions = Data.define(:mode, :available, :avoid)

  # Notes of a related mode that are not in the chord: tensions, or "avoid notes" when a half step above a chord tone
  # (the 11 on a major chord), except the ♭9 and ♭13 of a dominant chord. Only for seventh and sixth chords, with the first
  # related mode built on the root that gives a tension (related modes are listed from the most common).
  def tensions
    return if keys.size < 4

    root = keys.first
    chord_steps = keys.map { |k| (k.index - root.index) % 12 }
    candidates = related_modes.select { |mode| mode.keys.first.index == root.index }.map do |mode|
      extra = mode.keys.map { |k| [(k.index - root.index) % 12, k] }.reject { |step, _| chord_steps.include?(step) }.select { |step, _| TENSION_NAMES.key?(step) }
      dominant = chord_steps.include?(4) && chord_steps.include?(10)
      avoid, available = extra.partition { |step, _| chord_steps.include?((step - 1) % 12) && !(dominant && [1, 8].include?(step)) }
      Tensions.new(mode, available.map { |step, k| [TENSION_NAMES[step], k] }, avoid.map { |step, k| [TENSION_NAMES[step], k] })
    end
    candidates.find { |t| t.available.any? }
  end

  def role
    ChordRole.for(self)
  end

  def guitar?
    GuitarVoicing.for(self).any?
  end

  def symbol_names
    symbols.map {|s| key.to_s + s.name }
  end
  def main_symbol_name
    symbol_names.first
  end
  def other_symbol_names
    symbol_names[1..-1] || []
  end

  def intervals
    self.tones.from(1).map(&:to_interval)
  end

  def self.find_by_keys(keys)
    key = keys.first
    Chord.all.each do |chord|
      chord_in_key = chord.in_key_of(key)
      return chord_in_key if chord_in_key.keys == keys
    end
    return nil
  end
  # Resolves a chord symbol into a chord.
  # Implementation is somewhat flakey due to the potential ambiguities arising 
  # from specifying key and symbols together.
  def self.resolve(symbol)
    in_key = nil
  
    return nil if symbol.nil?
    symbol = symbol.dup
  
    symbol.gsub!(/ Accord/i, "")
  
    Key.all.each do |k|
      if symbol.starts_with?(k.name)
        in_key = k
        symbol.sub!(k.name, '').strip
        break
      end
    end
  
    chord_symbol = ChordSymbol[symbol]
  
    # Perhaps the matched key was really part of the name of the chord, try that:
    if chord_symbol.nil? && !in_key.nil?
      symbol = in_key.name + symbol
      chord_symbol = ChordSymbol[symbol]
    end
  
    # If still not found, must be invalid:
    return nil if chord_symbol.nil?
  
    chord = chord_symbol.chord
    chord.key = in_key unless in_key.nil?
    chord
  end

  class << self
    alias_method :[], :resolve
  end

  def to_json(options = {})
    super({:methods => [:notes]}.merge(options))
  end
end
