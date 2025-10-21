import 'package:equatable/equatable.dart';

class SpaceXRocket extends Equatable {
  final String id;
  final String name;
  final String type;
  final String description;
  final int stages;
  final int boosters;
  final bool active;
  final int costPerLaunch;
  final int successRatePct;
  final DateTime firstFlight;
  final String country;
  final String company;
  final List<String> flickrImages;
  SpaceXRocket({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.stages,
    required this.boosters,
    required this.active,
    required this.costPerLaunch,
    required this.successRatePct,
    required this.firstFlight,
    required this.country,
    required this.company,
    required this.flickrImages,
  });
  @override
  List<Object?> get props => [
    id,
    name,
    type,
    stages,
    boosters,
    active,
    costPerLaunch,
    successRatePct,
    firstFlight,
    country,
    company,
    flickrImages,
  ];
}
