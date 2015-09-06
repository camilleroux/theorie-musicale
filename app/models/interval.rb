class Interval
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include Comparable
  include KeyContext
  include Toneable

  attr_reader :degree, :quality
  attr_accessor :tone_values

  DegreeNames = {1 => 'Prime', 2 => 'Seconde', 3 => 'Tierce', 4 => 'Quarte', 5 => 'Quinte', 6 => 'Sixte', 7 => 'Septième', 8 => 'Octave', 9 => 'Neuvième', 10 => 'Dixième', 11 => 'Onzième', 12 => 'Douzième', 13 => 'Treizième', 14 => 'Quatorzième', 15 => "Double octave"}
  DegreeSemitones  = {1 => 0, 2 => 2, 3 => 4, 4 => 5, 5 => 7, 6 => 9, 7 => 11, 8 => 12, 9 => 14, 10 => 16, 11 => 17, 12 => 19, 13 => 21, 14 => 23, 15 => 24}
  QualityNames = {:dim => 'diminuée', :m => 'mineure', :J => "juste", :M => 'majeure', :aug => "augmentée"}

  def initialize(degree, quality=nil, tones_specified=false)
    @degree = degree
    @quality = quality.blank? ? default_quality : quality
    self.specify_tones="1 #{self.symbol}" if tones_specified
  end

  def self.new_from_symbol(symbol, tones_specified=false)
    symbol = symbol.split(/\W/).first
    degree_string, quality_string = symbol.scan(/^(\d+)([a-zA-Z]*)$/).first
    Interval.new(degree_string.to_i, quality_string.try(:to_sym), tones_specified)
  end

  def default_quality
    self.class.degree_can_be_perfect?(@degree) ? :J : :M
  end

  def inversion
    qualities = QualityNames.keys

    self.class.new(9 - @degree, qualities[qualities.size-(qualities.index(@quality)+1)])
  end

  def compound?
    self.semitones >= 12
  end

  def semitones
    degree_semitones = DegreeSemitones[@degree]
    if [:M,:J].include?(@quality)
      degree_semitones
    elsif @quality == :m
      degree_semitones - 1
    elsif @quality == :aug
      degree_semitones + 1
    elsif @quality == :dim
      degree_semitones - (self.class.degree_can_be_perfect?(@degree) ? 1 : 2)
    end
  end

  def long_name
    DegreeNames[@degree] + " " + QualityNames[@quality]
  end

  def long_name_with_key
    name = long_name
    name += " de #{notes.first} : #{notes.last}" if @key
    name
  end

  def symbol
    @degree.to_s + @quality.to_s
  end

  def name_for_url
    symbol + '-' + Rack::Utils.escape(long_name)
  end


  def to_i
    self.semitones
  end

  def letter_index
    @degree - 1
  end

  def <=> obj
    comparison = self.semitones <=> obj.semitones

    if comparison == 0
      return self.degree <=> obj.degree
    else
      return comparison
    end
  end

  def self.degree_can_be_perfect?(degree)
    [1, 4, 5].include?(degree%7)
  end

  def self.available_qualities_for_degree(degree)
    if degree==1
      [:J, :aug]
    elsif degree==15
      [:dim, :J]
    elsif self.degree_can_be_perfect?(degree)
      [:dim, :J, :aug]
    else
      [:dim, :m, :M, :aug]
    end
  end

  def self.all
    intervals = []
    (1..15).each do |degree|
      self.available_qualities_for_degree(degree).each do |quality|
        intervals << Interval.new(degree, quality)
      end
    end
    intervals
  end

end