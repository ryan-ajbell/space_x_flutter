import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/spacex/presentation/cubit/launches_cubit.dart';
import '../../features/spacex/presentation/cubit/rockets_cubit.dart';
import '../theme/space_theme.dart';
import '../widgets/launch_card.dart';
import '../widgets/rocket_card.dart';
import 'home_page.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});
  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;
  // shared search query across rocket & launch pages
  String _query = '';
  void _setQuery(String q) => setState(() => _query = q);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: StarfieldBackground(
        child: IndexedStack(
          index: _index,
          children: [
            const HomePage(),
            _RocketsPage(query: _query, onQueryChanged: _setQuery),
            _LaunchesPage(query: _query, onQueryChanged: _setQuery),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: 68,
        selectedIndex: _index,
        backgroundColor: SpaceColors.card.withValues(alpha: .6),
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.rocket_launch_outlined),
            selectedIcon: Icon(Icons.rocket_launch),
            label: 'Rockets',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Launches',
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatefulWidget {
  final String initial;
  final ValueChanged<String> onChanged;
  final String hint;
  const _SearchField({
    required this.initial,
    required this.onChanged,
    required this.hint,
  });
  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  late final TextEditingController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initial);
    _ctrl.addListener(() => widget.onChanged(_ctrl.text.trim()));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(
    controller: _ctrl,
    decoration: InputDecoration(
      hintText: widget.hint,
      prefixIcon: const Icon(Icons.search),
      suffixIcon: _ctrl.text.isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _ctrl.clear();
              },
            )
          : null,
      filled: true,
      fillColor: SpaceColors.card.withValues(alpha: .55),
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

class _RocketsPage extends StatelessWidget {
  final String query;
  final ValueChanged<String> onQueryChanged;
  const _RocketsPage({required this.query, required this.onQueryChanged});
  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom + 16;
    return SafeArea(
      top: true,
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 24, 16, bottom),
        child: BlocBuilder<RocketsCubit, RocketsState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null) {
              return _errorWithRetry(
                state.error!,
                () => context.read<RocketsCubit>().load(),
              );
            }
            var rockets = state.rockets;
            if (query.isNotEmpty) {
              final q = query.toLowerCase();
              rockets = rockets
                  .where(
                    (r) =>
                        r.name.toLowerCase().contains(q) ||
                        r.country.toLowerCase().contains(q) ||
                        r.company.toLowerCase().contains(q),
                  )
                  .toList();
            }
            if (rockets.isEmpty) {
              return Column(
                children: [
                  _SearchField(
                    initial: query,
                    onChanged: onQueryChanged,
                    hint: 'Search rockets...',
                  ),
                  const SizedBox(height: 24),
                  const Expanded(child: Center(child: Text('No rockets'))),
                ],
              );
            }
            final width = MediaQuery.of(context).size.width;
            final wide = width > 700;
            return Column(
              children: [
                _SearchField(
                  initial: query,
                  onChanged: onQueryChanged,
                  hint: 'Search rockets...',
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: wide
                      ? _rocketGrid(rockets, width)
                      : ListView.builder(
                          itemCount: rockets.length,
                          itemBuilder: (c, i) => RocketCard(rocket: rockets[i]),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _rocketGrid(List rockets, double width) {
    final cross = (width / 320).floor().clamp(2, 6);
    return GridView.builder(
      itemCount: rockets.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cross,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (c, i) => RocketCard(rocket: rockets[i]),
    );
  }

  Widget _errorWithRetry(String msg, VoidCallback retry) => Column(
    children: [
      _SearchField(
        initial: query,
        onChanged: onQueryChanged,
        hint: 'Search rockets...',
      ),
      const SizedBox(height: 24),
      Text(msg, style: const TextStyle(color: Colors.red)),
      TextButton.icon(
        onPressed: retry,
        icon: const Icon(Icons.refresh),
        label: const Text('Retry'),
      ),
    ],
  );
}

class _LaunchesPage extends StatefulWidget {
  final String query;
  final ValueChanged<String> onQueryChanged;
  const _LaunchesPage({required this.query, required this.onQueryChanged});
  @override
  State<_LaunchesPage> createState() => _LaunchesPageState();
}

class _LaunchesPageState extends State<_LaunchesPage> {
  final _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    final cubit = context.read<LaunchesCubit>();
    if (widget.query.isNotEmpty) {
      return; // disable infinite scroll while filtering
    }
    if (_controller.position.pixels >
            _controller.position.maxScrollExtent - 400 &&
        !cubit.state.loadingMore &&
        !cubit.state.loading) {
      cubit.loadMore();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom + 16;
    return SafeArea(
      top: true,
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 24, 16, bottom),
        child: Column(
          children: [
            _SearchField(
              initial: widget.query,
              onChanged: widget.onQueryChanged,
              hint: 'Search launches...',
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<LaunchesCubit, LaunchesState>(
                builder: (context, state) {
                  if (state.loading && state.launches.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.error != null && state.launches.isEmpty) {
                    return Center(child: Text('Error: ${state.error}'));
                  }
                  var launches = state.launches;
                  if (widget.query.isNotEmpty) {
                    final q = widget.query.toLowerCase();
                    launches = launches
                        .where(
                          (l) =>
                              l.name.toLowerCase().contains(q) ||
                              l.rocketId.toLowerCase().contains(q),
                        )
                        .toList();
                  }
                  if (launches.isEmpty) {
                    return const Center(child: Text('No launches'));
                  }
                  return ListView.builder(
                    controller: _controller,
                    itemCount:
                        launches.length +
                        (state.loadingMore && widget.query.isEmpty ? 1 : 0),
                    itemBuilder: (c, i) {
                      if (i >= launches.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return LaunchCard(launch: launches[i]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
