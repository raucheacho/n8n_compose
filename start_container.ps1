# Variables
$N8N_PORT = 5678
$NGROK_PORT = 5678
$DOCKER_COMPOSE_FILE = "docker-compose.yml"

# Étape 1 : Lancer ngrok
Write-Host "Lancement de ngrok sur le port $NGROK_PORT..."
Start-Process -NoNewWindow -FilePath "ngrok" -ArgumentList "http $NGROK_PORT"

# Attendre quelques secondes que ngrok démarre
Start-Sleep -Seconds 5

# Étape 2 : Récupérer l'URL publique générée par ngrok
Write-Host "Récupération de l'URL publique générée par ngrok..."
try {
    $NGROK_API_RESPONSE = Invoke-RestMethod -Uri "http://127.0.0.1:4040/api/tunnels" -Method Get
    $NGROK_URL = $NGROK_API_RESPONSE.tunnels[0].public_url
} catch {
    Write-Host "Erreur : Impossible de récupérer l'URL de ngrok. Assurez-vous que ngrok fonctionne correctement."
    exit 1
}

if (-not $NGROK_URL) {
    Write-Host "Erreur : Aucune URL publique trouvée."
    exit 1
}

Write-Host "URL publique récupérée : $NGROK_URL"

# Étape 3 : Mettre à jour docker-compose.yml avec la nouvelle URL
Write-Host "Mise à jour de $DOCKER_COMPOSE_FILE avec la nouvelle URL ngrok..."
(Get-Content $DOCKER_COMPOSE_FILE) -replace 'WEBHOOK_URL=.*', "WEBHOOK_URL=$NGROK_URL" | Set-Content $DOCKER_COMPOSE_FILE

# Étape 4 : Relancer Docker Compose
Write-Host "Redémarrage du container Docker..."
docker compose up -d

Write-Host "Configuration terminée. n8n est maintenant accessible via : $NGROK_URL"
