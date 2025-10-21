import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/result.dart';
import '../../domain/entities/launch.dart';
import '../../domain/entities/space_x_rocket.dart';
import '../models/launch_model.dart';
import '../models/rocket_model.dart';

class SpaceXRemoteDataSource {
  final http.Client client;
  static const _baseV4 = 'https://api.spacexdata.com/v4';
  static const _baseV5 = 'https://api.spacexdata.com/v5';

  const SpaceXRemoteDataSource(this.client);

  Future<Result<List<SpaceXRocket>>> fetchRockets() async {
    try {
      final res = await client.get(Uri.parse('$_baseV4/rockets'));
      if (res.statusCode == 200) {
        final list = (jsonDecode(res.body) as List)
            .map(
              (e) => RocketModel.fromJson(e as Map<String, dynamic>).toEntity(),
            )
            .toList(growable: false);
        return Success(list);
      }
      return FailureResult(
        Failure('Rockets error: ${res.statusCode}', statusCode: res.statusCode),
      );
    } catch (e) {
      return FailureResult(Failure(e.toString()));
    }
  }

  Future<Result<List<Launch>>> fetchLaunches({int limit = 20}) async {
    try {
      final body = jsonEncode({
        'options': {
          'limit': limit,
          'sort': {'date_utc': 'desc'},
        },
      });
      final res = await client.post(
        Uri.parse('$_baseV4/launches/query'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body) as Map<String, dynamic>;
        final docs = decoded['docs'] as List;
        final launches = docs
            .map(
              (e) => LaunchModel.fromJson(e as Map<String, dynamic>).toEntity(),
            )
            .toList(growable: false);
        return Success(launches);
      }
      return FailureResult(
        Failure(
          'Launches error: ${res.statusCode}',
          statusCode: res.statusCode,
        ),
      );
    } catch (e) {
      return FailureResult(Failure(e.toString()));
    }
  }

  Future<Result<Launch>> fetchLatestLaunch() async {
    try {
      final res = await client.get(Uri.parse('$_baseV5/launches/latest'));
      if (res.statusCode == 200) {
        final launch = LaunchModel.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>,
        ).toEntity();
        return Success(launch);
      }
      return FailureResult(
        Failure(
          'Latest launch error: ${res.statusCode}',
          statusCode: res.statusCode,
        ),
      );
    } catch (e) {
      return FailureResult(Failure(e.toString()));
    }
  }
}
