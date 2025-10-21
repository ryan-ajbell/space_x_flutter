// DTO for Launch, using json_serializable
import 'package:json_annotation/json_annotation.dart';

part 'launch_dto.g.dart';

@JsonSerializable()
class LaunchDto {
  final String id;
  final String name;
  final int flight_number;
  final String date_utc;
  final bool? success; // nullable (API can return null)
  final String rocket;
  final String? details;
  @JsonKey(name: 'links')
  final LinksDto? links;

  LaunchDto({
    required this.id,
    required this.name,
    required this.flight_number,
    required this.date_utc,
    required this.success,
    required this.rocket,
    this.details,
    this.links,
  });

  List<String>? get flickr_images => links?.flickr?.original;

  factory LaunchDto.fromJson(Map<String, dynamic> json) =>
      _$LaunchDtoFromJson(json);
  Map<String, dynamic> toJson() => _$LaunchDtoToJson(this);
}

// Minimal nested link models (adapt as needed)
@JsonSerializable()
class LinksDto {
  final FlickrDto? flickr;
  LinksDto({this.flickr});
  factory LinksDto.fromJson(Map<String, dynamic> json) =>
      _$LinksDtoFromJson(json);
  Map<String, dynamic> toJson() => _$LinksDtoToJson(this);
}

@JsonSerializable()
class FlickrDto {
  final List<String>? original;
  FlickrDto({this.original});
  factory FlickrDto.fromJson(Map<String, dynamic> json) =>
      _$FlickrDtoFromJson(json);
  Map<String, dynamic> toJson() => _$FlickrDtoToJson(this);
}
