[ ![Codeship Status for camilleroux/theorie-musicale](https://app.codeship.com/projects/1ad2aca0-60fe-0136-2465-62259406e2c1/status?branch=master)](https://app.codeship.com/projects/296461)

## Théorie Musicale

Application web pour explorer la théorie musicale (notamment pour le jazz et les musiques improvisées). Accessible sur https://theoriemusicale.camilleroux.com.

Les données sur les [accords](db/seeds/chords.rb) et les [gammes/modes](db/seeds/scales.rb) sont dans [db/seeds](db/seeds).

### Setup

```
$ rake db:migrate
$ rake db:seeds
$ bin/rails server
$ open http://localhost:3000
```

### Déploiement

```
$ bin/deploy
```

Pousse sur GitHub, déploie avec [Kamal](https://kamal-deploy.org/) sur le serveur partagé avec feedcast et bskyfollow, puis régénère le sitemap. Le build de l'image Docker construit aussi la base SQLite depuis `db/seeds` : modifier les seeds puis déployer suffit, il n'y a pas de base à migrer en prod. Cloudflare garde les pages 1 h (`s-maxage=3600`) : un déploiement est visible partout dans l'heure. Pour vider le cache immédiatement, ajouter `CLOUDFLARE_API_TOKEN` (permission *Zone > Cache Purge*) et `CLOUDFLARE_ZONE_ID` dans `.env`.

Les secrets sont lus dans `.env` (ignoré par git, voir `.kamal/secrets`) : `KAMAL_REGISTRY_PASSWORD`, `SECRET_KEY_BASE`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `FOG_DIRECTORY`, `FOG_REGION`.

### TODO
- [ ] Tests
- [ ] Complete chords list
- [ ] Complete modes list
- [ ] Complete scales list
- [x] Add chord progressions
- [ ] I18n
