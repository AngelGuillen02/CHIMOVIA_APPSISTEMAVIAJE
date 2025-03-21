import 'package:chimovia_appmovil/modules/viajes/domain/entities/viajes.dart';
import 'package:chimovia_appmovil/modules/viajes/domain/repository/viaje_repository.dart';
import 'package:chimovia_appmovil/modules/viajes/infraestructure/datasource/viajes_datasource_implementacion.dart';

class ViajesRepositoryImpl implements ViajesRepository {
  final ViajesDataSourceImpl dataSource;

  ViajesRepositoryImpl({required this.dataSource});

  @override
  Future<List<Viajes>> getViajes() async {
    var response = await dataSource.getViajes();
    return response;
  }

  @override
  Future<void> addViaje(Viajes viaje) async {
    await dataSource.addViaje(viaje);
  }
}