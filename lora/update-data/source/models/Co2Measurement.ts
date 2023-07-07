import Measurement from "./measurement";

class Co2Measurement extends Measurement {
    co2: number;
    humidity: number;
    temperature: number;
   

    constructor(
        sensorDeviceUuid: string,
        co2: number,
        humidity: number,
        temperature: number,
        hardwareError: boolean,
        lowBattery: boolean,
    ) {
        super(sensorDeviceUuid, "comfortCo2",hardwareError, lowBattery);
        this.co2 = co2;
        this.humidity = humidity;
        this.temperature = temperature;
    }

    getJson(): string {
        const data = {
            data:{
                co2: this.co2,
                humidity: this.humidity,
                temperature: this.temperature,
                hardwareError: this.hardwareError,
                lowBattery: this.lowBattery
            }
          };
          
          const jsonData = {
            [this.sensorDeviceUuid]: data
          };
          
          return JSON.stringify(jsonData);
    }
}

export default Co2Measurement;