#!/bin/bash

# Variables
N8N_PORT=5678
NGROK_PORT=5678
DOCKER_COMPOSE_FILE="docker-compose.yml"

# Étape 1 : Lancer ngrok
echo "Lancement de ngrok sur le port $NGROK_PORT..."
ngrok http $NGROK_PORT > /dev/null 2>&1 &

# Attendre quelques secondes que ngrok démarre
sleep 5

# Étape 2 : Récupérer l'URL publique générée par ngrok
echo "Récupération de l'URL publique générée par ngrok..."
NGROK_URL=$(curl --silent --show-error http://127.0.0.1:4040/api/tunnels | jq -r '.tunnels[0].public_url')

if [ -z "$NGROK_URL" ]; then
  echo "Erreur : Impossible de récupérer l'URL de ngrok. Assurez-vous que ngrok fonctionne correctement."
  exit 1
fi

echo "URL publique récupérée : $NGROK_URL"

# Étape 3 : Mettre à jour docker-compose.yml avec la nouvelle URL
echo "Mise à jour de $DOCKER_COMPOSE_FILE avec la nouvelle URL ngrok..."
#sur linux
#sed -i "s|WEBHOOK_URL=.*|WEBHOOK_URL=$NGROK_URL|" $DOCKER_COMPOSE_FILE
#sur mac
sed -i '' "s|WEBHOOK_URL=.*|WEBHOOK_URL=$NGROK_URL|" $DOCKER_COMPOSE_FILE
# Étape 4 : Relancer Docker Compose
echo "Redémarrage du container Docker..."
docker compose up -d

echo "Configuration terminée. n8n est maintenant accessible via : $NGROK_URL"
