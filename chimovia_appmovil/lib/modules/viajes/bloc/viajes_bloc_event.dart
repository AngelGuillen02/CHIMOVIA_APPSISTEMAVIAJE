part of 'viajes_bloc_bloc.dart';

@immutable
sealed class ViajesBlocEvent {}


class CargarViajes extends ViajesBlocEvent {}

class AgregarViaje extends ViajesBlocEvent {
  final Viajes viaje;

  AgregarViaje({required this.viaje});
}