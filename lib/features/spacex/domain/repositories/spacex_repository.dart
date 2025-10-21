import '../../../../core/result.dart';
import '../entities/launch.dart';
import '../entities/space_x_rocket.dart';

abstract class SpaceXRepository {
  Future<Result<List<SpaceXRocket>>> getRockets();
  Future<Result<List<Launch>>> getLaunches({int limit});
  Future<Result<Launch>> getLatestLaunch();
}
