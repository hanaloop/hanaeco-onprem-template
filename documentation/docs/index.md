# Deploying Hanaeco

## Prerequisite

The following are software required for deploying the system:

- `git`
- `docker`
- A text editor

Additionally:

- If using a cloud-based Identity Provider (IDP) such as Auth0, you will need a valid account and API keys.
- To enable the chatbot feature, an OpenAI API key is required. By default, the chatbot is disabled (HL_DISABLE_GENAI=true).

## Installation, Quick Configuration and Server Start

The installation is just cloning the 

1. Clone this repository

    ```bash
    git clone <repository_url>
    cd <repository_directory>/scripts
    ```

2. Minimal configuration

At a minimum, configure the following in `.env.docker-compose-onprem`.
- `DBDATA_LOCATION_ROOT`  Absolute path for PostgreSQL persistent storage
- `STORAGE_LOCATION_ROOT` Absolute path for file storage (requires write access)
- `SEED_DATA_CONNECTORS_LOCATION` Absolute path for the connector seed data. The seed data is used by the GenAI service.

And services-up.sh/bat
- `CIPHER_KEY` The cyphyer key for encryption/decryption
- `DB_PASSWORD`= The DB password

And make sure the password in DB_PASSWORD matches the password in set in `.env.docker-server`


3. Start services 
  - On Unix-based systems: `services-up.sh`
  - On Windows:`services-up.bat` 

> On the first startup, set IMPORT_FILE_PATTERN=. to load seed data.
The initial data load may take up to 3 minutes.
> After seeding is complete, reset IMPORT_FILE_PATTERN to an empty value to avoid re-importing.

4. Test the application

  - Open a browser to http://localhost
  - Register the first user as host using the same email as specified in `HOST_EMAILS` environment, in the `.env.docker-server` file



## Full Configuration

Most configuration is handled via the `.env` files:
  - [`scripts/.env.docker-compose-onprem`](../scripts/.env.docker-compose-onprem): Main Docker Compose and service configuration.
  - [`scripts/.env.docker-server`](../scripts/.env.docker-server): Backend server configuration (database, Auth0, ML, etc).
  - [`scripts/.env.docker-web`](../scripts/.env.docker-web): Web application configuration (API URLs, NextAuth, etc).

Some sensitive values (such as `OPENAI_API_KEY`, `CIPHER_KEY`, and `DB_PASSWORD`) can be set either directly in the `.env` files or passed as environment variables when starting the services. For security, it is recommended to pass secrets as environment variables rather than hardcoding them in files.

### Shared configuration `/scripts/.env.docker-compose-onprem`

- `AUTH0_ISSUER_URL`  Auth0 IDP provider URL
- `AUTH0_AUDIENCE`  Auth0 IDP audience
- `AUTH0_SECRET`  Auth0 IDP provider's secret key
- `AUTH0_CLIENT_ID`  Auth0 IDP provider's client ID
- `AUTH0_CLIENT_SECRET`  Auth0 IDP provider's client secret
- `SEED_DATA_CONNECTORS_LOCATION` The absolute path to the seed data connectors folder, e.g. on windows `C:\Users\username\hanaeco-onprem-template\hanaeco-seed-data-connectors`
- `HANAECO_WEB_IMAGE` The Hanaeco web server docker image (with version)
- `HANAECO_SERVER_IMAGE` The Hanaeco backend server docker image (with version)
- `DBDATA_LOCATION_ROOT`  The absolute path where the database (Postgres) persistent files are stored
- `STORAGE_LOCATION_ROOT` The absolute path where the updated file will be stored (need full write access)
- `HANAECO_ML_IMAGE`  The Hanaeco machine learning docker image (with version)
- `OPENAI_API_KEY` The OpenAI key for chat features (optional)
- `DB_PASSWORD` The password to be used for initial db creation. This needs to be the same password as used in the DATABASE_URL in .env.docker-server 

### Backend server configuration `/scripts/.env.docker-server`

- `JWT_SECRET` The secret key for JWT token if you want to use JWT for authentication
- `DATABASE_URL` The database connection string. The default value is `postgresql://hanaeco:password@postgres-onprem:5432/hanaeco-onprem?schema=public&connection_limit=25`. Make sure to change the password to the one specified in .env.docker-compose-onprem


## Starting and stopping Hanaeco

Prior starting the applications, make sure all the ports are available: 80 (http), 5432 (postgres)

The scripts are located in `/scripts` folder

### On a unix based system

#### Start

Go to `/scripts`

```sh
./services-up.sh
```


#### Stop

```sh
./services-down.sh
```


### On windows

#### Start

Go to `/scripts`

```bat
services-up.bat
```


#### Stop

```bat
services-down.bat
```

### Deploying

#### Start / Stop scripts

The start/stop script basically does a docker compose up and down.

The script passes environment variables, which it is recommended to be pass as environment (eg. using export).

On unix-based, the script looks like:
```sh
OPENAI_API_KEY=<OPENAI_KEY> CIPHER_KEY=<CIPHER_KEY> DB_PASSWORD=<DBPWD> docker-compose --env-file .env.docker-compose-onprem -f docker-compose-withenvoy.yml up
```

On Windows, you can set environment variables in PowerShell or Command Prompt before running the batch script, or edit the `.env` files directly.

Where:
- `<OPENAI_KEY>` is your OpenAI API key (for chatbot features).
- `<CIPHER_KEY>` is a secret key for encryption (must match the value in `.env.docker-server`).
- `<DBPWD>` is the database password (must match the value in both `.env.docker-compose-onprem` and `.env.docker-server`).

Alternatively, you can use the provided scripts:
- `services-up.sh` (Unix)
- `services-up.bat` (Windows)


#### Verifying Services

To verify that the services are running correctly, from the same local computer:

```sh
# Verify backend server is up
curl http://localhost/bapi/info

# Verify web frontend is up
curl http://localhost/api/info
```

If you receive valid responses, the deployment was successful.

#### Notes

- Ensure all required ports (80 for HTTP, 5432 for Postgres, etc.) are available before starting.
- If you encounter issues, check the logs of each container using `docker logs <container-name>`.
- For advanced configuration, refer to the comments in each `.env` file and the [Technical Notes](tech_kb.md).

