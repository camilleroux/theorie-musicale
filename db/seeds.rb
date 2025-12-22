### CLEAR EXISTING JAZZ MODEL TABLE ###
%w(
  chord_qualities
  chord_scales
  chord_symbols
  chords
  modes
  scales
).each do |table|
  if Rails.env.production?
    # PostgreSQL supports TRUNCATE with CASCADE
    ActiveRecord::Base.connection.execute "TRUNCATE TABLE #{table} CASCADE"
  else
    # SQLite (dev/test) doesn't support TRUNCATE
    ActiveRecord::Base.connection.execute "DELETE FROM #{table}"
  end
end

%w(
  scales
  chords
).each { |f| require Rails.root.join("db/seeds/#{f}.rb") }
