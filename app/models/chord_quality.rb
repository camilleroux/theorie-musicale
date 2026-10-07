class ChordQuality < ApplicationRecord
  extend FriendlyId

  has_many :chords

  friendly_id :name, :use => :slugged

  # Plural heading of the family, e.g. "Accords mineurs"
  def heading
    { 'MAJ' => 'Accords majeurs', 'MIN' => 'Accords mineurs', 'DOM' => 'Accords de septième de dominante',
      'SUS' => 'Accords suspendus' }.fetch(code) { "Accords #{name.downcase}s" }
  end

  validates :name, :presence => true
  validates :code, :presence => true

  def to_s
    name
  end

  def self.resolve(name)
    find_by_name(name)
  end

  class << self
    alias_method :[], :resolve
  end

end
