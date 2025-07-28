## Hana.eco Platform Specification

### Hana.eco components

The deployment of hanaeco locally consists of 4 components, each with its own docker image: 

1. `hanaeco-server`: API (backend) server
2. `hanaeco-web`: Web UI (user interface) server
3. `postgres`: Relational DB used by hanaeco-server 
4. `envoy`: (optional) proxy to put both server behind same port

> Note, we are transitioning the name from ecoloop to hanaeco, so they are used interchangeably in the document.

In addition the the aforementioned components, optionally Auth provider is can be configured to handle 
the user authentication.
Otherwise internal id/password scheme can be used for user authentication.

Initially the [Auth0](https://auth0.com/) can be setup until local auth is provided.

### System Minimal Hardware Requirements

- Windows or Linux (ARM or x86)
- 8G+ RAM, larger memory may be needed to handle large reports and importing large files
- 10G+ Hard disk space

### Deployment in local computer

#### Software Pre-requisite

- git
- docker & docker-compose


#### Configuration Points

The deployment configuration is defined across multiple files:

1. `scripts/.env.docker-compose-onprem` - Main Docker Compose and service configuration (images, ports, storage, Auth0, ML, etc).
2. `scripts/.env.docker-server` - Backend server configuration (database, Auth0, JWT, etc).
3. `scripts/.env.docker-web`  - Web application configuration (API URLs, NextAuth, etc).

**Note:** Most sensitive values (such as `OPENAI_API_KEY`, `CIPHER_KEY`, and `DB_PASSWORD`) can be set as environment variables at runtime for security, rather than hardcoding them in the `.env` files.

**Deploying for a your.publicdomain.net**


#### Environments in `scripts/.env.docker-server`

The entries in the file are commented; you will need to uncomment to enable them.



Environments to configure in  `.env.docker-server`

```
DATABASE_URL=
VERIFIED_DOMAINS=
CIPHER_KEY=
```

Where
- `CIPHER_KEY` - The cipher key for encryption/decryption of keys, e.g. API keys. Without this, the app will fail to start.
- `DATABASE_URL` - Postgres connection string. Note that the postgres' host name is as specified in docker-compose.
- `VERIFIED_DOMAINS` - User with the email which domain is listed here are automatically set as 'verified' user. Verified user can create new organizations.

#### Environments to configure in `.env.docker-web`

Key variables in `.env.docker-web`:

```
BAPI_BASE_URL=http://ecoloop-server-onprem:3000
WEB_BASE_URL=http://localhost
NEXTAUTH_URL=http://localhost
NEXTAUTH_URL_INTERNAL=http://ecoloop-web-onprem
```

Where:

- `BAPI_BASE_URL` - The backend API server URL (use the Docker network hostname).
- `WEB_BASE_URL` - The base URL for the web app (typically `http://localhost` for local development).
- `NEXTAUTH_URL` - The public domain or local URL for NextAuth (used for authentication redirects).
- `NEXTAUTH_URL_INTERNAL` - The internal Docker network URL for NextAuth (required for login to work inside containers).

> NOTE: The platform was built to support OAuth spec, but only Auth0 has been fully tested to work. If you want to use a different OAuth Provider, further modification may be needed.
> For now, you can create a new account in Auth0 and provide the corresponding ID/secret.


#### Deploying

Once the configuration is set, you can start the services as follows (from the `/scripts` directory):

```sh
OPENAI_API_KEY=<OPENAI_KEY> CIPHER_KEY=<CIPHER_KEY> DB_PASSWORD=<DBPWD> docker-compose --env-file .env.docker-compose-onprem -f docker-compose-withenvoy.yml up
```

Where:
- `<OPENAI_KEY>` is your OpenAI API key (for chatbot features).
- `<CIPHER_KEY>` is a secret key for encryption (must match the value in `.env.docker-server`).
- `<DBPWD>` is the database password (must match the value in both `.env.docker-compose-onprem` and `.env.docker-server`).

To verify from the same local computer that the services have been successfully deployed:

```
# Verify backend server is up
curl localhost/bapi/info

# Verify web frontend is up
curl localhost/api/info
```

#### Setting the user as a superuser 

When deployment is successful, you can login using Auth0. 
Once logged in for the first time, you can and access the database using postgres client tool such as `psql`, and change the first user's category to `host` user giving superuser privilege.


```sh
docker exec -it postgres-onprem sh
psql -h localhost -p 5432 -d ecoloop-onprem -U ecoloop
```

```sql
UPDATE "User" SET "userCategory" = 'host' WHERE email = 'your-email.here';
``` 

With the user configured as superuser, you can login again and create organization and configure them.


Now the new user's userCategory can be set from 
https://{hostname}/en/admin/users

## Troubleshooting deployment

- If a service does not start, check its logs:
    ```
    docker logs <container-name>
    ```

- To check environment variables inside a running container:
    ```sh
    docker exec -it ecoloop-server-onprem printenv
    ```

- To test connectivity and service availability from within containers:
    ```sh
    docker exec -it ecoloop-web-onprem ash
    # Inside the container:
    curl ecoloop-server-onprem:3000/info
    ```

    ```sh
    docker exec -it ecoloop-server-onprem ash
    # Inside the container:
    curl ecoloop-server-onprem:3000/info
    ```

- To follow logs of a container:
    ```
    docker logs --follow ecoloop-server-onprem
    ```

- To check Docker networks and connectivity:
    ```
    docker exec -it ecoloop-web-onprem ping ecoloop-server-onprem
    docker exec -it ecoloop-web-onprem ping ecoloop-ml-onprem
    docker network ls
    docker network inspect haneco_onprem_app_network
    ```
