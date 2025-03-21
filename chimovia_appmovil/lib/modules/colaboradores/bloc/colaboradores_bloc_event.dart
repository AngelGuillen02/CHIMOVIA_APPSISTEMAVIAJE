import 'package:chimovia_appmovil/modules/colaboradores/domain/entities/colaborador.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ColaboradoresEvent {}

class CargarColaboradores extends ColaboradoresEvent {}

class AgregarColaborador extends ColaboradoresEvent {
final Colaboradores colaborador;

  AgregarColaborador({required this.colaborador});
}