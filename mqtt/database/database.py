import sys
import json
sys.path.append('../')
from utility.utility import readYamlFile
import psycopg2
import yaml 

#######################################
# CREATE DATABASE CONNECTION
#######################################

# connection():
# 
# instantiates a database connection and returns it
def connection():
    config = readYamlFile("../config.yaml")

    conn = psycopg2.connect(
        host=config[0]["database"]["host"],
        database=config[0]["database"]["db_name"],
        user=config[0]["database"]["user"],
        password=config[0]["database"]["password"],
        port=config[0]["database"]["port"]
    )

    return conn

#######################################
# RETRIEVE DATA FROM SENSORS OVER MQTT
#######################################

# retrieveSensors():
# 
# retrieve all sensors available int he database and return it as an array
def retrieveSensors():
    conn = connection()
    mycursor = conn.cursor()
    mycursor.execute("SELECT friendlyName FROM dt_emmen.sensor WHERE type_id = 1 OR type_id = 2")
    data = mycursor.fetchall()

    sensors = []
    for sensor in data:
        sensors.append(sensor[0])

    return sensors

#######################################
# UPDATE FACILITOR DATA
#######################################

# getFormatedData()
#
# fetches the data from sensors from the database
def getFormatedData():
    conn = connection()
    mycursor = conn.cursor()

    mycursor.execute("""
                        SELECT  sensor_facilitor.facilitor_id,
                                sensor_facilitor.data_type_id,
                                motionData.temperature,
                                motionData.occupied,
                                motionData.battery_percentage
                        FROM dt_emmen.room
                        INNER JOIN dt_emmen.sensor ON dt_emmen.sensor.room_number = dt_emmen.room.room_number
                        INNER JOIN dt_emmen.sensor_motion_data_zigbee AS motionData ON dt_emmen.sensor.friendlyname = motionData.friendlyname
                        INNER JOIN dt_emmen.sensor_facilitor ON motionData.friendlyname = dt_emmen.sensor_facilitor.sensor_id
                        WHERE motionData.date = (SELECT MAX(sensor_motion_data_zigbee.date) FROM dt_emmen.sensor_motion_data_zigbee LIMIT 1)
                        AND dt_emmen.room.building_id = 1
                        ORDER BY sensor.friendlyname;

                    """)
    sensordata = mycursor.fetchall()
    mycursor.execute("""
                        SELECT  sensor_facilitor.facilitor_id,
                                sensor_facilitor.data_type_id,
                                co2Data.co2
                        FROM dt_emmen.room
                        INNER JOIN dt_emmen.sensor ON dt_emmen.sensor.room_number = dt_emmen.room.room_number
                        INNER JOIN dt_emmen.sensor_co2_data_zigbee AS co2Data ON dt_emmen.sensor.friendlyname = co2Data.friendlyname
                        INNER JOIN dt_emmen.sensor_facilitor ON co2Data.friendlyname = dt_emmen.sensor_facilitor.sensor_id
                        WHERE co2Data.date = (SELECT MAX(sensor_co2_data_zigbee.date) FROM dt_emmen.sensor_co2_data_zigbee LIMIT 1)
                        AND dt_emmen.room.building_id = 1
                        ORDER BY sensor.friendlyname;

                    """)
    sensordata += mycursor.fetchall()

    json_data = {}
    for item in sensordata:
        id_num = str(item[0])
        if item[1] == 1:
             data = item[3] # occupied of motion sensor
        elif item[1] == 2: 
            data = item[2] # temperature of motion sensor
           
        elif item[1] == 3:
            data = item[2] # co2 of co2 sensor

        json_data[id_num] = {
                "state": data
        }

    with open('./data.json', 'w') as f:
        json.dump(json_data, f, indent=2)
    
        print(f"[*] Facilitor JSON data written to file data.json")  
   
#######################################
#UPDATE DATABASE RETENTION PERIOD DATA
#######################################
	
# updateRetentionPeriod():
# update the retention period 
def updateRetentionPeriod():
    buildingDetails = getBuildings()
    try:
        deleteCo2SensorData(buildingDetails)
        deleteMotionSensorData(buildingDetails)
        print("[*] sensordata updated to retention period(s) of the building(s) succesfully!")
    except e as err:
        print("[*] Quer(y)(ies) failed : {error}".format(error=e))

# retrieve the building id and retention period
def getBuildings():
    conn = connection()
    mycursor = conn.cursor()
    mycursor.execute("SELECT building.id, building.retention_period FROM dt_emmen.building")
    data = mycursor.fetchall()

    buildings = []
    for d in data:
        buildings.append({"building_id": d[0], "retention_period" : d[1]})

    mycursor.close()
    conn.close()
    return buildings

# delete all co2 sensordata older then the retention period of a building
def deleteCo2SensorData(buildingDetails):
    conn = connection()
    mycursor = conn.cursor()

    for d in buildingDetails:
        mycursor.execute("""DELETE FROM
                            sensor_co2_data_zigbee
                            WHERE sensor_co2_data_zigbee.date < CURRENT_DATE - INTERVAL '{retention_period} days'
                            AND sensor_co2_data_zigbee.friendlyname IN 
                            (
                                SELECT sensor.friendlyname 
                                FROM sensor
                                WHERE sensor.room_number IN 
                                (
                                    SELECT room.room_number
                                    FROM room
                                    WHERE room.building_id IN 
                                    (
                                        SELECT building.id FROM building WHERE building.id = {building_id}
                                    )
                                )
                            )
                    """.format(
                        retention_period=int(d["retention_period"]),
                        building_id=int(d["building_id"])
                    ))
    conn.commit()
    mycursor.close()
    conn.close()

# delete all motion sensordata older then the retention period of a building
def deleteMotionSensorData(buildingDetails):
    conn = connection()
    mycursor = conn.cursor()

    for d in buildingDetails:
        mycursor.execute("""DELETE FROM
                            sensor_motion_data_zigbee
                            WHERE sensor_motion_data_zigbee.date < CURRENT_DATE - INTERVAL '{retention_period} days'
                            AND sensor_motion_data_zigbee.friendlyname IN 
                            (
                                SELECT sensor.friendlyname 
                                FROM sensor
                                WHERE sensor.room_number IN 
                                (
                                    SELECT room.room_number
                                    FROM room
                                    WHERE room.building_id IN 
                                    (
                                        SELECT building.id FROM building WHERE building.id = {building_id}
                                    )
                                )
                            )
                    """.format(
                        retention_period=int(d["retention_period"]),
                        building_id=int(d["building_id"])
                    ))
    conn.commit()
    mycursor.close()
    conn.close()

#######################################
# UPDATE DATA TO DATABASE     
#######################################

# insertData()
#
# update the query data from the JSON file, using prepared statements
def insertData(data, query, sensorType):
    conn = connection()
    mycursor = conn.cursor()
    mycursor.executemany(query, data)
    conn.commit()

    print(f"[*] {mycursor.rowcount}  {sensorType} records inserted successfully into the database!")

    
    