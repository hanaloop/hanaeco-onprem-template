# Hana.eco OnPrem deployment script template

This repo contains all necessary scripts along with documentation to deploy Hanaeco in a on-prem server.


## Deployment Configuration

The deployment is based on docker compose.
Three main components: hanaeco-ui-web, hanaeco-server, hanaeco-ml are ran in addition to envoy, a reverse proxy, which fronts them.


## About this Repository: 

This repository has the following directory structure

- `./documentations` - Documentation in markdown format.
- `./scripts` - The scripts and configuration files


### Documentation

The documentation are maintained under `documentation` folder and it uses [mkdocs](https://www.mkdocs.org/) to convention.

The `mkdocs` is a document markdown based project documentation framweork built on python. 

Installation of mkdocs (assuming python is already available)
```
pip install mkdocs
```

Starting mkdocs
IN the `documentation` 
```
mkdocs serve
```

### Scripts 

The scripts directory includes docker env files, docker compose are under `./scripts` folder.
