import 'dart:typed_data';

class PowerSourcesData {
  final double batteryVoltage;
  final double batteryCurrent;
  final bool batteryOn;
  final bool rechargingAvailable;
  final bool dischargingAvailable;
  final bool fuelCellOn;
  final double fuelCellVoltage;
  final double fuelCellCurrent;
  final double fuelCellTemp;
  final int hydrogenConsumption;
  final double hydrogenPressure;

  PowerSourcesData(
      {this.batteryVoltage,
      this.batteryCurrent,
      this.batteryOn,
      this.rechargingAvailable,
      this.dischargingAvailable,
      this.fuelCellCurrent,
      this.fuelCellOn,
      this.fuelCellTemp,
      this.fuelCellVoltage,
      this.hydrogenConsumption,
      this.hydrogenPressure});

  factory PowerSourcesData.fromBuffer(Uint8List buffer) {
    return PowerSourcesData(
      batteryVoltage: ((buffer[0] << 8) + buffer[1]) / 1000,
      batteryCurrent: ((buffer[2] << 8) + buffer[3]) / 1000,
      batteryOn: buffer[18] as bool,
      rechargingAvailable: buffer[4] as bool,
      dischargingAvailable: buffer[5] as bool,
      fuelCellVoltage: ((buffer[6] << 8) + buffer[7]) / 1000,
      fuelCellCurrent: ((buffer[8] << 8) + buffer[9]) / 1000,
      fuelCellTemp: ((buffer[10] << 8) + buffer[11]) / 10,
      fuelCellOn: buffer[13] as bool,
      hydrogenConsumption: ((buffer[14] << 8) + buffer[15]),
      hydrogenPressure: ((buffer[16] << 8) + buffer[17]) as double,
    );
  }
}
