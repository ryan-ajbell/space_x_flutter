import '../../../../core/result.dart';
import '../../domain/entities/launch.dart';
import '../../domain/entities/space_x_rocket.dart';
import '../../domain/repositories/spacex_repository.dart';
import '../datasources/spacex_remote_data_source.dart';

class SpaceXRepositoryImpl implements SpaceXRepository {
  final SpaceXRemoteDataSource remote;
  SpaceXRepositoryImpl(this.remote);

  @override
  Future<Result<List<SpaceXRocket>>> getRockets() => remote.fetchRockets();

  @override
  Future<Result<List<Launch>>> getLaunches({int limit = 20}) =>
      remote.fetchLaunches(limit: limit);

  @override
  Future<Result<Launch>> getLatestLaunch() => remote.fetchLatestLaunch();
}
