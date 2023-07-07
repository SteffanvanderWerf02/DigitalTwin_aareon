/* A measurement is a value, a timestamp, a sensor device UUID, a type name, an updated at date, and a created at date. */
abstract class Measurement {
	sensorDeviceUuid: string;
	typeName: string;
	hardwareError: boolean;
    lowBattery: boolean;
	updatedAt: Date | undefined;
	createdAt: Date | undefined;

	constructor(sensorDeviceUuid: string, typeName: string, hardwareError: boolean, lowBattery: boolean) {
		this.sensorDeviceUuid = sensorDeviceUuid;
		this.typeName = typeName;
		this.hardwareError = hardwareError;
		this.lowBattery = lowBattery;
	}

	abstract getJson(): string;
}

export default Measurement;
