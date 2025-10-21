// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'launch_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LaunchDto _$LaunchDtoFromJson(Map<String, dynamic> json) => LaunchDto(
  id: json['id'] as String,
  name: json['name'] as String,
  flight_number: (json['flight_number'] as num).toInt(),
  date_utc: json['date_utc'] as String,
  success: json['success'] as bool?,
  rocket: json['rocket'] as String,
  details: json['details'] as String?,
  links: json['links'] == null
      ? null
      : LinksDto.fromJson(json['links'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LaunchDtoToJson(LaunchDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'flight_number': instance.flight_number,
  'date_utc': instance.date_utc,
  'success': instance.success,
  'rocket': instance.rocket,
  'details': instance.details,
  'links': instance.links,
};

LinksDto _$LinksDtoFromJson(Map<String, dynamic> json) => LinksDto(
  flickr: json['flickr'] == null
      ? null
      : FlickrDto.fromJson(json['flickr'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LinksDtoToJson(LinksDto instance) => <String, dynamic>{
  'flickr': instance.flickr,
};

FlickrDto _$FlickrDtoFromJson(Map<String, dynamic> json) => FlickrDto(
  original: (json['original'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$FlickrDtoToJson(FlickrDto instance) => <String, dynamic>{
  'original': instance.original,
};
