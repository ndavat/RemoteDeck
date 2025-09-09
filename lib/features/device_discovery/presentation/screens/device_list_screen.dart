import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roku_remote/features/device_discovery/presentation/riverpod/providers.dart';
import 'package:roku_remote/features/remote_control/presentation/screens/remote_screen.dart';

class DeviceListScreen extends ConsumerWidget {
  const DeviceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesAsyncValue = ref.watch(discoveredDevicesProvider);
    final selectedDevice = ref.watch(selectedDeviceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Roku Device'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(discoveredDevicesProvider.notifier).findDevices();
            },
          ),
        ],
      ),
      body: devicesAsyncValue.when(
        data: (devices) {
          if (devices.isEmpty) {
            return const Center(
              child: Text('No Roku devices found. Pull down to refresh.'),
            );
          }
          return ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
              return ListTile(
                title: Text(device.name),
                subtitle: Text(device.ipAddress),
                trailing: selectedDevice?.id == device.id
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : null,
                onTap: () {
                  // Set the selected device globally
                  ref.read(selectedDeviceProvider.notifier).state = device;
                  // Navigate to the remote control screen
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const RemoteScreen(),
                  ));
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error discovering devices: $error'),
        ),
      ),
    );
  }
}