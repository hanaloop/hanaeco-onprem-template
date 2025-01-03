## Hana.eco Platform Specification

### Hana.eco components

The deployment of hanaeco locally consists of 4 components, each with its own docker image: 

1. `hanaeco-server`: API (backend) server
2. `hanaeco-web`: Web UI (user interface) server
3. `postgres`: Relational DB used by hanaeco-server 
4. `envoy`: (optional) proxy to put both server behind same port

> Note, we are transitioning the name from ecoloop to hanaeco, so they are used interchangeably in the document.

In addition the the aforementioned component, an Auth provider is necessary to handle 
the user authentication.

Initially a [Auth0](https://auth0.com/) can be setup until local auth is provided.


### System Minimal Hardware Requirements

- Windows or Linux (ARM or x86)
- 8G+ RAM, larger memory may be needed to handle large reports 
- 10G+ Hard disk space


#### Configuration Points

The configuration is defined across multiple files:
1. `scripts/.env.docker-compose-onprem` - Configuration for docker deployment, including docker images, ports, etc.
2. `scripts/.env.docker-server` - Configuration for the API server application
3. `scripts/.env.docker-web`  - Configuration for the web application 
4. `scripts/.env.docker-ml`   - Configuration for the AI/ML application 



#### Environments in `scripts/.env.docker-server`

Each entry in the file are commented, below are key entries

- `CIPHER_KEY` - The cipher key for encryption/decryption of keys, e.g. API keys. Without this, the app will fail to start.
- `DATABASE_URL` - Postgres connection string. Note that the postgres' host name is as specified in docker-compose.
- `VERIFIED_DOMAINS` - User with the email which domain is listed here are automatically set as 'verified' user. Verified user can create new organizations.

#### Environments to configure in `.env.docker-web`

- `NEXTAUTH_URL` - The public domain name the platform will be servicing
- `NEXTAUTH_URL_INTERNAL` - The internal URL. Without this, the login button may fail to render.
- `AUTH0_CLIENT_ID` - Auth0's client ID
- `AUTH0_CLIENT_SECRET` - Auth0's client secret

> NOTE: The platform was built to support Oauth spec, but only Auth0 has been fully tested to work. If you want to use different Oauth Provider, the platform may need further modification.
> For now you can create a new account in Auth0 and provide the corresponding ID/secret.



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
