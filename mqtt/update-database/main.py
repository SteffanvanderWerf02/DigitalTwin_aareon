import sys
sys.path.append('../database')
import database 
import json

jsonFile = '../update-json/sensor_data/sensordata.json'

# loadJsonFile()
#
# load the json file from the update-json/sensor_data folder - this will contain all the up-to-date records
#
def loadJsonFile():
    try:
        with open(jsonFile) as f:
            data = json.load(f)
    except:
        print("[*] Failed to load the json file! method loadJsonFile() - main.py")
        return None
    return data


# prepareJsonData():
#
# prepare the data from the json file
#
def prepareJsonData():
    data = loadJsonFile()
    if (data == None):
        return

    queryMotionData = []
    queryCo2Data = []
    for key, value in data["sensors"].items():
                
        if 'data' in value:
            if(key.find("CO2") == -1):
                # motion sensor
                occupancy = value['data']['occupancy']
                friendlyName = value['data']['sensor']
                batteryPercentage = value['data']['battery']
                temperature = value['data']['temperature']
                sensorState = False if value['state'].upper() == "OFFLINE" else True
                data = (occupancy, friendlyName, batteryPercentage, sensorState, temperature)

                # append the relevant sensor data to a query array
                queryMotionData.append(data)
            else:
                # co2 sensor
                batteryPercentage = None
                co2 = value['data']['co2']
                friendlyName = value['data']['sensor']
                if 'battery_low' in value['data']: 
                    batteryPercentage = value['data']['battery_low']
                    battery = True
                else:
                    batteryPercentage = False
                    battery = False
                temperature = value['data']['temperature']
                humidity = value['data']['humidity']
                # voc = value['data']['voc']
                # formaldehyd = value['data']['formaldehyd']
                sensorState = False if value['state'].upper() == "OFFLINE" else True
                
                data = (friendlyName,sensorState,temperature, humidity, co2, batteryPercentage, battery)
                # append the relevant sensor data to a query array
                queryCo2Data.append(data)

    if len(queryMotionData) > 0:
        # print(queryMotionData)
        database.insertData(queryMotionData,"INSERT INTO dt_emmen.sensor_motion_data_zigbee(occupied, friendlyname, battery_percentage, state, temperature) VALUES (%s, %s, %s, %s, %s)","Motion")
    
    if len(queryCo2Data) > 0:
        # print(queryCo2Data)
        database.insertData(queryCo2Data,"INSERT INTO dt_emmen.sensor_co2_data_zigbee(friendlyname, state, temperature, huminity, co2, battery_low, battery) VALUES (%s, %s, %s, %s, %s, %s, %s)", "CO2")

if __name__ == '__main__':
    prepareJsonData()
    
