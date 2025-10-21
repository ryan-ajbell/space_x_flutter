// Launch domain entity

class Launch {
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
}
