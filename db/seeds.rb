### CLEAR EXISTING JAZZ MODEL TABLE ###
%w(
  chord_qualities
  chord_scales
  chord_symbols
  chords
  modes
  scales
).each do |table|
  #ActiveRecord::Base.connection.execute "TRUNCATE TABLE `#{table}`"
  ActiveRecord::Base.connection.execute "DELETE FROM `#{table}`"
end

%w(
  scales
  chords
).each {|f| require Rails.root.join("db/seeds/#{f}.rb") }