import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/launch.dart';

part 'launch_model.g.dart';

@JsonSerializable()
class LaunchModel {
  final String id;
  final String name;
  @JsonKey(name: 'flight_number')
  final int flightNumber;
  @JsonKey(name: 'date_utc')
  final String dateUtc;
  final bool? success;
  final String rocket; // rocket id
  final String? details;
  final LinksModel? links;

  LaunchModel({
    required this.id,
    required this.name,
    required this.flightNumber,
    required this.dateUtc,
    required this.success,
    required this.rocket,
    this.details,
    this.links,
  });

  factory LaunchModel.fromJson(Map<String, dynamic> json) =>
      _$LaunchModelFromJson(json);
  Map<String, dynamic> toJson() => _$LaunchModelToJson(this);

  Launch toEntity() => Launch(
    id: id,
    name: name,
    flightNumber: flightNumber,
    dateUtc: DateTime.parse(dateUtc),
    success: success,
    rocketId: rocket,
    details: details,
    flickrImages: links?.flickr?.original?.isNotEmpty == true
        ? links!.flickr!.original
        : links?.flickr?.small,
  );
}

@JsonSerializable()
class LinksModel {
  final FlickrModel? flickr;
  LinksModel({this.flickr});
  factory LinksModel.fromJson(Map<String, dynamic> json) =>
      _$LinksModelFromJson(json);
  Map<String, dynamic> toJson() => _$LinksModelToJson(this);
}

@JsonSerializable()
class FlickrModel {
  final List<String>? small;
  final List<String>? original;
  FlickrModel({this.small, this.original});
  factory FlickrModel.fromJson(Map<String, dynamic> json) =>
      _$FlickrModelFromJson(json);
  Map<String, dynamic> toJson() => _$FlickrModelToJson(this);
}
