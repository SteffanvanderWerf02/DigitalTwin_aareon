# Explanation MQTT directory
## update-json folder - purpose
In the update-json folder, a MQTT client with a unique ID will connect to the mqtt broker. 
The purpose of this mqtt client and scripts that are used is to keep the data actual and updated in the file `sensordata.json` which can be found under the folder `update-json/sensor_data/sensordata.json`.

The client needs to stay connected to the mqtt client! Otherwise, no actual data can be recovered and old data will stay in the sensordata.json file.

The file `sensordata.json` either needs to contain correct data, be empty, or be deleted. If it contains irrelevant data, the application might exit.

## update-database folder - purpose
In the update-database folder, all the data from the sensordata.json file will be updated in the database.
Because the `sensordata.json` file is updated constantly, the latest version of the data will be appended to the database. 

If the script is already on a server, a Cron job can be used to execute the update-database script every x minutes.