# Mosquitto, the Open Source MQTT Broker.

**This configuration is WIP.**

The goal is to 
1. Configure authorization
2. Store in a log and persistent queue in host file system


## Creating user
```sh
# create password file with first user
# enter password when prompted
mosquitto_passwd -c mosquitto_passwd myuser

# add another user (without -c, so it appends)
mosquitto_passwd mosquitto_passwd otheruser
```

```sh
docker run -it --rm \
  -p 1883:1883 \
  -v $(pwd)/mosquitto.conf:/mosquitto/config/mosquitto.conf \
  -v $(pwd)/mosquitto_passwd:/mosquitto/config/mosquitto_passwd \
  eclipse-mosquitto
```

## Configure mosquitto.conf

Create a config file (e.g., mosquitto.conf) that points to the password file and enforces authentication:

```sh
# Listen on default MQTT port
listener 1883

# Allow anonymous? (false means only authenticated users allowed)
allow_anonymous false

# Path to password file
password_file /mosquitto/config/mosquitto_passwd
```


## Test connection
```sh
mosquitto_sub -h localhost -p 1883 -u device -P '' -t test/topic
mosquitto_pub -h localhost -p 1883 -u device -P '' -t test/topic -m "Hello world"
```