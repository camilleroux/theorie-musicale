module ApplicationHelper
  AUTHOR_ID = 'https://www.camilleroux.com/#person'
  AUTHOR_PHOTO_URL = 'https://www.camilleroux.com/content/images/size/w256h256/format/jpeg/2025/05/camillecouleur---lowres-2.jpg'

  # French typography: non-breaking spaces before ; : ! ? » and after «, so they never start a line
  def typo_fr(text)
    text.to_s.gsub(/ ([;:!?»])/, "\u00A0\\1").gsub(/« /, "«\u00A0")
  end

  # JSON-LD describing the site and its author (E-E-A-T, link with camilleroux.com)
  def structured_data
    {
      '@context' => 'https://schema.org',
      '@graph' => [
        {
          '@type' => 'WebSite', '@id' => "#{root_url}#website", 'name' => 'Théorie musicale', 'url' => root_url,
          'inLanguage' => 'fr-FR', 'author' => { '@id' => AUTHOR_ID }, 'publisher' => { '@id' => AUTHOR_ID }
        },
        {
          '@type' => 'Person', '@id' => AUTHOR_ID, 'name' => 'Camille Roux', 'url' => 'https://www.camilleroux.com/',
          'image' => AUTHOR_PHOTO_URL, 'jobTitle' => 'Entrepreneur et développeur, co-fondateur de Human Coders',
          'knowsAbout' => ['Théorie musicale', 'Jazz', 'Guitare', 'Développement web'],
          'sameAs' => [
            'https://music.camilleroux.com/', 'https://art.camilleroux.com/', 'https://x.com/CamilleRoux',
            'https://bsky.app/profile/camilleroux.com', 'https://mastodon.social/@camilleroux',
            'https://www.linkedin.com/in/camilleroux', 'https://github.com/camilleroux'
          ]
        }
      ]
    }
  end
end
