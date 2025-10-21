import 'dart:math' as math; // added for potential layout calculations

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/spacex/domain/entities/launch.dart';
import '../../features/spacex/presentation/cubit/latest_launch_cubit.dart';
import '../../features/spacex/presentation/cubit/launches_cubit.dart';
import '../../features/spacex/presentation/cubit/rockets_cubit.dart';
import '../theme/space_theme.dart';
import '../widgets/launch_card.dart';
import '../widgets/rocket_card.dart';
import '../widgets/section_title.dart';
import '../widgets/stats_header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      final v = _searchCtrl.text.trim();
      if (v != _query) setState(() => _query = v);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  bool _matches(String haystack) =>
      _query.isEmpty || haystack.toLowerCase().contains(_query.toLowerCase());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('SpaceX Explorer'),
        backgroundColor: Colors.black.withValues(alpha: 0.2),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<RocketsCubit>().load();
              context.read<LaunchesCubit>().load();
              context.read<LatestLaunchCubit>().load();
            },
          ),
        ],
      ),
      body: StarfieldBackground(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              context.read<RocketsCubit>().load(),
              context.read<LaunchesCubit>().load(),
              context.read<LatestLaunchCubit>().load(),
            ]);
          },
          child: Builder(
            builder: (context) {
              final topInset = MediaQuery.of(context).padding.top;
              final topPadding =
                  topInset +
                  kToolbarHeight +
                  16; // status bar + app bar + spacing
              return ListView(
                padding: EdgeInsets.fromLTRB(16, topPadding, 16, 32),
                children: [
                  const StatsHeader(),
                  const SizedBox(height: 24),
                  _buildSearchBar(context),
                  const SizedBox(height: 32),
                  const SectionTitle(
                    'Latest Launch',
                    icon: Icons.rocket_launch,
                  ),
                  BlocBuilder<LatestLaunchCubit, LatestLaunchState>(
                    builder: (context, state) {
                      if (state.loading) {
                        return const _LoadingBlock();
                      }
                      if (state.error != null) {
                        return _ErrorRetry(
                          message: state.error!,
                          onRetry: () =>
                              context.read<LatestLaunchCubit>().load(),
                        );
                      }
                      final launch = state.launch;
                      if (launch == null) return const Text('No data');
                      return LaunchCard(launch: launch);
                    },
                  ),
                  const SizedBox(height: 32),
                  const SectionTitle('Rockets', icon: Icons.fire_truck),
                  BlocBuilder<RocketsCubit, RocketsState>(
                    builder: (context, state) {
                      if (state.loading) return const _LoadingBlock();
                      if (state.error != null) {
                        return _ErrorRetry(
                          message: state.error!,
                          onRetry: () => context.read<RocketsCubit>().load(),
                        );
                      }
                      var list = state.rockets;
                      if (_query.isNotEmpty) {
                        list = list
                            .where(
                              (r) =>
                                  _matches(r.name) ||
                                  _matches(r.country) ||
                                  _matches(r.company),
                            )
                            .toList();
                      }
                      if (list.isEmpty) return const Text('No rockets');
                      final width = MediaQuery.of(context).size.width;
                      final isWide = width > 700;
                      if (!isWide) {
                        return Column(
                          children: list
                              .map((r) => RocketCard(rocket: r))
                              .toList(growable: false),
                        );
                      }
                      final crossAxisCount = math.min(4, (width / 320).floor());
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount.clamp(2, 6),
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.95,
                        ),
                        itemCount: list.length,
                        itemBuilder: (c, i) => RocketCard(rocket: list[i]),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  const SectionTitle('Recent Launches', icon: Icons.history),
                  BlocBuilder<LaunchesCubit, LaunchesState>(
                    builder: (context, state) {
                      var launches = state.launches;
                      if (_query.isNotEmpty) {
                        launches = launches
                            .where(
                              (l) => _matches(l.name) || _matches(l.rocketId),
                            )
                            .toList();
                      }
                      return RecentLaunchesBlock(
                        loading: state.loading,
                        error: state.error,
                        launches: launches,
                        onRetry: () => context.read<LaunchesCubit>().load(),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) => TextField(
    controller: _searchCtrl,
    decoration: InputDecoration(
      hintText: 'Search rockets & launches...',
      filled: true,
      fillColor: SpaceColors.card.withValues(alpha: 0.6),
      prefixIcon: const Icon(Icons.search),
      suffixIcon: _query.isNotEmpty
          ? IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.close),
              onPressed: () {
                _searchCtrl.clear();
                setState(() => _query = '');
              },
            )
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: SpaceColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: SpaceColors.border),
      ),
    ),
  );
}

class _LoadingBlock extends StatelessWidget {
  const _LoadingBlock();
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 24.0),
    child: Center(
      child: SizedBox(
        height: 42,
        width: 42,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation(SpaceColors.accentBlue),
        ),
      ),
    ),
  );
}

class _ErrorRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorRetry({required this.message, required this.onRetry});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(message, style: const TextStyle(color: Colors.red)),
        TextButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text('Retry'),
        ),
      ],
    ),
  );
}

class RecentLaunchesBlock extends StatelessWidget {
  final bool loading;
  final String? error;
  final List<Launch> launches;
  final VoidCallback onRetry;
  const RecentLaunchesBlock({
    super.key,
    required this.loading,
    required this.error,
    required this.launches,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height * 0.8; // occupy most of screen
    Widget child;
    if (loading && launches.isEmpty) {
      child = const Center(child: CircularProgressIndicator());
    } else if (error != null && launches.isEmpty) {
      child = _ErrorRetry(message: error!, onRetry: onRetry);
    } else if (launches.isEmpty) {
      child = const Center(child: Text('No launches'));
    } else {
      child = ListView.separated(
        itemCount: launches.length,
        itemBuilder: (c, i) => LaunchCard(launch: launches[i]),
        separatorBuilder: (_, __) => const SizedBox(height: 8),
      );
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: SpaceColors.border),
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            SpaceColors.card.withValues(alpha: 0.85),
            SpaceColors.deepBlue.withValues(alpha: 0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(18), child: child),
    );
  }
}
