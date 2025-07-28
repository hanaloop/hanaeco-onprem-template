# Deploying hanaeco

## Pre-requisite

The following are software required for deploying the system:

- `git`
- a text editor
- `docker`

In addition, when using cloud-based IDP such as Auth0 relevant account and keys are required.
And to use chatbot, an OpenAI API key is needed.

## Installation & Startup

1. Clone this repo

    ```bash
    git clone <repository_url>
    cd <repository_directory>/scripts
    ```

2. Modify the configuration as specified in the following [configuration](#configuration) section
3. Run command `services-up.sh` on a unix based system or `services-up.bat` on windows


## Configuration

Modify `/scripts/.env.docker-compose-onprem` file according to your environment:

- `AUTH0_ISSUER_URL`  The IDP provider's URL
- `AUTH0_AUDIENCE`  The IDP provider's audience
- `AUTH0_SECRET`  The IDP provider's secret key
- `AUTH0_CLIENT_ID`  The IDP provider's client ID
- `AUTH0_CLIENT_SECRET`  The IDP provider's client secret
- `SEED_DATA_CONNECTORS_LOCATION` The absolute path to the seed data connectors folder, e.g. on windows `C:\Users\username\hanaeco-onprem-template\hanaeco-seed-data-connectors`
- `ECOLOOP_WEB_IMAGE` The Hanaeco web server docker image name with the proper version
- `ECOLOOP_SERVER_IMAGE` The Hanaeco backend server docker image name with the proper version
- `DBDATA_LOCATION_ROOT`  The absolute path where the database (Postgres) persistent files are stored
- `STORAGE_LOCATION_ROOT` The absolute path where the updated file will be stored (need full write access)
- `ECOLOOP_ML_IMAGE`  The Hanaeco machine learning docker image
- `OPENAI_API_KEY` The OpenAI key for chat
- `DB_PASSWORD` The password to be used for initial db creation. This needs to be the same password as used in the DATABASE_URL in .env.docker-server 

Modify `/scripts/.env.docker-server` file:

- `JWT_SECRET` The secret key for JWT token if you want to use JWT for authentication
- `DATABASE_URL` The database connection string. The default value is `postgresql://ecoloop:password@postgres-onprem:5432/ecoloop-onprem?schema=public&connection_limit=25`. Make sure to change the password to the one specified in .env.docker-compose-onprem
## Starting and stopping Hanaeco

### On a unix based system
#### Start
Prior starting the applications, make sure:
1. All the ports are available: 80 (http), 5432 (postgres)

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
Prior starting the applications, make sure:
1. All the ports are available: 80 (http), 5432 (postgres)

Go to `/scripts`

```bat
services-up.bat
```


#### Stop

```bat
services-down.bat
```

### Deploying

Once you have finished configuring the `.env` files, you can deploy the system using the provided scripts.

#### Environment Variables

- Most configuration is handled via the `.env` files:
  - [`scripts/.env.docker-compose-onprem`](../scripts/.env.docker-compose-onprem): Main Docker Compose and service configuration.
  - [`scripts/.env.docker-server`](../scripts/.env.docker-server): Backend server configuration (database, Auth0, ML, etc).
  - [`scripts/.env.docker-web`](../scripts/.env.docker-web): Web application configuration (API URLs, NextAuth, etc).

- Some sensitive values (such as `OPENAI_API_KEY`, `CIPHER_KEY`, and `DB_PASSWORD`) can be set either directly in the `.env` files or passed as environment variables when starting the services. For security, it is recommended to pass secrets as environment variables rather than hardcoding them in files.

#### Starting the Services

On Unix-based systems, from the `/scripts` directory:

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

#### Verifying Deployment

To verify that the services are running correctly, from the same local computer:

```sh
# Verify backend server is up
curl localhost/bapi/info

# Verify web frontend is up
curl localhost/api/info
```

If you receive valid responses, the deployment was successful.

#### Stopping the Services

On Unix:
```sh
./services-down.sh
```

On Windows:
```bat
services-down.bat
```

#### Notes

- Ensure all required ports (80 for HTTP, 5432 for Postgres, etc.) are available before starting.
- If you encounter issues, check the logs of each container using `docker logs <container-name>`.
- For advanced configuration, refer to the comments in each `.env` file and the [Technical Notes](tech_kb.md).

