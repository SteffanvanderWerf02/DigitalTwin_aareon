import { Client } from "pg";
import Co2Measurement from "../models/Co2Measurement";
import DrycontactsMeasurement from "../models/DrycontactsMeasurement";
import config from "./config";


const insertC02Row = (measurement: Co2Measurement): Promise<void> =>
	new Promise((resolve, reject) => {
		const client = new Client(config);
		client.connect((err: Error | null) => {
			if (err) {
				console.log("Connection Failed! because of: " + err.message);
				reject(err);
			} else {
				const sql = `
					INSERT INTO 
						dt_emmen.sensor_co2_data_lora(
							friendlyname, "hardwareError", temperature, huminity, co2, "lowBattery")
						VALUES 
							($1, $2, $3, $4, $5, $6);
				`;

				const values = [
					measurement.sensorDeviceUuid,
					measurement.hardwareError,
					measurement.temperature,
					measurement.humidity,
					measurement.co2,
					measurement.lowBattery
				];

				client.query(sql, values, (err: Error | null) => {
					if (err) {
						reject(err);
					} else {
						resolve();
					}
					client.end();
				});
			}
		});
	});

const insertWaterRow = (measurement: DrycontactsMeasurement): Promise<void> =>
	new Promise((resolve, reject) => {
		const client = new Client(config);
		client.connect((err : Error | null) => {
			if (err) {
				console.log("Connection Failed!");
				reject(err);
			} else {
				const sql = `
				INSERT INTO 
					dt_emmen.sensor_water_data_lora(
						friendlyname, "hardwareError", "lowBattery", "channelValue", "currentState", "previousFrameState")
					VALUES 
					($1, $2, $3, $4, $5, $6);
					`;

				const values = [
					measurement.sensorDeviceUuid,
					measurement.hardwareError,
					measurement.lowBattery,
					measurement.channelValue,
					measurement.currentState,
					measurement.previousFrameState
				];

				client.query(sql, values, (err : Error | null) => {
					if (err) {
						reject(err);
					} else {
						resolve();
					}
					client.end();
				});
			}
		});
	});

export default { insertC02Row, insertWaterRow };
