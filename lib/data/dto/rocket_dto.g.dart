// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rocket_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RocketDto _$RocketDtoFromJson(Map<String, dynamic> json) => RocketDto(
  id: json['id'] as String,
  name: json['name'] as String,
  type: json['type'] as String,
  description: json['description'] as String,
  stages: (json['stages'] as num).toInt(),
  boosters: (json['boosters'] as num).toInt(),
  active: json['active'] as bool,
  cost_per_launch: (json['cost_per_launch'] as num).toInt(),
  success_rate_pct: (json['success_rate_pct'] as num).toInt(),
  first_flight: json['first_flight'] as String,
  country: json['country'] as String,
  company: json['company'] as String,
  flickr_images: (json['flickr_images'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$RocketDtoToJson(RocketDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': instance.type,
  'description': instance.description,
  'stages': instance.stages,
  'boosters': instance.boosters,
  'active': instance.active,
  'cost_per_launch': instance.cost_per_launch,
  'success_rate_pct': instance.success_rate_pct,
  'first_flight': instance.first_flight,
  'country': instance.country,
  'company': instance.company,
  'flickr_images': instance.flickr_images,
};
