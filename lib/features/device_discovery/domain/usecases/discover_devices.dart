import 'package:dartz/dartz.dart';
import 'package:roku_remote/core/failures.dart';
import 'package:roku_remote/features/device_discovery/domain/entities/roku_device.dart';
import 'package:roku_remote/features/device_discovery/domain/repositories/device_discovery_repository.dart';

class DiscoverDevices {
  final DeviceDiscoveryRepository repository;

  DiscoverDevices(this.repository);

  Future<Either<Failure, List<RokuDevice>>> call() async {
    return await repository.discoverDevices();
  }
}