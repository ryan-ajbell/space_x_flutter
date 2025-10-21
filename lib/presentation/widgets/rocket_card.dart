import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../features/spacex/domain/entities/space_x_rocket.dart';
import '../../utils/date_time_extensions.dart';
import '../theme/space_theme.dart';
import 'shimmer_skeleton.dart';

class RocketCard extends StatelessWidget {
  final SpaceXRocket rocket;
  final bool fullScreen;
  const RocketCard({super.key, required this.rocket, this.fullScreen = false});

  @override
  Widget build(BuildContext context) {
    final hasImage = rocket.flickrImages.isNotEmpty;
    final descriptionWidget = Text(
      rocket.description,
      maxLines: fullScreen ? 200 : 3,
      overflow: fullScreen ? TextOverflow.visible : TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyMedium,
    );
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          rocket.name,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        descriptionWidget,
        const SizedBox(height: 12),
        if (hasImage)
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                Hero(
                  tag: 'rocket-image-${rocket.id}',
                  child: CachedNetworkImage(
                    key: ValueKey('rocket-image-${rocket.id}'),
                    imageUrl: rocket.flickrImages.first,
                    height: fullScreen ? 260 : 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (c, _) => const ShimmerSkeleton(
                      height: 160,
                      width: double.infinity,
                      borderRadius: BorderRadius.zero,
                    ),
                    errorWidget: (c, _, __) => _imageError(),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          SpaceColors.spaceBlack.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          _imageSkeleton(label: 'No image available'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: [
            _InfoChip(label: 'Type', value: rocket.type),
            _InfoChip(label: 'Country', value: rocket.country),
            _InfoChip(label: 'Company', value: rocket.company),
            _InfoChip(
              label: 'First Flight',
              value: rocket.firstFlight.toLocal().yyyymmdd(),
            ),
            _InfoChip(label: 'Active', value: rocket.active ? 'Yes' : 'No'),
          ],
        ),
      ],
    );

    final inner = fullScreen
        ? SingleChildScrollView(padding: const EdgeInsets.all(16), child: body)
        : Padding(padding: const EdgeInsets.all(16), child: body);

    return InkWell(
      onTap: fullScreen
          ? null
          : () => Navigator.of(
              context,
            ).pushNamed('/rocket_full', arguments: rocket),
      borderRadius: BorderRadius.circular(12),
      child: Card(
        margin: fullScreen
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        elevation: fullScreen ? 0 : 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: inner,
      ),
    );
  }
}

Widget _imageSkeleton({String? label}) => Container(
  height: 160,
  width: double.infinity,
  decoration: BoxDecoration(
    color: Colors.grey[200],
    borderRadius: BorderRadius.circular(10),
  ),
  child: Center(
    child: Text(label ?? '', style: TextStyle(color: Colors.grey[600])),
  ),
);

Widget _imageError() => Container(
  height: 160,
  width: double.infinity,
  decoration: BoxDecoration(
    color: Colors.grey[300],
    borderRadius: BorderRadius.circular(10),
  ),
  child: const Center(
    child: Icon(Icons.broken_image, color: Colors.redAccent, size: 40),
  ),
);

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  const _InfoChip({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Chip(
    backgroundColor: SpaceColors.border,
    label: Text('$label: $value'),
    visualDensity: VisualDensity.compact,
    padding: const EdgeInsets.symmetric(horizontal: 4),
  );
}
