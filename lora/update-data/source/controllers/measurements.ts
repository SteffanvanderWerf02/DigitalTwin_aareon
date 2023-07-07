import { Request, Response, NextFunction } from "express";
import crypto from 'crypto';
import Co2Measurement from "../models/Co2Measurement";
import DrycontactsMeasurement from "../models/DrycontactsMeasurement";
import database from "../postgresql/insertSensorData";
const codec = require("@adeunis/codecs");
import Ajv from "ajv"
import fs from 'fs';

// Init JSON Schema Validator
const ajv = new Ajv();
// import * as encodedMeasurementDraftSchema from '../schemas/draft-07/encodedMeasurement.json';
// const validateEncodedMeasurement = ajv.compile(encodedMeasurementDraftSchema);


function validateToken(req: Request): boolean {
	const hash = crypto.createHash('sha256');
	hash.update(JSON.stringify(req.body) + "Nhlstenden&Aareon#SecurePa$$w0rd2023#Random$tr!ng");
	const newHash = hash.digest("hex");

	console.log("SML body: " +JSON.stringify(req.body));

	console.log("Received token: " + req.headers['things-message-token']);

	console.log("Calculated token: " + newHash);

	if (req.headers['things-message-token'] === newHash) {
		return true;
	} else {
		return false;
	}
}
	

/**
 * It receives a payload from a sensor, decodes it, and inserts the decoded data into a database
 * @param {Request} req - Request
 * @param {Response} res - Response
 * @param {NextFunction} next - NextFunction
 * @returns a status code 200 and a json object with the status "success".
 */
const addData = async (req: Request, res: Response, next: NextFunction) => {
	// Check if the token is correct
	// console.log(req.headers)
	// if (validateToken(req)) {
		let payloadValue: [
			{
				bn: "urn:dev:DEVEUI:0018B21000008CF4:"; // Device ID
				bt: 1652972601; // timestamp
			},
			{
				n: "payload";
				vs: "6a2000d440013900d33f013900d33e013a00d33b013800d238013a00d238013e"; // actual payload data to decode
			},
			{
				n: "port";
				v: 1;
			}
		] = req.body;

		console.log("Received data from sensor: " + JSON.stringify(payloadValue));

		// Setup the decoder
		const decoder = new codec.Decoder();

		// if(!validateEncodedMeasurement(payloadValue)) {
		// 	console.log("Validation error in encodedMeasurement! " + JSON.stringify(validateEncodedMeasurement.errors));
		// 	return res.status(200).json({"message": "Validation error in encodedMeasurement!"});
		// }

		let sensorId = payloadValue[0].bn.replace("urn:dev:DEVEUI:", "").replace(":", "");
		let dataBytes = payloadValue[1].vs;
		let deviceTypes = decoder.findDeviceTypes(dataBytes);
		let timestamp = new Date(payloadValue[0].bt * 1000);

		decoder.setDeviceType(deviceTypes[0]);

		if (deviceTypes[0] == "comfortCo2") {
			// Decode data
			// let dataResult: {
			// 	type: "0x6a Comfort CO2 data";
			// 	status: {
			// 		frameCounter: 0;
			// 		hardwareError: false;
			// 		lowBattery: false;
			// 		configurationDone: false;
			// 		configurationInconsistency: false;
			// 		timestamp: false;
			// 	};
			// 	decodingInfo: "values: [t=0, t-1, t-2, ...]";
			// 	temperature: { unit: "°C"; values: [22.1, 22.1, 22.2, 22.2, 22.2, 22.2] };
			// 	humidity: { unit: "%"; values: [45, 45, 45, 45, 45, 45] };
			// 	co2: { unit: "ppm"; values: [252, 246, 252, 246, 250, 249] };
			// }; // dummy data for autocompletion :)
			let dataResult = decodeData(decoder, dataBytes);

			// AVG results
			let avgTemp = getAvg(dataResult.temperature.values);
			let avgHum = getAvg(dataResult.humidity.values);
			let avgCo2 = getAvg(dataResult.co2.values);

			// Log by to console by default
			if (process.env.LOG_SENSORDATA === "true" || process.env.LOG_SENSORDATA === undefined) {
				console.log(`ID: ${sensorId} TYPES: ${deviceTypes} `);
				console.log(`TEMP: ${avgTemp} HUM: ${avgHum} CO2: ${avgCo2}`);
			}

			let co2Measurement: Co2Measurement = new Co2Measurement(
				sensorId,
				avgCo2,
				avgHum,
				avgTemp,
				dataResult.status.hardwareError,
				dataResult.status.lowBattery
			);

			await database.insertC02Row(co2Measurement)
				.then(() => {
					// console.log(co2Measurement.getJson());
					addDataToJson(co2Measurement.getJson());
					return res.status(200).json({ "message": "success" });
				})
				.catch((err) => {
					// console.log(err); // Log this to enable debugging the error.
					// Creates messy console logs when sensor does not exist.
					console.log(`Device ${sensorId} likely does not exist. Device is a ${deviceTypes[0]} type device. ` + err.message);
					return res.status(400).json({ "message": err.message });
				});
		} else if (deviceTypes[0] == "drycontacts") {
			// Decode data
			let dataResult: {
				type: "0x40 Dry Contacts data";
				status: {
					frameCounter: 2;
					hardwareError: false;
					lowBattery: false;
					configurationDone: false;
				};
				decodingInfo: "true: ON/CLOSED, false: OFF/OPEN";
				channelA: {
					value: 1;
					currentState: true;
					previousFrameState: false;
				};
				channelB: {
					value: 0;
					currentState: false;
					previousFrameState: false;
				};
				channelC: {
					value: 5;
					currentState: false;
					previousFrameState: false;
				};
				channelD: {
					value: 2;
					currentState: false;
					previousFrameState: false;
				};
			}; // dummy data for autocompletion :)
			dataResult = decodeData(decoder, dataBytes);

			// AVG results
			let dryContactValue = dataResult.channelA.value;

			// Log by to console by default
			if (process.env.LOG_SENSORDATA === "true" || process.env.LOG_SENSORDATA === undefined) {
				console.log(`ID: ${sensorId} TYPES: ${deviceTypes} `);
				console.log(dryContactValue);
			}
			let dryContactMeasurement: DrycontactsMeasurement = new DrycontactsMeasurement(
				sensorId,
				dryContactValue,
				dataResult.channelA.currentState,
				dataResult.channelA.previousFrameState,
				dataResult.status.hardwareError,
				dataResult.status.lowBattery
			);


			await database.insertWaterRow(dryContactMeasurement)
				.then(() => {
					console.log(dryContactMeasurement.getJson());
					// addDataToJson(dryContactMeasurement.getJson());
					return res.status(200).json({ "message": "success" });
				})
				.catch((err) => {
					// console.log(err); // Log this to enable debugging the error.
					// Creates messy console logs when sensor does not exist.
					console.log(`Device ${sensorId} likely does not exist. Device is a ${deviceTypes[0]} type device. ` + err.message);
					return res.status(400).json({ "message": err.message });
				});

			// Check if battery from dataResult is low, and if so update sensor in DB with battery = 0
			// if (dataResult.status.lowBattery) {
			// 	let sensor = await sensorSql.findItemById(sensorId);
			// 	sensor.battery = 0;
			// 	sensorSql.updateRow(sensor, sensorId);
			// }

		} else {
			console.log("New device type not in database: " + deviceTypes);
			console.log("Data: " + dataBytes);
			return res.status(400).json({ "message": "error" });
		}
	// }else{
	// 	return res.status(403).json({ "message": "Auth error" });
	// }

};

/**
 * The function takes a decoder and sensorBytes as arguments and returns the result of the decoder.decode function or a string if there is an error.
 * @param {any} decoder - the decoder object that was created in the previous step
 * @param {string} sensorBytes - The data you want to decode.
 * @returns The result of the decodeData function is a string.
 */
const decodeData = (decoder: any, sensorBytes: string) => {
	let result = decoder.decode(sensorBytes);
	if (result.error) {
		result = "decoding issue";
	}
	return result;
};

/**
 * The function takes an array of numbers as an argument and returns the average of the numbers in the array.
 * @param arr - Array<number> - This is the array that we're going to be passing into the function.
 * @returns The average of the numbers in the array.
 */
function getAvg(arr: Array<number>) {
	let total = 0;
	arr.forEach((element) => {
		total = total + element;
	});

	let avg = total / arr.length;

	return parseFloat(avg.toFixed(2));
}

function addDataToJson(json: string) {
	createEmptyJsonFile('loraData.json');
		
	let newData = JSON.parse(json);
	let data = fs.readFileSync('loraData.json');
	let jsonArr = JSON.parse(data.toString());
	
	// Check if the record already exists
	const keys: string[] = Object.keys(newData);
	let existingIndex = -1;
	for (let i = 0; i < jsonArr.length; i++) {
		const element = jsonArr[i];
		if (element.hasOwnProperty(keys[0])) {
			existingIndex = i;
			break;
		}
	}

	if (existingIndex !== -1) {
	// Delete the existing record
	jsonArr.splice(existingIndex, 1);
	}

	// Add the new record
	jsonArr.push(newData);

	// Write updated data back to the file
	fs.writeFileSync('loraData.json', JSON.stringify(jsonArr, null, 2));

}

function createEmptyJsonFile(filePath: string): void {
	if (fs.existsSync(filePath)) {
	//   console.log(`File '${filePath}' already exists.`);
	  return;
	}
  
	const emptyArray: any[] = [];
  
	fs.writeFileSync(filePath, JSON.stringify(emptyArray, null, 2));
	console.log(`Empty JSON file '${filePath}' created successfully.`);
  }

export default { addData };
