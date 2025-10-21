// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'launch_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LaunchModel _$LaunchModelFromJson(Map<String, dynamic> json) => LaunchModel(
  id: json['id'] as String,
  name: json['name'] as String,
  flightNumber: (json['flight_number'] as num).toInt(),
  dateUtc: json['date_utc'] as String,
  success: json['success'] as bool?,
  rocket: json['rocket'] as String,
  details: json['details'] as String?,
  links: json['links'] == null
      ? null
      : LinksModel.fromJson(json['links'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LaunchModelToJson(LaunchModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'flight_number': instance.flightNumber,
      'date_utc': instance.dateUtc,
      'success': instance.success,
      'rocket': instance.rocket,
      'details': instance.details,
      'links': instance.links,
    };

LinksModel _$LinksModelFromJson(Map<String, dynamic> json) => LinksModel(
  flickr: json['flickr'] == null
      ? null
      : FlickrModel.fromJson(json['flickr'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LinksModelToJson(LinksModel instance) =>
    <String, dynamic>{'flickr': instance.flickr};

FlickrModel _$FlickrModelFromJson(Map<String, dynamic> json) => FlickrModel(
  small: (json['small'] as List<dynamic>?)?.map((e) => e as String).toList(),
  original: (json['original'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$FlickrModelToJson(FlickrModel instance) =>
    <String, dynamic>{'small': instance.small, 'original': instance.original};
