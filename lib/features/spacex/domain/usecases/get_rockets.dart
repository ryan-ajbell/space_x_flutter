import '../../../../core/result.dart';
import '../entities/space_x_rocket.dart';
import '../repositories/spacex_repository.dart';

class GetRockets {
  final SpaceXRepository repo;
  GetRockets(this.repo);
  Future<Result<List<SpaceXRocket>>> call() => repo.getRockets();
}
