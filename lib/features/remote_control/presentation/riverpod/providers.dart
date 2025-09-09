import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:roku_remote/features/device_discovery/presentation/riverpod/providers.dart';
import 'package:roku_remote/features/remote_control/data/repositories/roku_repository_impl.dart';
import 'package:roku_remote/features/remote_control/domain/repositories/roku_repository.dart';
import 'package:roku_remote/features/remote_control/domain/usecases/get_channels.dart';
import 'package:roku_remote/features/remote_control/domain/usecases/send_keypress.dart';

// This provider is the key to connecting the selected device to the repository.
// It watches the selectedDeviceProvider. If a device is selected, it creates
// a RokuRepositoryImpl with the correct IP address. Otherwise, it throws.
final rokuRepositoryProvider = Provider<RokuRepository>((ref) {
  final selectedDevice = ref.watch(selectedDeviceProvider);
  if (selectedDevice != null) {
    return RokuRepositoryImpl(
      client: http.Client(),
      rokuIpAddress: selectedDevice.ipAddress,
    );
  }
  // The UI should prevent actions if no device is selected, so this is a
  // safeguard.
  throw Exception('No Roku device selected.');
});

// Use Case Providers
final sendKeypressProvider = Provider<SendKeypress>((ref) {
  final repository = ref.watch(rokuRepositoryProvider);
  return SendKeypress(repository);
});

final getChannelsProvider = Provider<GetChannels>((ref) {
  final repository = ref.watch(rokuRepositoryProvider);
  return GetChannels(repository);
});

// Provider to fetch channels, which can be used by the UI.
final channelsProvider = FutureProvider.autoDispose((ref) {
  final getChannels = ref.watch(getChannelsProvider);
  return getChannels();
});