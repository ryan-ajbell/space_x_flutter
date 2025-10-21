import '../../../../core/result.dart';
import '../entities/launch.dart';
import '../repositories/spacex_repository.dart';

class GetLaunches {
  final SpaceXRepository repo;
  GetLaunches(this.repo);
  Future<Result<List<Launch>>> call({int limit = 20}) =>
      repo.getLaunches(limit: limit);
}
