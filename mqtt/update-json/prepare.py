import sys
sys.path.append('../database')
import database 
import os
import json


sensors = database.retrieveSensors()
jsonFile = './sensor_data/sensordata.json'
dict = {"sensors": {

}}

# elementExists()
#
# checks if an element exists
def elementExists(element):
    try:
        with open(jsonFile) as f:
            sensors = json.load(f)
            if element in sensors:
                return True
    except:
        return False

# createJsonFiles():
#
# creates the json files if they do not exist already
# 
def createJsonFile():
    if os.path.exists(jsonFile) and elementExists('sensors'):
        return

    if os.path.exists(jsonFile):
        os.remove(jsonFile)

    for sensor in sensors:
        dict['sensors'][sensor] = {}

    with open(jsonFile, "w") as outfile:
        json.dump(dict, outfile, indent=4)

# writeData():
#
# write the data to the file
#
def writeData(res, state):
    # if it is an update of the state
    if state:
        try:
            with open(jsonFile) as f:
                data = json.load(f)
                data['sensors'][res['sensor']]['state'] = res['state']

            with open(jsonFile, 'w') as outfile:
                json.dump(data, outfile, indent=4)

        except Exception as e:
            print(f"[*] An error has occured when opening the JSON file! Method : writeData() - prepare.py - state {e}")

    # if it is not an update of the state
    else:
        try:
            with open(jsonFile) as f:
                data = json.load(f)
                data["sensors"][res["sensor"]]["data"] = res

            with open(jsonFile, 'w') as outfile:
                json.dump(data, outfile, indent=4)
        except Exception as e:
            print(f"[*] An error has occured when opening the JSON file! Method : writeData() - prepare.py - no state {e}")

# update():
#
# write json files with the sensor data
#
def update(res, state):
    if not res["sensor"] in sensors:
        return

    # create the json file if it is not there yet
    createJsonFile()

    # write data to the json file
    writeData(res, state)


