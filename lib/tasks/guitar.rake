require 'open-uri'

namespace :guitar do
  CHORDS_DB_URL = 'https://raw.githubusercontent.com/tombatossals/chords-db/master/lib/guitar.json'
  # chords-db keys, indexed by pitch class (C = 0)
  CHORDS_DB_KEYS = %w[C Csharp D Eb E F Fsharp G Ab A Bb B]
  POSITIONS_PER_CHORD = 3

  desc "Import guitar voicings from chords-db (MIT) into db/data/guitar_voicings.json"
  task import: :environment do
    source = JSON.parse(URI.open(CHORDS_DB_URL).read)
    data = {}

    Chord.find_each do |chord|
      suffix = GuitarVoicing::CHORDS_DB_SUFFIXES[chord.slug] or next

      data[chord.slug] = (0..11).to_h do |index|
        chord_in_key = chord.in_key_of(Key.primaries.find { |k| k.index == index })
        pitches = chord_in_key.keys.map { |k| k.index % 12 }
        entry = source['chords'][CHORDS_DB_KEYS[index]].find { |c| c['suffix'] == suffix }
        positions = entry['positions'].select { |p| plays_chord?(p, pitches) }.first(POSITIONS_PER_CHORD)
        [index.to_s, positions.map { |p| p.slice('frets', 'fingers', 'baseFret', 'barres', 'capo') }]
      end
    end

    File.write(GuitarVoicing::DATA_PATH, JSON.pretty_generate(data) + "\n")
    puts "#{data.size} chords, #{data.values.sum { |keys| keys.values.sum(&:size) }} voicings"
  end

  # Only notes of the chord, all of them except the usual omissions: a perfect fifth in 4+ notes chords,
  # and the ninth in 13th chords
  def plays_chord?(position, pitches)
    played = position['midi'].map { |m| m % 12 }.uniq
    required = pitches
    required -= [pitches[2]] if pitches.size >= 4 && (pitches[2] - pitches[0]) % 12 == 7
    required -= [pitches[4]] if pitches.size >= 6
    (played - pitches).empty? && (required - played).empty?
  end
end
