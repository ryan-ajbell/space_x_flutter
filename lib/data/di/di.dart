import '../api/spacex_api_service.dart';
import '../repositories/launch_repository.dart';
import '../repositories/rocket_repository.dart';

// Simple manual DI singletons
final SpaceXApiService spaceXApiService = SpaceXApiService();
final RocketRepository rocketRepository = RocketRepositoryImpl(
  spaceXApiService,
);
final LaunchRepository launchRepository = LaunchRepositoryImpl(
  spaceXApiService,
);
