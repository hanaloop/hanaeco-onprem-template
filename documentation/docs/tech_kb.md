# Technical Notes

## Docker & Docker compose

* When you are trying to push docker image make sure you are logged in to docker hub. We are using hanalooper's account
  
  ```
  docker login <id>
  ```

* The variables in docker compose yaml file needs to specified as variable for shell environment passing to work.

  E.g. when `FLAG=hello ./services-up.sh` is ran, the FLAG environment will be be automatically passed to the docker container unless it is specified in docker compose yaml file's `environment:` context. 

*  The ecoloop-web have a `NEXT_PUBLIC_BAPI_BASE_URL` needs to be set to the Backed API (server) in the front-end code. 
  
  - This parameter is set to the full URL then client and server uses completely different origin. 
  - When same origin is used, then a relative path from the host is used, e.g. `/bapi`
  - FYI: The ecoloop-server has no particular build parameter.

* To build and push the images, `./docker.sh --build --push` script can be used. Depending on the CPU architecture, you can pass `-variation=arm`.

## Hanaeco configuration

There are various configuration three files:

* `.env.docker-compose-onprem` - The overall configuration for docker compose.
  Possible changes needed here:
  - `DB_USERNAME` - The initial DB user
  - `DB_PASSWORD` - The initial DB user's password (suggested to set this in-memory environment for security)
  - `DB_DATABASE_NAME` - initial DB name
  - `ECOLOOP_WEB_IMAGE`, `ECOLOOP_SERVER_IMAGE` - If you need to change the version
  - `AUTH0_ISSUER_URL`, `AUTH0_AUDIENCE` - If you are using different Auth0 configuration

* `.env.docker-server` - The backend server related config
  Possible changes needed here:
  - `AUTH0_ISSUER_URL`, `AUTH0_AUDIENCE` - If you are using different Auth0 configuration
  - `IMPORT_FILE_PATTERN` - Initially set to "." to load all Emission Factors, then set to empty string "" to avoid re-loading

* `.env.docker-web`

In most of the cases the `docker-compose-withenvoy.yml` shouldn't need to be modified.

## Running application

* If the application is not accessible (e.g. opening in browser to localhost) even when Docker Compose is up, check that all the servers are running and none have exited due to errors.

  You can check the registered servers in the Docker network using:
  ```sh
  docker network inspect haneco_onprem_app_network
  ```

* To check logs for a specific container:
  ```sh
  docker logs <container-name>
  ```

* To verify environment variables inside a running container:
  ```sh
  docker exec -it ecoloop-server-onprem printenv
  ```

* To test connectivity from within a container:
  ```sh
  docker exec -it ecoloop-web-onprem ash
  # Inside the container:
  curl ecoloop-server-onprem:3000/info
  ```

## Configuration

- Once the application is started, if you do not see the login button, then you will need to fix the `NEXTAUTH_URL_INTERNAL` in the `.env.docker-web`. It should be set to the docker network's name, e.g. `http://ecoloop-web-onprem`


## Staring the application

* When `IMPORT_FILE_PATTERN` is set to `.` in `.env.docker-server`, it will take a while for the server to startup, as it takes several seconds to load all the E 

