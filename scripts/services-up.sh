# Remove comment to run MQTT broker
# COMPOSE_PROFILE="--profile mqtt"

if [[ "$1" == "-d" ]]; then
  echo "Starting hanaeco services in detached mode..."
fi

OPENAI_API_KEY= CIPHER_KEY=CHANGE_ME-CYPHER_KEY DB_PASSWORD=CHANGE_ME-DB_PASSWORD docker compose -p haneco_onprem ${COMPOSE_PROFILE} --env-file .env.docker-compose-onprem -f docker-compose-withenvoy.yml up ${1:-}
