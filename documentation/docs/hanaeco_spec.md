## Hana.eco Platform Specification

### Hana.eco components

Hanaeco is provided as set of docker images

1. `hanaeco-server`: API (backend) server
2. `hanaeco-web`: Web UI (user interface) server
3. `postgres`: Relational DB used by hanaeco-server 
4. `envoy`: (optional) proxy to put both server behind same port


In addition an Auth provider is necessary.
Initially a [Auth0](https://auth0.com/) will be setup until local auth is provided.

### System Requirements

1. Linux, 8G+ RAM, 10G+ Hard disk space
2. Docker and git


### Deployment in local computer

#### Software Pre-requisite

- git
- docker & docker-compose

#### Configuration

The docker compose yaml file is in a private Github repository:

```
git clone git@gitlab.com:hanaloop/projects/hanaeco-onprem-template.git
cd hanaeco-onprem-template/scripts
```

One the repo is cloned, you can modify the files accordingly.


The deployment configuration is defined across multiple files:
1. `scripts/.env.docker-compose-onprem` - Configuration for docker deployment, including docker images, ports, etc.
2. `scripts/.env.docker-server` - Configuration for the API server application
2. `scripts/.env.docker-web`  - Configuration for the web application 

**Deploying for a your.publicdomain.net**

Environments to configure in  `.env.docker-server`

```
DATABASE_URL=
VERIFIED_DOMAINS=
CIPHER_KEY=
```

Where

- `DATABASE_URL` - Postgres connection string. Note that the postgres' host name is as specified in docker-compose.
- `VERIFIED_DOMAINS` - User with the email which domain is listed here are automatically set as 'verified' user. Verified user can create new origanizations.
- `CIPHER_KEY` - The cipher key for encryption/decryption of keys, e.g. API keys.

Environments to configure in `.env.docker-web`
```
NEXTAUTH_URL=<https://your.publicdomain.net>
AUTH0_CLIENT_ID=<Auth0 IdP's client ID>
AUTH0_CLIENT_SECRET=<Auth0 IdP's client secret>
```
Where

- `NEXTAUTH_URL` - The public domain name the platform will be servicing
- `AUTH0_CLIENT_ID` - Auth0's client ID
- `AUTH0_CLIENT_SECRET` - Auth0's client secret

> NOTE: At the moment of writing the platform supports Oauth. The Auth0 has been fully tested to work. If you want to use different Oauth Provider, the platform needs to be modified accordingly.
> For now you can create a new account in Auth0 and provide the corresponding ID/secret.


#### Deploying

Once the configuration were properly set, you can modify the services-up.sh 

```sh
DB_PASSWORD=<DBPWD> docker-compose --env-file .env.docker-compose -f docker-compose-withenvoy.yml up
```

Where 
- <DBPWD> is the password to be used for initial db creation.

Verify from the same local computer where the services have been deployed:
```
# Verify server is up
curl localhost/bapi/info

# Verify web is up
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

- If one of the server did not ran check it's log
    ```
    docker logs {container-name}
    ```

- If the docker container is running, 

    check if the variables are correcly set:
    ```sh
    docker exec -it ecoloop-server-onprem printenv
    ```

    Check if services can be accessed from the container
    ```sh
    docker exec -it ecoloop-web-onprem ash
    [docker-container] curl ecoloop-server-onprem:3000/info
    ```

    ```sh
    docker exec -it ecoloop-server-onprem ash
    [docker-container] curl ecoloop-server-onprem:3000/info
    ```

- To see the logs of a container
    
    ```
    docker logs --follow ecoloop-server-onprem
    ```

- To see the networks
    
    ```
    docker exec -it ecoloop-web-onprem ping ecoloop-server-onprem
    
    docker exec -it ecoloop-web-onprem ping ecoloop-server-onprem

    docker exec -it ecoloop-web-onprem ping ecoloop-ml-onprem

    docker network ls
    docker network inspect haneco_onprem_app_network
    ```
