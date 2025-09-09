import 'package:dartz/dartz.dart';
import 'package:roku_remote/core/failures.dart';
import 'package:roku_remote/features/remote_control/domain/entities/app_channel.dart';

/// Abstract repository for interacting with a Roku device via ECP.
abstract class RokuRepository {
  /// Sends a keypress command to the Roku device.
  Future<Either<Failure, void>> sendKeypress(String key);

  /// Launches a channel on the Roku device.
  Future<Either<Failure, void>> launchChannel(String channelId);

  /// Queries the list of installed channels on the Roku device.
  Future<Either<Failure, List<AppChannel>>> getChannels();

  /// Sends a string of text to the Roku device.
  Future<Either<Failure, void>> sendText(String text);
}