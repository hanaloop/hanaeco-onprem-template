docker compose -p haneco_onprem  --env-file .env.docker-compose-onprem -f docker-compose-withenvoy.yml down

# env $(cat ".env.docker-compose-onprem.wocomment") docker-compose  -f docker-compose-withenvoy.yml down
