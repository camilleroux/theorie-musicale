module ResourcesHelper
  AMAZON = 'http://www.amazon.fr/gp/product/%s/ref=as_li_tl?ie=UTF8&camp=1642&creative=19458&creativeASIN=%s&linkCode=as2&tag=theoriemusicale-21'
  BLOG = 'https://www.camilleroux.com'

  # rel: affiliate links are "sponsored", other external sites "nofollow", the author's blog is followed
  RESOURCE_SECTIONS = [
    ['Livres', [
      { title: 'La partition intérieure', tag: 'Jacques Siron', rel: 'sponsored noopener', url: format(AMAZON, '2907891030', '2907891030'),
        text: "Le livre de référence sur la théorie musicale pour le jazz et les musiques improvisées. Une vraie bible de 768 pages, utile au débutant comme à l'improvisateur aguerri, à l'enseignant ou au simple curieux." },
      { title: 'Théorie de la musique', tag: 'Adolphe Danhauser', rel: 'sponsored noopener', url: format(AMAZON, 'B00006RJNJ', 'B00006RJNJ'),
        text: "L'un des piliers de la pédagogie musicale, très centré sur la notation : un peu le Bescherelle de la musique." }
    ]],
    ['Sites web', [
      { title: 'musictheory.net', tag: 'En anglais', rel: 'nofollow noopener', url: 'http://www.musictheory.net/',
        text: "Des cours animés très bien faits, de la notation (clés, durées, silences, altérations) aux gammes, intervalles, accords et progressions. Les exercices permettent de s'entraîner à reconnaître notes, intervalles, accords et gammes sur une partition, un clavier, un manche de guitare ou à l'oreille." },
      { title: 'Jazzity', tag: 'En anglais', rel: 'nofollow noopener', url: 'https://github.com/rubiety/jazzity',
        text: "Le projet dont le code a servi de base à ce site : accords, gammes, modes et progressions d'accords." }
    ]],
    ['Guitare', [
      { title: "Comment j'ai appris la guitare électrique en 6 mois", tag: 'Mon blog', url: "#{BLOG}/comment-jai-appris-la-guitare-electrique-en-6-mois/",
        text: "Mon retour d'expérience sur l'apprentissage de la guitare électrique : méthode, outils, progression et erreurs à éviter." },
      { title: 'Guitare::Improvisation', tag: 'Site', rel: 'nofollow noopener', url: 'http://www.guitare-improvisation.com/',
        text: "Un très bon site francophone pour apprendre à improviser à la guitare, avec des explications claires, bien illustrées et accompagnées d'exemples, et des vidéos à petit prix centrées sur un style ou un morceau." }
    ]],
    ['Production musicale', [
      { title: "S'initier à la production musicale et publier un morceau en moins d'un an", tag: 'Mon blog',
        url: "#{BLOG}/se-former-a-la-production-de-musique-electronique-et-publier-un-morceau-en-moins-dun-an/",
        text: "Mon parcours pour apprendre à composer et produire de la musique électronique, de la découverte du logiciel à la publication d'un premier morceau." },
      { title: 'Ressources pour se former à la production de musique électronique', tag: 'Mon blog',
        url: "#{BLOG}/ressources-pour-se-former-a-la-production-de-musique-electronique/",
        text: "Une sélection de cours, de livres, de chaînes et d'outils pour se lancer dans la production musicale." },
      { title: 'Mes morceaux', tag: 'Ma musique', url: 'https://music.camilleroux.com/albums/',
        text: "Les singles que j'ai composés et produits depuis mes débuts en production musicale." }
    ]]
  ].freeze
end
