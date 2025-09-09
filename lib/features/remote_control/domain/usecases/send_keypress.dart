import 'package:dartz/dartz.dart';
import 'package:roku_remote/core/failures.dart';
import 'package:roku_remote/features/remote_control/domain/repositories/roku_repository.dart';

class SendKeypress {
  final RokuRepository repository;

  SendKeypress(this.repository);

  Future<Either<Failure, void>> call(String key) async {
    return await repository.sendKeypress(key);
  }
}