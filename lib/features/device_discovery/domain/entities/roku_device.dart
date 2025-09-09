import 'package:equatable/equatable.dart';

/// Represents a Roku device discovered on the network.
class RokuDevice extends Equatable {
  final String id;
  final String ipAddress;
  final String name;
  final String model;

  const RokuDevice({
    required this.id,
    required this.ipAddress,
    required this.name,
    required this.model,
  });

  @override
  List<Object?> get props => [id, ipAddress, name, model];
}