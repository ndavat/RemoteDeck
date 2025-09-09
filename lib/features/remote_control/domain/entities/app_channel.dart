import 'package:equatable/equatable.dart';

/// Represents an installed channel on a Roku device.
class AppChannel extends Equatable {
  final String id;
  final String name;
  final String type;
  final String version;

  const AppChannel({
    required this.id,
    required this.name,
    required this.type,
    required this.version,
  });

  @override
  List<Object?> get props => [id, name, type, version];
}