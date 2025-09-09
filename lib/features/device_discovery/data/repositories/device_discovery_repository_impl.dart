import 'package:dartz/dartz.dart';
import 'package:roku_remote/core/failures.dart';
import 'package:roku_remote/features/device_discovery/data/datasources/device_discovery_datasource.dart';
import 'package:roku_remote/features/device_discovery/domain/entities/roku_device.dart';
import 'package:roku_remote/features/device_discovery/domain/repositories/device_discovery_repository.dart';

class DeviceDiscoveryRepositoryImpl implements DeviceDiscoveryRepository {
  final DeviceDiscoveryDataSource dataSource;

  DeviceDiscoveryRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<RokuDevice>>> discoverDevices() async {
    try {
      final deviceModels = await dataSource.discoverDevices();
      // The models are already entities, so we can return them directly.
      return Right(deviceModels);
    } on Exception { // Assuming the datasource throws a generic Exception for now
      return Left(ServerFailure());
    }
  }
}