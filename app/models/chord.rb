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
