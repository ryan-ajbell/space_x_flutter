import '../../domain/entities/launch.dart';
import '../api/spacex_api_service.dart';
import '../dto/launch_dto.dart';

abstract class LaunchRepository {
  Future<List<Launch>> getRocketLaunches({Map<String, dynamic>? query});
  Future<Launch> getLatestLaunch();
}

class LaunchRepositoryImpl implements LaunchRepository {
  final SpaceXApiService api;
  LaunchRepositoryImpl(this.api);

  @override
  Future<List<Launch>> getRocketLaunches({Map<String, dynamic>? query}) async {
    final dtos = await api.queryLaunches(query: query);
    return dtos.map(_map).toList();
  }

  @override
  Future<Launch> getLatestLaunch() async => _map(await api.getLatestLaunch());

  Launch _map(LaunchDto d) => Launch(
    id: d.id,
    name: d.name,
    flightNumber: d.flight_number,
    dateUtc: DateTime.parse(d.date_utc),
    success: d.success, // nullable safe
    rocketId: d.rocket,
    details: d.details,
    flickrImages: d.flickr_images,
  );
}
