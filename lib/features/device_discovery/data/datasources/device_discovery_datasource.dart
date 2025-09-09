import '../models/roku_device_model.dart';

/// Abstract data source for discovering Roku devices.
abstract class DeviceDiscoveryDataSource {
  /// Scans the local network for Roku devices.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<RokuDeviceModel>> discoverDevices();
}