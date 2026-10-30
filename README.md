# weelyx-website

Page d'accueil provisoire de weelyx.com : une page HTML statique servie par nginx.

- Contenu : `public/index.html`
- Déploiement : Coolify (projet weelyx, appli `weelyx-website`, build pack Dockerfile, port 80), domaines `https://weelyx.com` et `https://www.weelyx.com`. **Chaque push sur `main` redéploie le site automatiquement** (webhook GitHub → Coolify).
- Test en local : `docker build -t weelyx-site . && docker run --rm -p 8099:80 weelyx-site`
