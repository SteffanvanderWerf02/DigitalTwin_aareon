# The purpose of this file, is to retrieve the correct data from the mqtt
# python3.6
import json
import random
from paho.mqtt import client as mqtt_client
import prepare

import sys
sys.path.append('../')
from utility.utility import readYamlFile


config = readYamlFile("../config.yaml")

broker = config[2]["mqtt"]["broker"]
port = config[2]["mqtt"]["port"]
topic1 = config[2]["mqtt"]["topic1"]
topic2 = config[2]["mqtt"]["topic2"]

# generate client ID with pub prefix randomly
client_id = f'dt-mqtt-{random.randint(0, 100)}'

def connect_mqtt() -> mqtt_client:
    def on_connect(client, userdata, flags, rc):
        if rc == 0:
            print("Connected to MQTT Broker!")
        else:
            print("Failed to connect, return code %d\n", rc)

    client = mqtt_client.Client(client_id)
    client.on_connect = on_connect
    client.connect(broker, port)
    return client


def subscribe(client: mqtt_client):
    def on_message(client, userdata, msg):
        res = json.loads(msg.payload.decode())
        res["sensor"] = msg.topic.split("/")[1].upper()

        # state is either a message that shows the device is online or offline,
        # if it is not, it holds the data of the sensor (note that in prepare.py only hue motion sensors that are registered in the database are let through)
        if 'state' in res:
            print(res)
            prepare.update(res, True)
        else:
            print(res)
            res["topic"] = msg.topic
            prepare.update(res, False)

    client.subscribe(topic1)
    client.subscribe(topic2)
    client.on_message = on_message


def run():
    client = connect_mqtt()
    subscribe(client)
    client.loop_forever()


if __name__ == '__main__':
    run()
