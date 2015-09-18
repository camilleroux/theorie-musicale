Scale.create!(:name => 'Majeure', :specify_tones => "1 2 3 4 5 6 7", :information => "La gamme majeure est utilisée partout comme référence, pour le chiffrage des degrés par exemple.").tap do |s|
  s.modes.create!(:mode => 1, :name => 'Ionien')
  s.modes.create!(:mode => 2, :name => 'Dorien')
  s.modes.create!(:mode => 3, :name => 'Phrygien')
  s.modes.create!(:mode => 4, :name => 'Lydien')
  s.modes.create!(:mode => 5, :name => 'Mixolydien')
  s.modes.create!(:mode => 6, :name => 'Éolien')
  s.modes.create!(:mode => 7, :name => 'Locrien')
end

Scale.create!(:name => 'Mineure mélodique', :specify_tones => "1 2 3m 4 5 6 7", :information => "La gamme mineure mélodique est similaire à la gamme majeure avec une seule différente, elle a une tierce mineure au lieu d'une tierce majeure.").tap do |s|
  s.modes.create!(:mode => 1, :name => 'Mineure mélodique')
  s.modes.create!(:mode => 2, :name => 'Dorien ♭9', :synonyms => 'Phrygien ♯13')
  s.modes.create!(:mode => 3, :name => 'Lydien augmenté')
  s.modes.create!(:mode => 4, :name => 'Lydien ♭7', :synonyms => 'Mixolydien ♯11')
  s.modes.create!(:mode => 5, :name => 'Mixolydien ♭13')
  s.modes.create!(:mode => 6, :name => 'Locrien ♮9', :synonyms => 'Éolien ♭5')
  s.modes.create!(:mode => 7, :name => 'Altéré', :synonyms => 'Super Locrien')
end

Scale.create!(:name => 'Mineure harmonique', :specify_tones => "1 2 3m 4 5 6m 7", :information => "La gamme mineure harmonique est principalement utilisée dans la musique classique mais beaucoup de musiciens l'utilisent dans le jazz en alternance avec les autres gammes mineures.").tap do |s|
  s.modes.create!(:mode => 1, :name => 'Mineure harmonique')
  s.modes.create!(:mode => 2, :name => 'Locrien ♮13')
  s.modes.create!(:mode => 3, :name => 'Ionien ♯5')
  s.modes.create!(:mode => 4, :name => 'Dorien ♯11')
  s.modes.create!(:mode => 5, :name => 'Mixolydien (♭9,♭13)', :synonyms => 'Phrygien ♮3')
  s.modes.create!(:mode => 6, :name => 'Lydien ♯9')
  s.modes.create!(:mode => 7, :name => 'Superlocrien ♭♭7')
end

Scale.create!(:name => 'Ton-Ton', :specify_tones => "1 2 3 4aug 5aug 7m", :symmetry_index => 2, :information => "La gamme par tons est une échelle hexatonique dont les six degrés sont tous espacés d'un ton. Elle fonctionne bien avec les accords ♯5.").tap do |s|
  s.modes.create!(:mode => 1, :name => 'Ton-Ton')
end

Scale.create!(:name => 'Pentatonique', :specify_tones => "1 2 3 5 6", :information => "La gamme pentatonique est une des fondation de la gamme bebop majeure et est significativement utilisée dans le jazz. La gamme pentatonique correspond aux touches noires du piano.").tap do |s|
  s.modes.create!(:mode => 1, :name => 'Pentatonique majeure')
  s.modes.create!(:mode => 5, :name => 'Pentatonique mineure')
end

Scale.create!(:name => 'Blues', :specify_tones => "1 2 3m 3 5 6", :information => "L'utilisation de la gamme blues est assez répandue dans le jazz").tap do |s|
  s.modes.create!(:mode => 1, :name => 'Blues majeure')
  s.modes.create!(:mode => 6, :name => 'Blues mineure')
end

Scale.create!(:name => 'Diminuée', :specify_tones => "1 2m 3m 3 4aug 5 6 7m", :symmetry_index => 3, :information => "La gamme diminuée alterne tons et demi-tons afin de produire une gamme symétrique avec des spécificités intéressantes.").tap do |s|
  s.modes.create!(:mode => 1, :name => 'Demi-ton, Ton')
  s.modes.create!(:mode => 2, :name => 'Ton, Demi-ton')
end

Scale.create!(:name => 'Bebop', :specify_tones => "1 2 3 4 5 6 7m 7", :information => "La gamme bebop ajoute une septième majeure de passage à la gamme majeure. En résulte une gamme de 8 notes qui s'accorde bien avec les rythmes binaires.").tap do |s|
  s.modes.create!(:mode => 1, :name => 'Bebop dominante')
  s.modes.create!(:mode => 2, :name => 'Bebop majeur')
end


