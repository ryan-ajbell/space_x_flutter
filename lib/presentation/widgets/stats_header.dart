import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/spacex/presentation/cubit/latest_launch_cubit.dart';
import '../../features/spacex/presentation/cubit/launches_cubit.dart';
import '../../features/spacex/presentation/cubit/rockets_cubit.dart';
import '../theme/space_theme.dart';

class StatsHeader extends StatelessWidget {
  const StatsHeader({super.key});
  @override
  Widget build(BuildContext context) {
    final rockets = context.watch<RocketsCubit>().state.rockets.length;
    final launches = context.watch<LaunchesCubit>().state.launches.length;
    final latest = context.watch<LatestLaunchCubit>().state.launch;
    final success = latest?.success;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SpaceColors.border),
        gradient: LinearGradient(
          colors: [
            SpaceColors.card.withValues(alpha: .9),
            SpaceColors.deepBlue.withValues(alpha: .7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _metric('Rockets', rockets.toString(), Icons.rocket_launch),
          _metric('Launches', launches.toString(), Icons.history),
          _metric(
            'Latest',
            success == null ? '?' : (success ? 'Success' : 'Fail'),
            Icons.flag,
            color: success == null
                ? Colors.amber
                : (success ? SpaceColors.success : SpaceColors.danger),
          ),
        ],
      ),
    );
  }

  Widget _metric(String label, String value, IconData icon, {Color? color}) =>
      Column(
        children: [
          Icon(icon, color: color ?? SpaceColors.accentBlue, size: 28),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, letterSpacing: 1.1)),
        ],
      );
}
