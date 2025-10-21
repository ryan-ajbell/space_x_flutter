import '../../data/repositories/launch_repository.dart';
import '../entities/launch.dart';

class GetLatestLaunchUseCase {
  final LaunchRepository repository;
  GetLatestLaunchUseCase(this.repository);
  Future<Launch> execute() => repository.getLatestLaunch();
}
