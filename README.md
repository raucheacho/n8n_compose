# Script de mise à jour automatique de ngrok pour n8n

Ce script permet de lancer **ngrok** sur le port où n8n est accessible (5678), de récupérer l'URL publique générée par ngrok, de mettre à jour le fichier `docker-compose.yml` avec cette URL, puis de relancer les services Docker via `docker-compose`.

---

## Prérequis

Avant d'utiliser ce script, assure-toi d'avoir les éléments suivants installés et configurés sur ton système :

1. **Docker Desktop** ou **Docker Engine** installé.
2. **ngrok** installé sur ton système.
   - Tu peux télécharger ngrok ici : [https://ngrok.com/download](https://ngrok.com/download).
3. **jq** installé pour analyser les données JSON récupérées par l'API de ngrok.
   - Sur macOS/Linux :
     ```bash
     brew install jq  # macOS
     sudo apt install jq  # Linux
     ```
   - Pour Windows, tu peux utiliser [jq pour Windows](https://stedolan.github.io/jq/download/).

---

## Fonctionnement

### 1. Lancer ngrok

Le script démarre **ngrok** pour exposer ton service **n8n** accessible localement sur le port **5678**.

### 2. Récupérer l'URL publique de ngrok

Une fois ngrok démarré, l'URL publique générée par ngrok est récupérée automatiquement via l'API locale de ngrok (`http://127.0.0.1:4040/api/tunnels`).

### 3. Mettre à jour le fichier `docker-compose.yml`

Le script remplace automatiquement la valeur de la variable `WEBHOOK_URL` dans ton fichier `docker-compose.yml` avec l'URL publique générée par ngrok.

### 4. Relancer les services Docker

Après avoir mis à jour le fichier `docker-compose.yml`, le script redémarre les containers Docker via `docker compose up -d` pour appliquer la nouvelle configuration.

---

## Installation

### 1. Télécharger le script

Télécharge le script `start_container.sh` dans ton répertoire de projet.

### 2. Rendre le script exécutable

Avant de pouvoir exécuter le script, assure-toi qu'il est exécutable en lançant la commande suivante :

```bash
chmod +x start_container.sh
```

---

## Utilisation

### 1. Lancer le script

Une fois que le script est téléchargé et rendu exécutable, tu peux le lancer avec la commande suivante :

```bash
./start_container.sh
```

Le script effectuera les étapes suivantes :

- Lancer ngrok sur le port 5678.
- Récupérer l'URL publique générée par ngrok.
- Mettre à jour automatiquement ton fichier `docker-compose.yml`.
- Redémarrer ton service n8n via `docker-compose`.

### 2. Vérifier l'URL

Une fois le script exécuté, l'URL publique générée par ngrok sera affichée dans ton terminal, et tu pourras y accéder à partir de n'importe quel navigateur.

Exemple de sortie :

```bash
Lancement de ngrok sur le port 5678...
Récupération de l'URL publique générée par ngrok...
URL publique récupérée : https://abcd1234.ngrok.io
Mise à jour de docker-compose.yml avec la nouvelle URL ngrok...
Redémarrage du container Docker...
Configuration terminée. n8n est maintenant accessible via : https://abcd1234.ngrok.io
```

---

## Exemple de configuration dans `docker-compose.yml`

Ton fichier `docker-compose.yml` devrait inclure une section avec la variable `WEBHOOK_URL` que le script mettra à jour. Exemple :

```yaml
services:
  n8n:
    image: docker.n8n.io/n8nio/n8n:latest
    container_name: n8n_server
    ports:
      - "5678:5678"
    environment:
      - WEBHOOK_URL=https://ec56-196-115-223-46.ngrok-free.app # Cette URL sera mise à jour par le script
      - TZ=Africa/Casablanca
      - N8N_RELEASE_TYPE=stable
    volumes:
      - ./n8n_data:/home/node/.n8n
```

---

## Résolution des problèmes

- **ngrok ne démarre pas correctement** : Assure-toi que ngrok est installé et fonctionne correctement. Tu peux tester ngrok manuellement avec la commande :

  ```bash
  ngrok http 5678
  ```

  Si ngrok fonctionne correctement, tu devrais voir une URL publique générée dans ton terminal.

- **Problème avec `sed`** : Si tu utilises macOS, assure-toi d'avoir la bonne syntaxe pour `sed` :
  ```bash
  sed -i '' "s|WEBHOOK_URL=.*|WEBHOOK_URL=$NGROK_URL|" docker-compose.yml
  ```

---

## Remarque

- Ce script est conçu pour fonctionner localement et ne nécessite pas de configurations réseau supplémentaires.
- Le script récupère l'URL de ngrok en utilisant l'API locale de ngrok, assure-toi que ngrok est bien en fonctionnement avant de lancer le script.

---

Voilà, tu as maintenant un script pour automatiser la mise à jour de l'URL de webhook de n8n à chaque redémarrage de ngrok. ❤️😊❤️
