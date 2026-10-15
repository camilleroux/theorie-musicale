# Links between the blues scales and the blues grids in the same key, which
# visitors searching for "blues en fa" expect to find together
module BluesHelper
  GRIDS = {'blues-majeure' => %w[blues blues-jazz], 'blues-mineure' => %w[blues blues-jazz blues-mineur]}
  SCALES = {'blues' => %w[blues-mineure blues-majeure], 'blues-jazz' => %w[blues-mineure blues-majeure], 'blues-mineur' => %w[blues-mineure]}
  # Semitones from a blues mode's root down to its scale's key: the minor blues is the 6th mode of the major one
  MODE_OFFSETS = {'blues-majeure' => 0, 'blues-mineure' => 3}

  # The blues grids on the root of a blues mode, as [name, path]
  def blues_grid_links(mode)
    tonic = Key.primaries.find { |key| key.index == mode.keys.first.index }
    GRIDS.fetch(mode.slug, []).map do |slug|
      progression = Progression.find(slug)
      ["#{progression.name} en #{tonic.french_long_name}", progression_path(progression, tonalite: (tonic.to_param unless tonic.main?))]
    end
  end

  # The blues scales to improvise on a blues grid in a key, as [name, path]
  def blues_scale_links(progression, tonic)
    scale = Scale.friendly.find('blues')
    SCALES.fetch(progression.slug, []).map do |slug|
      key = tonic.shifted(MODE_OFFSETS.fetch(slug))
      mode = scale.modes.friendly.find(slug)
      path = key.main? ? polymorphic_path([scale, mode]) : polymorphic_path([key, scale.in_key_of(key), mode.in_key_of(key)])
      [mode.in_key_of(key).heading, path]
    end
  end
end
