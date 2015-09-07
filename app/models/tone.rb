class Tone
  attr_accessor :tone
  attr_accessor :letter_index
  attr_accessor :position

  def initialize(attributes = {})
    attributes.each do |k, v|
      self.send("#{k}=", v)
    end
  end

  def as_json(options = {})
    {:tone => tone, :letter_index => letter_index, :position => position}
  end

  def to_interval
    degree = letter_index + 1
    Interval.available_qualities_for_degree(degree).each do |quality|
      i = Interval.new(degree, quality)
      return i if i.semitones == tone
    end
  end
end
