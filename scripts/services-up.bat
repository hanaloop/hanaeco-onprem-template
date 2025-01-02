@echo off
:: Batch file to run docker-compose with an optional -d flag

set OPENAI_API_KEY=
set CIPHER_KEY=
set DB_PASSWORD=


:: Check if a parameter is passed
IF "%1"=="-d" (
  echo Running docker-compose in detached mode...
  docker-compose -p haneco_onprem  --env-file .env.docker-compose-onprem -f docker-compose-withenvoy.yml up -d
) ELSE (
  echo Running docker-compose in foreground mode...
  docker-compose -p haneco_onprem  --env-file .env.docker-compose-onprem -f docker-compose-withenvoy.yml up
)

:: Exit script
EXIT /B

