import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'features/spacex/data/datasources/spacex_remote_data_source.dart';
import 'features/spacex/data/repositories/spacex_repository_impl.dart';
import 'features/spacex/domain/repositories/spacex_repository.dart';
import 'features/spacex/domain/usecases/get_latest_launch.dart';
import 'features/spacex/domain/usecases/get_launches.dart';
import 'features/spacex/domain/usecases/get_rockets.dart';
import 'features/spacex/presentation/cubit/latest_launch_cubit.dart';
import 'features/spacex/presentation/cubit/launches_cubit.dart';
import 'features/spacex/presentation/cubit/rockets_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Data sources
  sl.registerLazySingleton(() => SpaceXRemoteDataSource(sl()));

  // Repository
  sl.registerLazySingleton<SpaceXRepository>(() => SpaceXRepositoryImpl(sl()));

  // Use cases
  sl.registerLazySingleton(() => GetRockets(sl()));
  sl.registerLazySingleton(() => GetLaunches(sl()));
  sl.registerLazySingleton(() => GetLatestLaunch(sl()));

  // Cubits
  sl.registerFactory(() => RocketsCubit(sl()));
  sl.registerFactory(() => LaunchesCubit(sl()));
  sl.registerFactory(() => LatestLaunchCubit(sl()));
}
