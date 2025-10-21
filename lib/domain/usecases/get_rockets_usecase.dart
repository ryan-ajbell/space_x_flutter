import '../../data/repositories/rocket_repository.dart';
import '../entities/rocket.dart';

// Use case for getting rockets
class GetRocketsUseCase {
  final RocketRepository repository;

  GetRocketsUseCase(this.repository);

  Future<List<SpaceXRocket>> execute() async {
    return await repository.getRockets();
  }
}
