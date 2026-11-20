# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://theoriemusicale.camilleroux.com"
# Generated at image build time (Dockerfile), served at /sitemap.xml by SitemapsController
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
# Uncompressed so it can be served as /sitemap.xml; Cloudflare compresses it on the wire
SitemapGenerator::Sitemap.compress = false

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
  HighVoltage.page_ids.each do |page|
    add page_path(page), changefreq: 'monthly', :priority => 0.7
  end

  add progressions_path, :priority => 0.75
  add circle_of_fifths_path, :priority => 0.8, :changefreq => 'monthly'
  add ear_training_path, :priority => 0.8, :changefreq => 'monthly'
  Key.primaries.each { |key| add key_path(key), :priority => 0.8, :changefreq => 'monthly' }
  Progression.all.each { |progression| add progression_path(progression), :priority => 0.75 }

  piano_image = ->(path) { [{ loc: SitemapGenerator::Sitemap.default_host + path }] }

  Key.all.uniq{ |key| key.name }.reject(&:double_altered?).each do |key|
    add note_path(key), :priority => 0.75, :images => piano_image.(piano_note_path(key, format: :svg))
  end

  Interval.all.each do |interval|
    add interval_path(interval), :priority => 0.75, :images => piano_image.(piano_interval_path(interval, format: :svg))
    Key.primaries.each do |key|
      add key_interval_path(key,interval), :images => piano_image.(piano_key_interval_path(key, interval, format: :svg))
    end
  end

  chord_images = ->(chord, piano_path, guitar_path_for) do
    paths = [piano_path] + GuitarVoicing.for(chord).each_index.map { |i| guitar_path_for.(i + 1) }
    paths.map { |path| { loc: SitemapGenerator::Sitemap.default_host + path } }
  end

  Chord.find_each do |chord|
    add chord_path(chord), :priority => 0.75, :images => chord_images.(chord, piano_chord_path(chord, format: :svg),
      ->(position) { guitar_chord_path(chord, position: position, format: :svg) })
    # C pages are canonicalized to the key-less chord page
    Key.primaries.reject(&:main?).each do |key|
      add key_chord_path(key,chord), :images => chord_images.(chord.in_key_of(key), piano_key_chord_path(key, chord, format: :svg),
        ->(position) { guitar_key_chord_path(key, chord, position: position, format: :svg) })
    end
  end

  Scale.includes(:modes).find_each do |scale|
    add scale_path(scale), :priority => 0.75
    scale.modes.find_each do |mode|
      add scale_mode_path(scale,mode), :priority => 0.70, :images => piano_image.(piano_scale_mode_path(scale, mode, format: :svg))
      # C pages are canonicalized to the key-less mode page
      Key.primaries.reject(&:main?).each do |key|
        add key_scale_mode_path(key,scale,mode), :images => piano_image.(piano_key_scale_mode_path(key, scale, mode, format: :svg))
      end
    end
  end
end
