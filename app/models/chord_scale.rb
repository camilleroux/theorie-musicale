class ChordScale < ApplicationRecord
  belongs_to :chord
  belongs_to :mode

  delegate :scale, :to => :mode
  delegate :key, :to => :chord
end
