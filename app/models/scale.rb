class Scale < ApplicationRecord
  extend FriendlyId
  include KeyContext
  include ModeContext
  include Toneable
  
  has_many :modes, :dependent => :destroy

  friendly_id :name, :use => :slugged

  delegate :chords, :to => :main_mode

  validates :name, :presence => true

  def to_s
    name
  end

  def title
    if key
      "Gamme #{name} de #{key.name_for_seo}"
    else
      "Gamme #{name}"
    end
  end

  def staff_notes
    octavized_notes.map {|n| [n]}
  end

  def intervals
    self.tones.from(1).map(&:to_interval)
  end

  def heptatonic?
    notes.size == 7
  end

  def self.resolve(symbol)
    in_key = nil
  
    return nil if symbol.nil?
    symbol = symbol.dup

    symbol.gsub!(/ Gamme/i, "")
  
    Key.all.each do |k|
      if symbol.starts_with?(k.name)
        in_key = k
        symbol.gsub!(/^#{k.name}/, '').strip!
        break
      end
    end
  
    scale = find_by_name(symbol)
  
    # Perhaps the matched key was really part of the name, try that:
    if scale.nil? && !in_key.nil?
      symbol = in_key.name + symbol
      scale = all.detect {|s| s.name == symbol}
    end
  
    # If still not found, must be invalid:
    return nil if scale.nil?
  
    scale.key = in_key
    scale
  end

  class << self
    alias_method :[], :resolve
  end

  def main_mode
    modes.find_by_mode(1)
  end

  def symmetric?
    !self.symmetry_index.nil?
  end

  def to_json
    super(:methods => [:notes])
  end

end
