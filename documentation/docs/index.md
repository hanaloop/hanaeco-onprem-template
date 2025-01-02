# Deploying hanaeco

## Pre-requisite

The following are software required for deploying the system:

- `git`
- a text editor
- `docker`

In addition, when using cloud-based IDP such as Auth0 relevant account and keys are needed.
And to use chatbot, OpenAI key is needed.

## Installation & Startup

1. Clone this repo

    ```bash
    git clone <repository_url>
    cd <repository_directory>/scripts
    ```

2. Modify the configuration as specified in the following [#configuration] section
3. Run command `services-up.sh`


## Configuration

Modify `/scripts/.env.docker-compose-onprem` file according to your environment:
 
- `AUTH0_ISSUER_URL`  The IDP provider's URL
- `ECOLOOP_WEB_IMAGE` The Hanaeco web server docker image name with the proper version
- `ECOLOOP_SERVER_IMAGE` The Hanaeco backend server docker image name with the proper version
- `STORAGE_LOCATION_ROOT` The absolute path where the updated file will be stored (need full write access)
- `ECOLOOP_ML_IMAGE`  The Hanaeco machine learning docker image
- `OPENAI_API_KEY` The OpenAI key for chat


Other configuration will not require to be modified, but for explanation purpose:
- ECOLOOP_WEB_EXPOSE_PORT
- BAPI_BASE_URL


## Starting and stopping Hanaeco

### Start
Prior starting the applications, make sure:
1. All the ports are available: 80 (http), 5432 (postgres)

Go to `/scripts`

```sh
./services-up.sh
```


### Stop

```sh
./services-down.sh
```
