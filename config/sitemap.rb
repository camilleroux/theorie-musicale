# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://theoriemusicale.camilleroux.com"
# pick a place safe to write the files
SitemapGenerator::Sitemap.public_path = 'tmp/'
# store on S3 using Fog (pass in configuration values as shown above if needed)
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(fog_provider: 'AWS',
    aws_access_key_id: "#{ENV['AWS_ACCESS_KEY_ID']}",
    aws_secret_access_key: "#{ENV['AWS_SECRET_ACCESS_KEY']}",
    fog_directory: "#{ENV['FOG_DIRECTORY']}",
    fog_region: "#{ENV['FOG_REGION']}")
# inform the map cross-linking where to find the other maps
SitemapGenerator::Sitemap.sitemaps_host = "http://#{ENV['FOG_DIRECTORY']}.s3.amazonaws.com/"
# pick a namespace within your bucket to organize your maps
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

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

  Key.all.uniq{ |key| key.name }.reject(&:double_altered?).each do |key|
    add note_path(key), :priority => 0.75
  end

  Interval.all.each do |interval|
    add interval_path(interval), :priority => 0.75
    Key.primaries.each do |key|
      add key_interval_path(key,interval)
    end
  end

  guitar_images = ->(chord, path_for) do
    GuitarVoicing.for(chord).each_index.map { |i| { loc: SitemapGenerator::Sitemap.default_host + path_for.(i + 1) } }
  end

  Chord.find_each do |chord|
    add chord_path(chord), :priority => 0.75, :images => guitar_images.(chord, ->(position) { guitar_chord_path(chord, position: position, format: :svg) })
    # C pages are canonicalized to the key-less chord page
    Key.primaries.reject(&:main?).each do |key|
      add key_chord_path(key,chord), :images => guitar_images.(chord.in_key_of(key), ->(position) { guitar_key_chord_path(key, chord, position: position, format: :svg) })
    end
  end

  Scale.includes(:modes).find_each do |scale|
    add scale_path(scale), :priority => 0.75
    scale.modes.find_each do |mode|
      add scale_mode_path(scale,mode), :priority => 0.70
      Key.primaries.each do |key|
        add key_scale_mode_path(key,scale,mode)
      end
    end
  end
end
