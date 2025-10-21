import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/space_x_rocket.dart';
import '../../domain/usecases/get_rockets.dart';

class RocketsState extends Equatable {
  final bool loading;
  final List<SpaceXRocket> rockets;
  final String? error;
  const RocketsState({
    this.loading = false,
    this.rockets = const [],
    this.error,
  });
  RocketsState copyWith({
    bool? loading,
    List<SpaceXRocket>? rockets,
    String? error,
  }) => RocketsState(
    loading: loading ?? this.loading,
    rockets: rockets ?? this.rockets,
    error: error,
  );
  @override
  List<Object?> get props => [loading, rockets, error];
}

class RocketsCubit extends Cubit<RocketsState> {
  final GetRockets getRockets;
  RocketsCubit(this.getRockets) : super(const RocketsState());

  Future<void> load() async {
    emit(state.copyWith(loading: true, error: null));
    final res = await getRockets();
    res.when(
      success: (data) =>
          emit(state.copyWith(loading: false, rockets: data, error: null)),
      failure: (f) => emit(state.copyWith(loading: false, error: f.message)),
    );
  }
}
