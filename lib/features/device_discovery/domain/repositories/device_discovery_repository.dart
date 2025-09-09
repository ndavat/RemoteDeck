import 'package:dartz/dartz.dart';
import '../../../../core/failures.dart';
import '../entities/roku_device.dart';

/// Abstract repository for discovering Roku devices on the network.
abstract class DeviceDiscoveryRepository {
  /// Scans the local network for Roku devices using SSDP.
  ///
  /// Returns a [Future] that completes with a [Either] containing
  /// a [List] of [RokuDevice] on success, or a [Failure] on error.
  Future<Either<Failure, List<RokuDevice>>> discoverDevices();
}