import 'package:equatable/equatable.dart';

class Launch extends Equatable {
  final String id;
  final String name;
  final int flightNumber;
  final DateTime dateUtc;
  final bool? success;
  final String rocketId;
  final String? details;
  final List<String>? flickrImages;
  Launch({
    required this.id,
    required this.name,
    required this.flightNumber,
    required this.dateUtc,
    required this.success,
    required this.rocketId,
    this.details,
    this.flickrImages,
  });
  @override
  List<Object?> get props => [
    id,
    name,
    flightNumber,
    dateUtc,
    success,
    rocketId,
    details,
    flickrImages,
  ];
}
