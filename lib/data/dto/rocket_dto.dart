// DTO for Rocket, using json_serializable
import 'package:json_annotation/json_annotation.dart';

part 'rocket_dto.g.dart';

@JsonSerializable()
class RocketDto {
  final String id;
  final String name;
  final String type;
  final String description;
  final int stages;
  final int boosters;
  final bool active;
  final int cost_per_launch;
  final int success_rate_pct;
  final String first_flight;
  final String country;
  final String company;
  final List<String> flickr_images;

  RocketDto({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.stages,
    required this.boosters,
    required this.active,
    required this.cost_per_launch,
    required this.success_rate_pct,
    required this.first_flight,
    required this.country,
    required this.company,
    required this.flickr_images,
  });

  factory RocketDto.fromJson(Map<String, dynamic> json) =>
      _$RocketDtoFromJson(json);
  Map<String, dynamic> toJson() => _$RocketDtoToJson(this);
}
