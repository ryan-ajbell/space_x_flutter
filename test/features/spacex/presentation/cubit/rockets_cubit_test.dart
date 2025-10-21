import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_project_v2/core/result.dart';
import 'package:test_project_v2/features/spacex/domain/entities/space_x_rocket.dart';
import 'package:test_project_v2/features/spacex/domain/repositories/spacex_repository.dart';
import 'package:test_project_v2/features/spacex/domain/usecases/get_rockets.dart';
import 'package:test_project_v2/features/spacex/presentation/cubit/rockets_cubit.dart';

class _RepoFake implements SpaceXRepository {
  final Result<List<SpaceXRocket>> rocketsResult;
  _RepoFake(this.rocketsResult);
  @override
  Future<Result<List<SpaceXRocket>>> getRockets() async => rocketsResult;
  @override
  Future<Result<List<dynamic>>> getLaunches({int limit = 20}) {
    throw UnimplementedError();
  }

  @override
  Future<Result<dynamic>> getLatestLaunch() {
    throw UnimplementedError();
  }
}

void main() {
  final rockets = [
    SpaceXRocket(
      id: 'falcon9',
      name: 'Falcon 9',
      type: 'rocket',
      description: 'Reusable rocket',
      stages: 2,
      boosters: 0,
      active: true,
      costPerLaunch: 50000000,
      successRatePct: 97,
      firstFlight: DateTime(2010, 6, 4),
      country: 'USA',
      company: 'SpaceX',
      flickrImages: const [],
    ),
  ];

  blocTest<RocketsCubit, RocketsState>(
    'emits loading then data on success',
    build: () => RocketsCubit(GetRockets(_RepoFake(Success(rockets)))),
    act: (cubit) => cubit.load(),
    expect: () => [
      const RocketsState(loading: true),
      RocketsState(loading: false, rockets: rockets),
    ],
  );

  blocTest<RocketsCubit, RocketsState>(
    'emits loading then error on failure',
    build: () => RocketsCubit(
      GetRockets(_RepoFake(const FailureResult(Failure('err')))),
    ),
    act: (cubit) => cubit.load(),
    expect: () => [
      const RocketsState(loading: true),
      const RocketsState(loading: false, error: 'err'),
    ],
  );
}
