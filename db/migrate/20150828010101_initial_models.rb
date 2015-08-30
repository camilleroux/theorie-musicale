class InitialModels < ActiveRecord::Migration
  def change
    create_table :chord_qualities do |t|
      t.string :name
      t.string :code
      t.string :slug
    end

    add_index :chord_qualities, :slug

    create_table :chords do |t|
      t.references :chord_quality
      t.integer :parent_id
      t.string :name
      t.text :synonyms
      t.text :information
      t.string :tone_values, :limit => 4000
      t.integer :chord_tones_count, :default => 0
      t.string :slug
      t.timestamps
    end

    add_index :chords, :slug
    add_index :chords, :chord_quality_id
    add_index :chords, :parent_id
    
    create_table :chord_symbols do |t|
      t.references :chord
      t.string :name
      t.boolean :case_sensitive, :default => false
      t.integer :strength
      t.boolean :primary, :default => false
      t.timestamps
    end

    add_index :chord_symbols, :chord_id
    add_index :chord_symbols, :name
    
    create_table :scales do |t|
      t.string :name
      t.string :information
      t.integer :symmetry_index
      t.string :tone_values, :limit => 4000
      t.integer :tones_count, :default => 0
      t.string :slug
      t.timestamps
    end

    add_index :scales, :slug

    create_table :modes do |t|
      t.references :scale
      t.integer :mode
      t.string :name
      t.text :synonyms
      t.integer :dissonance
      t.text :information
      t.string :slug
      t.timestamps
    end

    add_index :modes, :slug
    add_index :modes, :scale_id
    add_index :modes, :mode
    
    create_table :chord_scales do |t|
      t.references :chord
      t.references :mode
      t.integer :offset, :default => 0, :null => false
      t.integer :strength, :default => 1
      t.text :information
      t.timestamps
    end

    add_index :chord_scales, :chord_id
    add_index :chord_scales, :mode_id
  end
end
