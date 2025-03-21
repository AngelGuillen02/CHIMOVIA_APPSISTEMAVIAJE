import 'package:bloc/bloc.dart';
import 'package:chimovia_appmovil/modules/asignacion/domain/entities/asignacion.dart';
import 'package:chimovia_appmovil/modules/asignacion/domain/repository/asignacion_respository.dart';
import 'package:meta/meta.dart';

part 'asignaciones_bloc_event.dart';
part 'asignaciones_bloc_state.dart';

class AsignacionesBlocBloc extends Bloc<AsignacionesBlocEvent, AsignacionesBlocState> {
    final AsignacionesRepository repository;

  AsignacionesBlocBloc({required this.repository}) : super(AsignacionesBlocInitial()) {
    on<CargarAsignaciones>((event, emit) async {
      emit(AsignacionesCargadas());
      try {
        final asignaciones = await repository.getAsignaciones();
        emit(AsignacionesCargadasLista(asignaciones: asignaciones));
      } catch (e) {
        emit(AsignacionesError(mensaje: e.toString()));
      }
    });

    on<AgregarAsignacion>((event, emit) async {
      emit(AsignacionesCargadas());
      try {
        await repository.addAsignacion(event.asignacion);
        final asignaciones = await repository.getAsignaciones();
        emit(AsignacionesCargadasLista(asignaciones: asignaciones));
      } catch (e) {
        emit(AsignacionesError(mensaje: e.toString()));
      }
    });
  }
}
