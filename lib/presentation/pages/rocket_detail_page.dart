import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../features/spacex/domain/entities/space_x_rocket.dart';
import '../theme/space_theme.dart';
import '../widgets/section_title.dart';

class RocketDetailPage extends StatelessWidget {
  final SpaceXRocket rocket;
  const RocketDetailPage({super.key, required this.rocket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(rocket.name)),
      body: StarfieldBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (rocket.flickrImages.isNotEmpty) ...[
                  Hero(
                    tag: 'rocket-image-${rocket.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: CachedNetworkImage(
                        imageUrl: rocket.flickrImages.first,
                        height: 240,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                Text(
                  rocket.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                const SectionTitle('Specifications', icon: Icons.tune),
                const SizedBox(height: 12),
                _specWrap(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _specWrap(BuildContext context) {
    final specs = <MapEntry<String, String>>[
      MapEntry('Stages', rocket.stages.toString()),
      MapEntry('Boosters', rocket.boosters.toString()),
      MapEntry('Cost/Launch', '\$${rocket.costPerLaunch ~/ 1000000}M'),
      MapEntry('Success %', '${rocket.successRatePct}%'),
      MapEntry(
        'First Flight',
        rocket.firstFlight.toIso8601String().split('T').first,
      ),
      MapEntry('Country', rocket.country),
      MapEntry('Active', rocket.active ? 'Yes' : 'No'),
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
