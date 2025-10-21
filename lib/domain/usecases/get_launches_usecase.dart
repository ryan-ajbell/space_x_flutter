import '../../data/repositories/launch_repository.dart';
import '../entities/launch.dart';

// Use case for getting launches
class GetLaunchesUseCase {
  final LaunchRepository repository;

  GetLaunchesUseCase(this.repository);

  Future<List<Launch>> execute({Map<String, dynamic>? query}) async {
    return await repository.getRocketLaunches(query: query);
  }
}
