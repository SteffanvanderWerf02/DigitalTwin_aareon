/* A Sensor is a device that has a device_uuid, name, battery, roomId, and description. */
class Sensor {
	deviceUuid: string;
	name: string;
	battery: number;
	roomId: number;
	description: string;
    updatedAt: Date | undefined;
    createdAt: Date | undefined;

	constructor(deviceUuid: string, name: string, battery: number, roomId: number, description: string) {
		this.deviceUuid = deviceUuid;
		this.name = name;
		this.battery = battery;
		this.roomId = roomId;
		this.description = description;
	}
}

export default Sensor;
