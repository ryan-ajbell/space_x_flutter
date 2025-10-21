import '../../domain/entities/rocket.dart';
import '../api/spacex_api_service.dart';
import '../dto/rocket_dto.dart';

abstract class RocketRepository {
  Future<List<SpaceXRocket>> getRockets();
}

class RocketRepositoryImpl implements RocketRepository {
  final SpaceXApiService api;
  RocketRepositoryImpl(this.api);
  @override
  Future<List<SpaceXRocket>> getRockets() async {
    final List<RocketDto> dtos = await api.getRockets();
    return dtos
        .map(
          (d) => SpaceXRocket(
            id: d.id,
            name: d.name,
            type: d.type,
            description: d.description,
            stages: d.stages,
            boosters: d.boosters,
            active: d.active,
            costPerLaunch: d.cost_per_launch,
            successRatePct: d.success_rate_pct,
            firstFlight: DateTime.parse(d.first_flight),
            country: d.country,
            company: d.company,
            flickrImages: d.flickr_images,
          ),
        )
        .toList();
  }
}
