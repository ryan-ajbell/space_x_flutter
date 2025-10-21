import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_project_v2/core/result.dart';
import 'package:test_project_v2/features/spacex/domain/entities/launch.dart';
import 'package:test_project_v2/features/spacex/domain/entities/space_x_rocket.dart';
import 'package:test_project_v2/features/spacex/domain/repositories/spacex_repository.dart';
import 'package:test_project_v2/features/spacex/domain/usecases/get_launches.dart';
import 'package:test_project_v2/features/spacex/presentation/cubit/launches_cubit.dart';

class _RepoFake implements SpaceXRepository {
  final Result<List<Launch>> launchesResult;
  _RepoFake(this.launchesResult);
  @override
  Future<Result<List<Launch>>> getLaunches({int limit = 20}) async =>
      launchesResult;
  @override
  Future<Result<List<SpaceXRocket>>> getRockets() {
    throw UnimplementedError();
  }

  @override
  Future<Result<Launch>> getLatestLaunch() {
    throw UnimplementedError();
  }
}

void main() {
  final launches = [
    Launch(
      id: 'l1',
      name: 'CRS-1',
      flightNumber: 1,
      dateUtc: DateTime(2020, 1, 1),
      success: true,
      rocketId: 'falcon9',
      details: 'First cargo',
      flickrImages: const [],
    ),
  ];

  blocTest<LaunchesCubit, LaunchesState>(
    'load emits loading then data',
    build: () => LaunchesCubit(GetLaunches(_RepoFake(Success(launches)))),
    act: (cubit) => cubit.load(limit: 20),
    expect: () => [
      const LaunchesState(loading: true, limit: 20),
      LaunchesState(loading: false, launches: launches, limit: 20),
    ],
  );

  blocTest<LaunchesCubit, LaunchesState>(
    'load emits error on failure',
    build: () => LaunchesCubit(
      GetLaunches(_RepoFake(const FailureResult(Failure('err')))),
    ),
    act: (cubit) => cubit.load(limit: 10),
    expect: () => [
      const LaunchesState(loading: true, limit: 10),
      const LaunchesState(loading: false, error: 'err', limit: 10),
    ],
  );
}
