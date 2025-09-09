import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roku_remote/features/device_discovery/presentation/riverpod/providers.dart';
import 'package:roku_remote/features/remote_control/presentation/riverpod/providers.dart';

class ChannelsScreen extends ConsumerWidget {
  const ChannelsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelsAsyncValue = ref.watch(channelsProvider);
    final selectedDevice = ref.watch(selectedDeviceProvider);

    // This should not happen if the UI flow is correct, but it's a good safeguard.
    if (selectedDevice == null) {
      return const Scaffold(
        body: Center(child: Text('No device selected.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Channels'),
      ),
      body: channelsAsyncValue.when(
        data: (eitherResult) {
          return eitherResult.fold(
            (failure) => const Center(child: Text('Failed to load channels.')),
            (channels) {
              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: channels.length,
                itemBuilder: (context, index) {
                  final channel = channels[index];
                  final iconUrl = 'http://${selectedDevice.ipAddress}:8060/query/icon/${channel.id}';

                  return GestureDetector(
                    onTap: () {
                      // Launch the channel
                      ref.read(rokuRepositoryProvider).launchChannel(channel.id);
                      // Optionally, provide feedback
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Launching ${channel.name}...')),
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl: iconUrl,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}