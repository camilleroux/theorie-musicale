class Mode < ApplicationRecord
  extend FriendlyId
  include KeyContext

  belongs_to :scale

  has_many :chord_scales
  has_many :chords, :through => :chord_scales, :extend => Chords

  friendly_id :name, :use => :slugged

  delegate :notes, :to => :tones
  delegate :keys, :to => :tones
  delegate :octavized_notes, :to => :tones
  delegate :intervals, :to => :tones
  delegate :step_names, :to => :tones
  delegate :interval_names, :to => :tones

  validates :name, :presence => true
  validates :mode, :presence => true, :numericality => true
  validates :scale, :presence => true


  def to_s
    name
  end

  def title
    if key
      "#{mode_key.name_for_seo} #{name}"
    else
      name
    end
  end

  def information
    super || scale.information
  end

  # Follows searches: "Gamme de ré mineur harmonique", "Mode do dorien", "Gamme pentatonique mineure de la".
  # Shared by the page title, the h1, the breadcrumb and mode cards.
  def heading
    note = mode_key.french_long_name if key
    if !scale.heptatonic?
      note ? "Gamme #{search_name} de #{note}" : "Gamme #{search_name}"
    elsif slug == 'eolien'
      note ? "Gamme de #{note} mineur naturel (mode éolien)" : "Mode éolien (gamme mineure naturelle)"
    elsif main?
      note ? "Gamme de #{note} #{scale.name.downcase.gsub('eure', 'eur')}" : "Gamme #{scale.name.downcase}"
    else
      note ? "Mode #{note} #{name.downcase}" : "Mode #{name.downcase}"
    end
  end

  # "le mode dorien", "la gamme de ré mineur harmonique"; with "de": "du mode dorien", "de la gamme…"
  def heading_with_article(preposition = nil)
    name = heading.sub(/\A\w/, &:downcase)
    feminine = name.start_with?('gamme')
    article = case preposition
              when 'de' then feminine ? 'de la' : 'du'
              when 'à' then feminine ? 'à la' : 'au'
              else feminine ? 'la' : 'le'
              end
    "#{article} #{name}"
  end

  def seo_title
    SeoTitle.fit(heading, key ? [" : notes et piano", " : notes"] : [" : notes, intervalles et piano", " : notes et intervalles", " : intervalles"])
  end

  def seo_description
    position = "#{mode == 1 ? '1er' : "#{mode}e"} mode de la gamme #{scale.name.downcase}"
    extras = scale.heptatonic? ? 'position au piano, harmonisation et accords associés' : 'position au piano'
    if key
      "#{heading} : notes #{keys.map(&:to_s).to_sentence} (#{keys.map(&:french_name).to_sentence}). " \
        "Intervalles : #{step_names.join(' - ')}. #{position.capitalize}, #{extras}."
    else
      name = heading.sub(/\A\w/, &:downcase)
      subject = name.start_with?('gamme') ? "La #{name} est composée" : "Le #{name}, #{position}, est composé"
      "#{subject} des intervalles suivants : #{step_names.join(' - ')}. Notes, #{extras}."
    end
  end

  def search_name
    case scale.slug
    when 'diminuee' then "diminuée (#{name.downcase})"
    when 'ton-ton' then 'par tons'
    else name.downcase
    end
  end

  # Chords to improvise on with this mode, in the mode's key
  def related_chords
    chord_scales.includes(:chord).map { |chord_scale| chord_scale.chord.in_key_of((scale.key || Key.default).shifted(-chord_scale.offset)) }
  end

  ORDINALS = { 1 => '1er' }

  # "Le mode dorien compte 7 notes, par exemple à partir de ré : ré, mi, fa, sol, la, si et do. C'est le 2e mode de la gamme
  # majeure, joué à partir de son 2e degré. On l'utilise pour improviser sur Dm7, Dm6 et Dm9."
  def definition
    notes = keys.map(&:french_name).to_sentence
    sentences = [key ? "#{heading_with_article.upcase_first} compte #{keys.size} notes : #{notes}." :
                       "#{heading_with_article.upcase_first} compte #{keys.size} notes, par exemple à partir de #{mode_key.french_long_name} : #{notes}."]
    unless main?
      ordinal = ORDINALS.fetch(mode) { "#{mode}e" }
      sentences << "C'est le #{ordinal} mode de la gamme #{scale.name.downcase}, joué à partir de son #{ordinal} degré."
    end
    chords = related_chords.map(&:display_symbol).uniq
    sentences << "On l'utilise pour improviser sur #{chords.to_sentence}." if chords.any?
    sentences.join(' ')
  end

  def main?
    mode == 1
  end

  def degree(relative_mode = 1)
    mode_key.quality+RomanNumerals.to_roman(((mode_key.letter_index-Key[scale.notes.first].letter_index-(relative_mode-1))%7)+1)
  end

  def thirds
    thirds = []
    0.upto(keys.size-1).each do |i|
      thirds<<keys[(i*2)%keys.size]
    end
    thirds
  end

  def mode_key
    Key[notes.first]
  end

  # [tonic of the mode (usual spelling), key of its parent scale] for each key, from C: the
  # URL key is the parent scale's, so "fa dorien" is at /tonalite/eb/gammes/majeure/modes/dorien
  def keys_by_tonic
    primaries = Key.primaries
    pairs = primaries.map do |parent|
      tonic = Key[scale.tones.in_mode(mode).in_key_of(parent).notes.first]
      [primaries.find { |key| key.index == tonic.index }, parent]
    end
    pairs.rotate(pairs.index { |tonic, _| tonic.main? })
  end

  def tones
    if self.key
      self.scale.tones.in_mode(self.mode).in_key_of(self.key)
    else
      self.scale.tones.in_mode(self.mode)
    end
  end

  def intervals
    self.tones.from(1).map(&:to_interval)
  end

  def staff_notes
    octavized_notes.map {|n| [n]}
  end

  def self.resolve(symbol)
    in_key = nil
  
    return nil if symbol.nil?
    symbol = symbol.dup
  
    Key.all.each do |k|
      if symbol.starts_with?(k.name)
        in_key = k
        symbol.gsub!(/^#{k.name}/, '').strip!
        break
      end
    end
  
    mode = find_by_name(symbol)
  
    # Perhaps the matched key was really part of the name, try that:
    if mode.nil? && !in_key.nil?
      symbol = in_key.name + symbol
      mode = all.detect {|s| s.name == symbol}
    end
  
    # If still not found, must be invalid:
    return nil if mode.nil?
  
    mode.key = in_key
    mode
  end

  class << self
    alias_method :[], :resolve
  end

end
