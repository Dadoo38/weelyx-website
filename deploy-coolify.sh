#!/bin/sh
# Crée (une seule fois) l'appli « weelyx-site » dans Coolify et la déploie.
# Le Dockerfile envoyé à Coolify embarque public/index.html : pas besoin de dépôt GitHub.
set -eu
cd "$(dirname "$0")"
SERVER=j1wzuacthlkytuji3rptzafj   # serveur « localhost » de Coolify
API=~/bin/coolify-api

if $API GET /applications | grep -q '"name":"weelyx-site"'; then
  echo "L'appli existe déjà : utiliser le bouton Redeploy de Coolify, ou la supprimer d'abord."; exit 1
fi

PROJECT=$($API GET /projects | python3 -c 'import json,sys; print(next((p["uuid"] for p in json.load(sys.stdin) if p["name"]=="weelyx"), ""))')
[ -n "$PROJECT" ] || PROJECT=$($API POST /projects '{"name":"weelyx","description":"Site et applis weelyx.com"}' | python3 -c 'import json,sys; print(json.load(sys.stdin)["uuid"])')
echo "Projet : $PROJECT"

HTML=$(base64 -w0 public/index.html)
DOCKERFILE=$(printf 'FROM nginx:1.27-alpine\nRUN echo %s | base64 -d > /usr/share/nginx/html/index.html\nEXPOSE 80\n' "$HTML" | base64 -w0)

$API POST /applications/dockerfile "$(python3 -c 'import json,sys; print(json.dumps({
  "project_uuid": sys.argv[1], "server_uuid": sys.argv[2], "environment_name": "production",
  "name": "weelyx-site", "dockerfile": sys.argv[3], "ports_exposes": "80",
  "domains": "https://weelyx.com,https://www.weelyx.com", "instant_deploy": True}))' "$PROJECT" "$SERVER" "$DOCKERFILE")"
