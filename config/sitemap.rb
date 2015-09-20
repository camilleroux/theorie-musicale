# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://theoriemusicale.camilleroux.com"

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
    add page, changefreq: 'monthly', :priority => 0.7
  end

  Key.all.uniq{ |key| key.name }.each do |key|
    add note_path(key), :priority => 0.75
  end

  Interval.all.each do |interval|
    add interval_path(interval), :priority => 0.75
    Key.primaries.each do |key|
      add key_interval_path(key,interval)
    end
  end

  Chord.find_each do |chord|
    add chord_path(chord), :priority => 0.75
    Key.primaries.each do |key|
      add key_chord_path(key,chord)
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
