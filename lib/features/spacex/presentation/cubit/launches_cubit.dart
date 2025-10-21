import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/launch.dart';
import '../../domain/usecases/get_launches.dart';

class LaunchesState extends Equatable {
  final bool loading;
  final List<Launch> launches;
  final String? error;
  final bool loadingMore;
  final int limit;
  const LaunchesState({
    this.loading = false,
    this.launches = const [],
    this.error,
    this.loadingMore = false,
    this.limit = 20,
  });
  LaunchesState copyWith({
    bool? loading,
    List<Launch>? launches,
    String? error,
    bool? loadingMore,
    int? limit,
  }) => LaunchesState(
    loading: loading ?? this.loading,
    launches: launches ?? this.launches,
    error: error,
    loadingMore: loadingMore ?? this.loadingMore,
    limit: limit ?? this.limit,
  );
  @override
  List<Object?> get props => [loading, launches, error, loadingMore, limit];
}

class LaunchesCubit extends Cubit<LaunchesState> {
  final GetLaunches getLaunches;
  LaunchesCubit(this.getLaunches) : super(const LaunchesState());

  Future<void> load({int limit = 20}) async {
    emit(state.copyWith(loading: true, error: null, limit: limit));
    final res = await getLaunches(limit: limit);
    res.when(
      success: (data) =>
          emit(state.copyWith(loading: false, launches: data, error: null)),
      failure: (f) => emit(state.copyWith(loading: false, error: f.message)),
    );
  }

  Future<void> loadMore({int step = 20}) async {
    if (state.loadingMore || state.loading) return;
    final newLimit = state.limit + step;
    emit(state.copyWith(loadingMore: true, limit: newLimit));
    final res = await getLaunches(limit: newLimit);
    res.when(
      success: (data) =>
          emit(state.copyWith(loadingMore: false, launches: data)),
      failure: (f) => emit(
        state.copyWith(
          loadingMore: false,
          error: f.message,
          limit: state.limit - step,
        ),
      ),
    );
  }
}
