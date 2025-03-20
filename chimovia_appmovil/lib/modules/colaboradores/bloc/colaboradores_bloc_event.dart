import 'package:chimovia_appmovil/modules/colaboradores/domain/entities/colaborador.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ColaboradoresEvent {}

class LoadColaboradores extends ColaboradoresEvent {}

class AddColaborador extends ColaboradoresEvent {
final Colaboradores colaborador;

  AddColaborador({required this.colaborador});
}