import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../features/spacex/domain/entities/launch.dart';
import '../../utils/date_time_extensions.dart';
import '../theme/space_theme.dart';
import 'shimmer_skeleton.dart';

// Widget for displaying launch info
class LaunchCard extends StatelessWidget {
  final Launch launch;
  final bool fullScreen;
  const LaunchCard({super.key, required this.launch, this.fullScreen = false});

  @override
  Widget build(BuildContext context) {
    final hasImage =
        launch.flickrImages != null && launch.flickrImages!.isNotEmpty;

    final chips = Wrap(
      spacing: 12,
      runSpacing: 4,
      children: [
        _InfoChip(label: 'Flight #', value: launch.flightNumber.toString()),
        _InfoChip(label: 'Date', value: launch.dateUtc.toLocal().yyyymmdd()),
        _InfoChip(
          label: 'Success',
          value: launch.success == null
              ? 'Unknown'
              : (launch.success! ? 'Yes' : 'No'),
        ),
      ],
    );

    final description = (launch.details != null && launch.details!.isNotEmpty)
        ? Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              launch.details!,
              maxLines: fullScreen ? 100 : 3,
              overflow: fullScreen
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        : const SizedBox.shrink();

    final image = hasImage
        ? Padding(
            padding: const EdgeInsets.only(top: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  Hero(
                    tag: 'launch-image-${launch.id}',
                    child: CachedNetworkImage(
                      key: ValueKey('launch-image-${launch.id}'),
                      imageUrl: launch.flickrImages!.first,
                      height: fullScreen ? 240 : 160,
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
            ),
          )
        : const SizedBox.shrink();

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          launch.name,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        chips,
        description,
        image,
      ],
    );

    final inner = fullScreen
        ? SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: content,
          )
        : Padding(padding: const EdgeInsets.all(16), child: content);

    return InkWell(
      onTap: fullScreen
          ? null
          : () => Navigator.of(
              context,
            ).pushNamed('/launch_full', arguments: launch),
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

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final bool compact;
  const _InfoChip({
    required this.label,
    required this.value,
    this.compact = false,
  });
  @override
  Widget build(BuildContext context) => Chip(
    backgroundColor: SpaceColors.border,
    label: Text(
      compact ? '$label $value' : '$label: $value',
      style: TextStyle(fontSize: compact ? 11 : 12),
      overflow: TextOverflow.ellipsis,
    ),
    visualDensity: compact
        ? const VisualDensity(horizontal: -3, vertical: -3)
        : VisualDensity.compact,
    padding: EdgeInsets.symmetric(horizontal: compact ? 4 : 6),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );
}

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
