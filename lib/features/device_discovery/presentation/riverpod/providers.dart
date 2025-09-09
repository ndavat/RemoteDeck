import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:roku_remote/features/device_discovery/data/datasources/device_discovery_datasource.dart';
import 'package:roku_remote/features/device_discovery/data/datasources/device_discovery_datasource_impl.dart';
import 'package:roku_remote/features/device_discovery/data/repositories/device_discovery_repository_impl.dart';
import 'package:roku_remote/features/device_discovery/domain/entities/roku_device.dart';
import 'package:roku_remote/features/device_discovery/domain/repositories/device_discovery_repository.dart';
import 'package:roku_remote/features/device_discovery/domain/usecases/discover_devices.dart';

// 1. Data Source Provider
final deviceDiscoveryDataSourceProvider = Provider<DeviceDiscoveryDataSource>((ref) {
  return DeviceDiscoveryDataSourceImpl(client: http.Client());
});

// 2. Repository Provider
final deviceDiscoveryRepositoryProvider = Provider<DeviceDiscoveryRepository>((ref) {
  final dataSource = ref.watch(deviceDiscoveryDataSourceProvider);
  return DeviceDiscoveryRepositoryImpl(dataSource: dataSource);
});

// 3. Use Case Provider
final discoverDevicesProvider = Provider<DiscoverDevices>((ref) {
  final repository = ref.watch(deviceDiscoveryRepositoryProvider);
  return DiscoverDevices(repository);
});

// 4. StateNotifier for Discovered Devices
final discoveredDevicesProvider = StateNotifierProvider<DiscoveredDevicesNotifier, AsyncValue<List<RokuDevice>>>((ref) {
  final discoverDevices = ref.watch(discoverDevicesProvider);
  return DiscoveredDevicesNotifier(discoverDevices);
});

class DiscoveredDevicesNotifier extends StateNotifier<AsyncValue<List<RokuDevice>>> {
  final DiscoverDevices _discoverDevices;

  DiscoveredDevicesNotifier(this._discoverDevices) : super(const AsyncValue.loading()) {
    findDevices();
  }

  Future<void> findDevices() async {
    state = const AsyncValue.loading();
    final result = await _discoverDevices();
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (devices) => state = AsyncValue.data(devices),
    );
  }
}

// 5. Provider for the currently selected device
final selectedDeviceProvider = StateProvider<RokuDevice?>((ref) => null);