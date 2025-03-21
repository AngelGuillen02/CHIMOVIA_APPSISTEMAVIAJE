import 'package:bloc/bloc.dart';
import 'package:chimovia_appmovil/modules/viajes/domain/entities/viajes.dart';
import 'package:chimovia_appmovil/modules/viajes/domain/repository/viaje_repository.dart';
import 'package:meta/meta.dart';

part 'viajes_bloc_event.dart';
part 'viajes_bloc_state.dart';

class ViajesBlocBloc extends Bloc<ViajesBlocEvent, ViajesBlocState> {
  final ViajesRepository repository;

  ViajesBlocBloc({required this.repository}) : super(ViajesBlocInitial()) {
    on<CargarViajes>((event, emit) async {
      emit(ViajesCargados());
      try {
        final viajes = await repository.getViajes();
        emit(ViajesCargadosLista(viajes: viajes));
      } catch (e) {
        emit(ViajesError(mensaje: e.toString()));
      }
    });

    on<AgregarViaje>((event, emit) async {
      emit(ViajesCargados());
      try {
        await repository.addViaje(event.viaje);
        final viajes = await repository.getViajes();
        emit(ViajesCargadosLista(viajes: viajes));
      } catch (e) {
        emit(ViajesError(mensaje: e.toString()));
      }
    });
  }
}
