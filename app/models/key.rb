class Key
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_reader :name, :long_name, :index, :letter_index, :cycle_index, :primary
  attr_accessor :octave

  Steps = {'1/2' => 1, '1' => 2, '1,5' => 3, '3M' => 4, '4' => 5, '4aug' => 6, '5' => 7}

  FrenchNames = {'C' => 'do', 'D' => 'ré', 'E' => 'mi', 'F' => 'fa', 'G' => 'sol', 'A' => 'la', 'B' => 'si'}

  Intervals = {
    'u' => 0, 'unison' => 0, '0' => 0,
    '♭2' => 1, '♭9' => 1, 'min2' => 1, 'S' => 1, 'H' => 1, 'm2' => 1,
    '2' => 2, '9' => 2, 'maj2' => 2, 'T' => 2, 'W' => 2, 'M2' => 2,
    '♭3' => 3, 'min3' => 3, '♯2' => 3, '♯9' => 3, 'm3' => 3,
    '3' => 4, 'maj3' => 4, 'M3' => 4,
    'p4' =>  5, '4' => 5,
    '♭5' => 6, 'aug4' => 6, 'dim5' => 6, '♯4' => 6,
    'p5' =>  7, '5' => 7,
    '♭6' => 8, 'aug5' => 8, '♯5' => 8,
    'M6' =>  9, 'maj6' => 9, '6' => 9,
    'm7' => 10, 'min7' => 10, 'dom7' => 10, '♭7' => 10,
    'maj7' => 11, 'M7' => 11, '7' => 11,
    '8' => 12, 'octave' => 12 
  }

  def initialize(attributes = {})
    @primary = true
    @octave = 4

    attributes.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def self.all
    [
      Key.new(:name => 'C', :long_name => 'C', :index => 0, :letter_index => 0, :cycle_index => 0),
      Key.new(:name => 'B♯', :long_name => 'B dièse', :index => 0, :letter_index => 6, :cycle_index => 0, :primary => false),
      Key.new(:name => 'D♭♭', :long_name => 'D double-bémol', :index => 0, :letter_index => 1, :cycle_index => 0, :primary => false),

      Key.new(:name => 'F', :long_name => 'F', :index => 5, :letter_index => 3, :cycle_index => 1),
      Key.new(:name => 'E♯', :long_name => 'E dièse', :index => 5, :letter_index => 2, :cycle_index => 1, :primary => false),
      Key.new(:name => 'G♭♭', :long_name => 'G double-bémol', :index => 5, :letter_index => 4, :cycle_index => 1, :primary => false),

      Key.new(:name => 'B♭', :long_name => 'B bémol', :index => 10, :letter_index => 6, :cycle_index => 2),
      Key.new(:name => 'A♯', :long_name => 'A dièse', :index => 10, :letter_index => 5, :cycle_index => 2, :primary => false),
      Key.new(:name => 'C♭♭', :long_name => 'C double-bémol', :index => 10, :letter_index => 0, :cycle_index => 2, :primary => false),

      Key.new(:name => 'E♭', :long_name => 'E bémol', :index => 3, :letter_index => 2, :cycle_index => 3),
      Key.new(:name => 'D♯', :long_name => 'D dièse', :index => 3, :letter_index => 1, :cycle_index => 3, :primary => false),
      Key.new(:name => 'F♭♭', :long_name => 'F double-bémol', :index => 3, :letter_index => 3, :cycle_index => 3, :primary => false),

      Key.new(:name => 'A♭', :long_name => 'A bémol', :index => 8, :letter_index => 5, :cycle_index => 4),
      Key.new(:name => 'G♯', :long_name => 'G dièse', :index => 8, :letter_index => 4, :cycle_index => 4, :primary => false),

      Key.new(:name => 'D♭', :long_name => 'D bémol', :index => 1, :letter_index => 1, :cycle_index => 5),
      Key.new(:name => 'C♯', :long_name => 'C dièse', :index => 1, :letter_index => 0, :cycle_index => 5, :primary => false),
      Key.new(:name => 'B♯♯', :long_name => 'B double-dièse', :index => 1, :letter_index => 6, :cycle_index => 5, :primary => false),

      Key.new(:name => 'G♭', :long_name => 'G bémol', :index => 6, :letter_index => 4, :cycle_index => 6),
      Key.new(:name => 'F♯', :long_name => 'F dièse', :index => 6, :letter_index => 3, :cycle_index => 6, :primary => false),
      Key.new(:name => 'E♯♯', :long_name => 'E double-dièse', :index => 6, :letter_index => 2, :cycle_index => 6, :primary => false),

      Key.new(:name => 'B', :long_name => 'B', :index => 11, :letter_index => 6, :cycle_index => 7),
      Key.new(:name => 'C♭', :long_name => 'C bémol', :index => 11, :letter_index => 0, :cycle_index => 7, :primary => false),
      Key.new(:name => 'A♯♯', :long_name => 'A double-dièse', :index => 11, :letter_index => 5, :cycle_index => 7, :primary => false),

      Key.new(:name => 'E', :long_name => 'E', :index => 4, :letter_index => 2, :cycle_index => 8),
      Key.new(:name => 'F♭', :long_name => 'F bémol', :index => 4, :letter_index => 3, :cycle_index => 8, :primary => false),
      Key.new(:name => 'D♯♯', :long_name => 'D double-dièse', :index => 4, :letter_index => 1, :cycle_index => 8, :primary => false),

      Key.new(:name => 'A', :long_name => 'A', :index => 9, :letter_index => 5, :cycle_index => 9),
      Key.new(:name => 'B♭♭', :long_name => 'B double-bémol', :index => 9, :letter_index => 6, :cycle_index => 9, :primary => false),
      Key.new(:name => 'G♯♯', :long_name => 'G double-dièse', :index => 9, :letter_index => 4, :cycle_index => 9, :primary => false),

      Key.new(:name => 'D', :long_name => 'D', :index => 2, :letter_index => 1, :cycle_index => 10),
      Key.new(:name => 'C♯♯', :long_name => 'C double-dièse', :index => 2, :letter_index => 0, :cycle_index => 10, :primary => false),
      Key.new(:name => 'E♭♭', :long_name => 'E double-bémol', :index => 2, :letter_index => 2, :cycle_index => 10, :primary => false),

      Key.new(:name => 'G', :long_name => 'G', :index => 7, :letter_index => 4, :cycle_index => 11),
      Key.new(:name => 'F♯♯', :long_name => 'F double-dièse', :index => 7, :letter_index => 3, :cycle_index => 11, :primary => false),
      Key.new(:name => 'A♭♭', :long_name => 'A double-bémol', :index => 7, :letter_index => 5, :cycle_index => 11, :primary => false)
    ]
  end

  def self.all_without_doubles
    [
      Key.new(:name => 'C', :long_name => 'C', :index => 0, :letter_index => 0, :cycle_index => 0),
      Key.new(:name => 'B♯', :long_name => 'B dièse', :index => 0, :letter_index => 6, :cycle_index => 0, :primary => false),
      Key.new(:name => 'C', :long_name => 'C', :index => 0, :letter_index => 1, :cycle_index => 0, :primary => false),

      Key.new(:name => 'F', :long_name => 'F', :index => 5, :letter_index => 3, :cycle_index => 1),
      Key.new(:name => 'E♯', :long_name => 'E dièse', :index => 5, :letter_index => 2, :cycle_index => 1, :primary => false),
      Key.new(:name => 'F', :long_name => 'F', :index => 5, :letter_index => 4, :cycle_index => 1, :primary => false),

      Key.new(:name => 'B♭', :long_name => 'B bémol', :index => 10, :letter_index => 6, :cycle_index => 2),
      Key.new(:name => 'A♯', :long_name => 'A dièse', :index => 10, :letter_index => 5, :cycle_index => 2, :primary => false),
      Key.new(:name => 'B♭', :long_name => 'B bémol', :index => 10, :letter_index => 0, :cycle_index => 2, :primary => false),

      Key.new(:name => 'E♭', :long_name => 'E bémol', :index => 3, :letter_index => 2, :cycle_index => 3),
      Key.new(:name => 'D♯', :long_name => 'D dièse', :index => 3, :letter_index => 1, :cycle_index => 3, :primary => false),
      Key.new(:name => 'E♭', :long_name => 'E bémol', :index => 3, :letter_index => 3, :cycle_index => 3, :primary => false),

      Key.new(:name => 'A♭', :long_name => 'A bémol', :index => 8, :letter_index => 5, :cycle_index => 4),
      Key.new(:name => 'G♯', :long_name => 'G dièse', :index => 8, :letter_index => 4, :cycle_index => 4, :primary => false),

      Key.new(:name => 'D♭', :long_name => 'D bémol', :index => 1, :letter_index => 1, :cycle_index => 5),
      Key.new(:name => 'C♯', :long_name => 'C dièse', :index => 1, :letter_index => 0, :cycle_index => 5, :primary => false),
      Key.new(:name => 'C♯', :long_name => 'C dièse', :index => 1, :letter_index => 6, :cycle_index => 5, :primary => false),

      Key.new(:name => 'G♭', :long_name => 'G bémol', :index => 6, :letter_index => 4, :cycle_index => 6),
      Key.new(:name => 'F♯', :long_name => 'F dièse', :index => 6, :letter_index => 3, :cycle_index => 6, :primary => false),
      Key.new(:name => 'F♯', :long_name => 'F dièse', :index => 6, :letter_index => 2, :cycle_index => 6, :primary => false),

      Key.new(:name => 'B', :long_name => 'B', :index => 11, :letter_index => 6, :cycle_index => 7),
      Key.new(:name => 'C♭', :long_name => 'C bémol', :index => 11, :letter_index => 0, :cycle_index => 7, :primary => false),
      Key.new(:name => 'B', :long_name => 'B', :index => 11, :letter_index => 5, :cycle_index => 7, :primary => false),

      Key.new(:name => 'E', :long_name => 'E', :index => 4, :letter_index => 2, :cycle_index => 8),
      Key.new(:name => 'F♭', :long_name => 'F bémol', :index => 4, :letter_index => 3, :cycle_index => 8, :primary => false),
      Key.new(:name => 'E', :long_name => 'E', :index => 4, :letter_index => 1, :cycle_index => 8, :primary => false),

      Key.new(:name => 'A', :long_name => 'A', :index => 9, :letter_index => 5, :cycle_index => 9),
      Key.new(:name => 'A', :long_name => 'A', :index => 9, :letter_index => 6, :cycle_index => 9, :primary => false),
      Key.new(:name => 'A', :long_name => 'A', :index => 9, :letter_index => 4, :cycle_index => 9, :primary => false),

      Key.new(:name => 'D', :long_name => 'D', :index => 2, :letter_index => 1, :cycle_index => 10),
      Key.new(:name => 'D', :long_name => 'D', :index => 2, :letter_index => 0, :cycle_index => 10, :primary => false),
      Key.new(:name => 'D', :long_name => 'D', :index => 2, :letter_index => 2, :cycle_index => 10, :primary => false),

      Key.new(:name => 'G', :long_name => 'G', :index => 7, :letter_index => 4, :cycle_index => 11),
      Key.new(:name => 'G', :long_name => 'G', :index => 7, :letter_index => 3, :cycle_index => 11, :primary => false),
      Key.new(:name => 'G', :long_name => 'G', :index => 7, :letter_index => 5, :cycle_index => 11, :primary => false)
    ]
  end

  def french_name
    french_name = self.name
    FrenchNames.each do |english, french|
      french_name = french_name.gsub(english,french)
    end
    french_name
  end

  def french_long_name
    french_name = self.long_name
    FrenchNames.each do |english, french|
      french_name = french_name.gsub(english,french)
    end
    french_name
  end

  def name_for_seo
    "#{name.gsub('♯','#').gsub('♭','b')} (#{french_long_name})"
  end

  def quality
    name[1..-1]
  end

  def altered?
    !name[1..-1].blank?
  end

  def self.primaries
    all_without_doubles.select(&:primary)
  end

  def self.from_index(value, preferred_letter = nil)
    relative_value = value % 12
    preferred_letter %= 7 unless preferred_letter.nil?
    key = all.find {|k| k.index == relative_value && (preferred_letter.nil? || k.letter_index == preferred_letter)}
    key = all_without_doubles.find {|k| k.index == relative_value && (k.letter_index == preferred_letter - 1 || k.letter_index == preferred_letter + 1)} unless key #find key with enharmony
    key.octave+=value/12
    key.octave-=1 if value/12 > 0 && relative_value == 0 && key.letter_index == 6 # don't add an octave to B#
    key
  end

  def self.from_name(value)
    all.find {|k| k.name == value.gsub('d','♯').gsub('b','♭')}
  end

  def self.[](value)
    if value.is_a? Numeric
      self.from_index(value)
    else
      value[0] = value[0].upcase
      self.from_name(value)
    end
  end

  def self.default
    self['C']
  end

  def ==(other)
    name == other.name
  end

  def to_s
    name
  end

  def to_vexflow_notation
    name.gsub('♯','#').gsub('♭','b')+'/'+octave.to_s
  end

  def to_param
    name.gsub('♯','d').gsub('♭','b').downcase
  end

  def main?
    name == "C"
  end
  
  def shifted(offset)
    self.class.primaries.find {|k| ((index + offset) % 12) == k.index }
  end

  def enharmonic_with?(another_key)
    self.index == another_key.index && self.octave == another_key.octave
  end

  def as_json(options = nil)
    {
      :id => name,
      :name => name,
      :long_name => long_name,
      :index => index,
      :letter_index => letter_index,
      :cycle_index => cycle_index,
      :primary => primary
    }
  end
end
