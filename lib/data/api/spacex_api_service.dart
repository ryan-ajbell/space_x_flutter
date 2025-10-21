import 'dart:convert';

import 'package:http/http.dart' as http;

import '../dto/launch_dto.dart';
import '../dto/rocket_dto.dart';

class SpaceXApiService {
  static const _baseV4 = 'https://api.spacexdata.com/v4';
  static const _baseV5 = 'https://api.spacexdata.com/v5';

  Future<List<RocketDto>> getRockets() async {
    final res = await http.get(Uri.parse('$_baseV4/rockets'));
    if (res.statusCode != 200)
      throw Exception('Rockets error: ${res.statusCode}');
    final list = jsonDecode(res.body) as List<dynamic>;
    return list
        .map((e) => RocketDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<LaunchDto>> queryLaunches({Map<String, dynamic>? query}) async {
    final body = jsonEncode(
      query ??
          {
            "query": {},
            "options": {
              "limit": 20,
              "sort": {"date_utc": -1},
            },
          },
    );
    final res = await http.post(
      Uri.parse('$_baseV4/launches/query'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (res.statusCode != 200)
      throw Exception('Launch query error: ${res.statusCode}');
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    final docs = map['docs'] as List<dynamic>;
    return docs
        .map((e) => LaunchDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<LaunchDto> getLatestLaunch() async {
    final res = await http.get(Uri.parse('$_baseV5/launches/latest'));
    if (res.statusCode != 200)
      throw Exception('Latest launch error: ${res.statusCode}');
    return LaunchDto.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }
}
