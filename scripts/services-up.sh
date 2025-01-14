
if [[ "$1" == "-d" ]]; then
  echo "Starting hanaeco services in detached mode..."
fi

OPENAI_API_KEY= CIPHER_KEY= DB_PASSWORD= docker compose -p haneco_onprem  --env-file .env.docker-compose-onprem -f docker-compose-withenvoy.yml up ${1:-}
