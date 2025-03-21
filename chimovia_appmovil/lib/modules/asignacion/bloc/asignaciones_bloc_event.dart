part of 'asignaciones_bloc_bloc.dart';

@immutable
sealed class AsignacionesBlocEvent {}

final class CargarAsignaciones extends AsignacionesBlocEvent {}

final class AgregarAsignacion extends AsignacionesBlocEvent {
  final Asignacion asignacion;

  AgregarAsignacion({required this.asignacion});
}