import '../../../../core/result.dart';
import '../entities/launch.dart';
import '../repositories/spacex_repository.dart';

class GetLatestLaunch {
  final SpaceXRepository repo;
  GetLatestLaunch(this.repo);
  Future<Result<Launch>> call() => repo.getLatestLaunch();
}
