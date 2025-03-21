import 'package:chimovia_appmovil/modules/viajes/domain/entities/viajes.dart';

abstract class ViajesDatasource {

  Future<List<Viajes>> getViajes();
  Future<void> addViaje(Viajes viaje);

}