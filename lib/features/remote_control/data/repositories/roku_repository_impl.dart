import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:roku_remote/core/failures.dart';
import 'package:roku_remote/features/remote_control/data/models/app_channel_model.dart';
import 'package:roku_remote/features/remote_control/domain/entities/app_channel.dart';
import 'package:roku_remote/features/remote_control/domain/repositories/roku_repository.dart';
import 'package:xml/xml.dart';

class ServerException implements Exception {}

class RokuRepositoryImpl implements RokuRepository {
  final http.Client client;
  // The IP address will be provided by a state management solution (Riverpod).
  // For now, we require it in the constructor.
  final String rokuIpAddress;

  RokuRepositoryImpl({required this.client, required this.rokuIpAddress});

  String get _baseUrl => 'http://$rokuIpAddress:8060';

  @override
  Future<Either<Failure, void>> sendKeypress(String key) async {
    try {
      final response = await client.post(Uri.parse('$_baseUrl/keypress/$key'));
      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> launchChannel(String channelId) async {
    try {
      final response = await client.post(Uri.parse('$_baseUrl/launch/$channelId'));
      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<AppChannel>>> getChannels() async {
    try {
      final response = await client.get(Uri.parse('$_baseUrl/query/apps'));
      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);
        final channels = document.findAllElements('app').map((node) {
          return AppChannelModel.fromXmlElement(node);
        }).toList();
        return Right(channels);
      } else {
        return Left(ServerFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> sendText(String text) async {
    try {
      for (final char in text.split('')) {
        final response = await client.post(Uri.parse('$_baseUrl/keypress/Lit_${Uri.encodeComponent(char)}'));
        if (response.statusCode != 200) {
          return Left(ServerFailure());
        }
      }
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}