# weelyx-site

Page d'accueil provisoire de weelyx.com : une page HTML statique servie par nginx.

- Contenu : `public/index.html`
- Déploiement : Coolify (build pack Dockerfile, port 80), domaines `https://weelyx.com` et `https://www.weelyx.com`
- Test en local : `docker build -t weelyx-site . && docker run --rm -p 8099:80 weelyx-site`
