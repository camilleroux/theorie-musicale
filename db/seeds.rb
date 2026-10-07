# Atomic: the site never sees empty tables while reseeding
ActiveRecord::Base.transaction do
  ### CLEAR EXISTING JAZZ MODEL TABLE ###
  %w(
    chord_qualities
    chord_scales
    chord_symbols
    chords
    modes
    scales
  ).each do |table|
    # No foreign keys: DELETE works on SQLite (dev/test) and MySQL (production)
    ActiveRecord::Base.connection.execute "DELETE FROM #{table}"
  end

  %w(
    scales
    chords
  ).each { |f| load Rails.root.join("db/seeds/#{f}.rb") }
end
