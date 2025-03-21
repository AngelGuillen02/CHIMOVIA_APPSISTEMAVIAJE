import 'package:chimovia_appmovil/modules/asignacion/domain/entities/asignacion.dart';

abstract class AsignacionesDatasource {
  
  Future<List<Asignacion>> getAsignaciones();
  Future<void> addAsignacion(Asignacion asignacion);

}
