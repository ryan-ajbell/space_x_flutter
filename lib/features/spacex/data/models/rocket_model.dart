import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/space_x_rocket.dart';

part 'rocket_model.g.dart';

@JsonSerializable()
class RocketModel {
  final String id;
  final String name;
  final String type;
  final String description;
  final int stages;
  final int boosters;
  final bool active;
  @JsonKey(name: 'cost_per_launch')
  final int costPerLaunch;
  @JsonKey(name: 'success_rate_pct')
  final int successRatePct;
  @JsonKey(name: 'first_flight')
  final String firstFlight;
  final String country;
  final String company;
  @JsonKey(name: 'flickr_images')
  final List<String> flickrImages;

  RocketModel({
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

  factory RocketModel.fromJson(Map<String, dynamic> json) =>
      _$RocketModelFromJson(json);
  Map<String, dynamic> toJson() => _$RocketModelToJson(this);

  SpaceXRocket toEntity() => SpaceXRocket(
    id: id,
    name: name,
    type: type,
    description: description,
    stages: stages,
    boosters: boosters,
    active: active,
    costPerLaunch: costPerLaunch,
    successRatePct: successRatePct,
    firstFlight: DateTime.parse(firstFlight),
    country: country,
    company: company,
    flickrImages: flickrImages,
  );
}
