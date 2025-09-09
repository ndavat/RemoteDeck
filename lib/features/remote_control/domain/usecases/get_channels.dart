import 'package:dartz/dartz.dart';
import 'package:roku_remote/core/failures.dart';
import 'package:roku_remote/features/remote_control/domain/entities/app_channel.dart';
import 'package:roku_remote/features/remote_control/domain/repositories/roku_repository.dart';

class GetChannels {
  final RokuRepository repository;

  GetChannels(this.repository);

  Future<Either<Failure, List<AppChannel>>> call() async {
    return await repository.getChannels();
  }
}