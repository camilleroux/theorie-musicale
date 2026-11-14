# Jazz standards whose melody opens with a given interval, to learn to recognize intervals by ear.
# Cross-checked against jazzadvice.com ("Master your intervals in 28 days") and Jeff Newton's interval
# mnemonics (Portland State University): only tunes listed for the same interval and direction, plus
# a few well-known openings (Moon River, Maria, Somewhere).
class IntervalSong
  Song = Data.define(:title, :composer)

  # Interval symbol => { up: [...], down: [...] }
  SONGS = {
    '2m' => { up: [['I Remember You', 'Victor Schertzinger']],
              down: [['Stella by Starlight', 'Victor Young'], ['The Lady Is a Tramp', 'Richard Rodgers']] },
    '2M' => { up: [['Body and Soul', 'Johnny Green'], ['My Funny Valentine', 'Richard Rodgers']],
              down: [['Freddie Freeloader', 'Miles Davis']] },
    '3m' => { up: [['Confirmation', 'Charlie Parker'], ['Work Song', 'Nat Adderley'], ['Georgia on My Mind', 'Hoagy Carmichael']],
              down: [['What Is This Thing Called Love?', 'Cole Porter'], ['Misty', 'Erroll Garner']] },
    '3M' => { up: [['When the Saints Go Marching In', 'traditionnel'], ["I Can't Get Started", 'Vernon Duke']],
              down: [['Summertime', 'George Gershwin'], ['Giant Steps', 'John Coltrane'], ["Bessie's Blues", 'John Coltrane']] },
    '4J' => { up: [['All the Things You Are', 'Jerome Kern'], ["'Round Midnight", 'Thelonious Monk'], ['Maiden Voyage', 'Herbie Hancock'], ['Song for My Father', 'Horace Silver']],
              down: [['Yardbird Suite', 'Charlie Parker'], ['Softly, as in a Morning Sunrise', 'Sigmund Romberg']] },
    '4aug' => { up: [['Maria', 'Leonard Bernstein']],
                down: [['Blue Seven', 'Sonny Rollins']] },
    '5J' => { up: [["Bags' Groove", 'Milt Jackson'], ['Whisper Not', 'Benny Golson'], ['Moon River', 'Henry Mancini']],
              down: [['Have You Met Miss Jones?', 'Richard Rodgers'], ['Seven Steps to Heaven', 'Victor Feldman et Miles Davis']] },
    '6m' => { up: [['Manhã de Carnaval', 'Luiz Bonfá']],
              down: [["Please Don't Talk About Me When I'm Gone", 'Sam H. Stept']] },
    '6M' => { up: [['Take the "A" Train', 'Billy Strayhorn'], ['Days of Wine and Roses', 'Henry Mancini'], ['Speak Low', 'Kurt Weill']],
              down: [["You're a Weaver of Dreams", 'Victor Young'], ['Moonlight Becomes You', 'Jimmy Van Heusen']] },
    '7m' => { up: [['Somewhere', 'Leonard Bernstein']],
              down: [['Watermelon Man', 'Herbie Hancock']] },
    '7M' => { up: [['Ceora', 'Lee Morgan'], ['Cast Your Fate to the Wind', 'Vince Guaraldi']],
              down: [['I Love You', 'Cole Porter']] },
    '8J' => { up: [['Over the Rainbow', 'Harold Arlen']],
              down: [['Willow Weep for Me', 'Ann Ronell']] }
  }.freeze

  # The tritone has one sound and two names
  ALIASES = { '5dim' => '4aug' }.freeze

  def self.symbols
    SONGS.keys
  end

  # { up: [Song…], down: [Song…] }, nil for intervals without reference songs
  def self.for(interval)
    songs = SONGS[ALIASES.fetch(interval.symbol, interval.symbol)] or return
    songs.transform_values { |list| list.map { |title, composer| Song.new(title, composer) } }
  end
end
