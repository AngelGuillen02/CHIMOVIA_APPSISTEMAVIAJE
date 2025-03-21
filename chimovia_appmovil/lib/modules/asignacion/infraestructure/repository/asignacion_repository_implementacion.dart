import 'package:chimovia_appmovil/modules/asignacion/domain/entities/asignacion.dart';
import 'package:chimovia_appmovil/modules/asignacion/domain/repository/asignacion_respository.dart';
import 'package:chimovia_appmovil/modules/asignacion/infraestructure/datasource/asignacion_datasource_implementacion.dart';

class AsignacionesRepositoryImpl implements AsignacionesRepository {
  final AsignacionesDataSourceImpl dataSource;

  AsignacionesRepositoryImpl({required this.dataSource});

  @override
  Future<List<Asignacion>> getAsignaciones() async {
    var response = await dataSource.getAsignaciones();
    return response;
  }

  @override
  Future<void> addAsignacion(Asignacion asignacion) async {
    await dataSource.addAsignacion(asignacion);
  }
}
