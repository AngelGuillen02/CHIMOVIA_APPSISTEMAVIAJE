part of 'asignaciones_bloc_bloc.dart';

@immutable
sealed class AsignacionesBlocState {}

final class AsignacionesBlocInitial extends AsignacionesBlocState {}

final class AsignacionesCargadas extends AsignacionesBlocState {}

final class AsignacionesCargadasLista extends AsignacionesBlocState {
  final List<Asignacion> asignaciones;

  AsignacionesCargadasLista({required this.asignaciones});
}

final class AsignacionesError extends AsignacionesBlocState {
  final String mensaje;

  AsignacionesError({required this.mensaje});
}
