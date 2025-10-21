// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rocket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RocketModel _$RocketModelFromJson(Map<String, dynamic> json) => RocketModel(
  id: json['id'] as String,
  name: json['name'] as String,
  type: json['type'] as String,
  description: json['description'] as String,
  stages: (json['stages'] as num).toInt(),
  boosters: (json['boosters'] as num).toInt(),
  active: json['active'] as bool,
  costPerLaunch: (json['cost_per_launch'] as num).toInt(),
  successRatePct: (json['success_rate_pct'] as num).toInt(),
  firstFlight: json['first_flight'] as String,
  country: json['country'] as String,
  company: json['company'] as String,
  flickrImages: (json['flickr_images'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$RocketModelToJson(RocketModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'description': instance.description,
      'stages': instance.stages,
      'boosters': instance.boosters,
      'active': instance.active,
      'cost_per_launch': instance.costPerLaunch,
      'success_rate_pct': instance.successRatePct,
      'first_flight': instance.firstFlight,
      'country': instance.country,
      'company': instance.company,
      'flickr_images': instance.flickrImages,
    };
