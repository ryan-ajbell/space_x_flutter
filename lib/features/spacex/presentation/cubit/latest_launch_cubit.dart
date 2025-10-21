import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/launch.dart';
import '../../domain/usecases/get_latest_launch.dart';

class LatestLaunchState extends Equatable {
  final bool loading;
  final Launch? launch;
  final String? error;
  const LatestLaunchState({this.loading = false, this.launch, this.error});
  LatestLaunchState copyWith({bool? loading, Launch? launch, String? error}) =>
      LatestLaunchState(
        loading: loading ?? this.loading,
        launch: launch ?? this.launch,
        error: error,
      );
  @override
  List<Object?> get props => [loading, launch, error];
}

class LatestLaunchCubit extends Cubit<LatestLaunchState> {
  final GetLatestLaunch getLatestLaunch;
  LatestLaunchCubit(this.getLatestLaunch) : super(const LatestLaunchState());

  Future<void> load() async {
    emit(state.copyWith(loading: true, error: null));
    final res = await getLatestLaunch();
    res.when(
      success: (data) => emit(state.copyWith(loading: false, launch: data)),
      failure: (f) => emit(state.copyWith(loading: false, error: f.message)),
    );
  }
}
