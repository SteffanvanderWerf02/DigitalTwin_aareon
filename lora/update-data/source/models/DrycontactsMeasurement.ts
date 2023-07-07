import e from "express";
import Measurement from "./measurement";

class DryContactMeasurement extends Measurement {
    channelValue: number;
    currentState: boolean;
    previousFrameState: boolean;

    constructor(
        sensorDeviceUuid: string,
        channelValue: number,
        currentState: boolean,
        previousFrameState: boolean,
        hardwareError: boolean,
        lowBattery: boolean,
    ) {
        super(sensorDeviceUuid, "dryContact",hardwareError, lowBattery);
        this.channelValue = channelValue;
        this.currentState = currentState;
        this.previousFrameState = previousFrameState;
    }

    getJson(): string {
        const data = {
            data: {
                channelValue: this.channelValue,
                currentState: this.currentState,
                previousFrameState: this.previousFrameState,
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
export default DryContactMeasurement;