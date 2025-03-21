part of 'viajes_bloc_bloc.dart';

@immutable
sealed class ViajesBlocState {}

final class ViajesBlocInitial extends ViajesBlocState {}

class ViajesCargados extends ViajesBlocState {}

class ViajesCargadosLista extends ViajesBlocState {
  final List<Viajes> viajes;

  ViajesCargadosLista({required this.viajes});
}

class ViajesError extends ViajesBlocState {
  final String mensaje;

  ViajesError({required this.mensaje});
}