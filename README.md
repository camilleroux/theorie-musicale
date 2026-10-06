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

Pousse sur GitHub et Heroku et régénère le sitemap. Cloudflare garde les pages 1 h (`s-maxage=3600`) : un déploiement est visible partout dans l'heure. Pour vider le cache immédiatement, ajouter `CLOUDFLARE_API_TOKEN` (permission *Zone > Cache Purge*) et `CLOUDFLARE_ZONE_ID` dans la config Heroku.

### TODO
- [ ] Tests
- [ ] Complete chords list
- [ ] Complete modes list
- [ ] Complete scales list
- [ ] Add chord progressions
- [ ] I18n
