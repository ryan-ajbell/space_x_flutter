import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../features/spacex/domain/entities/launch.dart';
import '../theme/space_theme.dart';
import '../widgets/section_title.dart';

class LaunchDetailPage extends StatelessWidget {
  final Launch launch;
  const LaunchDetailPage({super.key, required this.launch});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(launch.name)),
      body: StarfieldBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              40,
              16,
              32,
            ), // increased top padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (launch.flickrImages != null &&
                    launch.flickrImages!.isNotEmpty) ...[
                  Hero(
                    tag: 'launch-image-${launch.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: CachedNetworkImage(
                        imageUrl: launch.flickrImages!.first,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                if (launch.details != null && launch.details!.isNotEmpty) ...[
                  Text(
                    launch.details!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 24),
                ],
                const SectionTitle('Overview', icon: Icons.info_outline),
                const SizedBox(height: 12),
                _specWrap(context),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _specWrap(BuildContext context) {
    final specs = <MapEntry<String, String>>[
      MapEntry('Flight #', launch.flightNumber.toString()),
      MapEntry(
        'Success',
        launch.success == null ? '?' : (launch.success! ? 'Yes' : 'No'),
      ),
      MapEntry('Date', launch.dateUtc.toIso8601String().split('T').first),
      MapEntry('Rocket ID', launch.rocketId),
    ];
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: specs.map((e) => _spec(e.key, e.value)).toList(),
    );
  }

  Widget _spec(String label, String value) => ConstrainedBox(
    constraints: const BoxConstraints(minWidth: 140, maxWidth: 200),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SpaceColors.border),
        color: SpaceColors.card.withValues(alpha: .6),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white70,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}
