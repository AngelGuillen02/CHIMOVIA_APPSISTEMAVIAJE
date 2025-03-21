
import 'package:chimovia_appmovil/modules/colaboradores/domain/entities/colaborador.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ColaboradoresState {}

class ColaboradoresInicial extends ColaboradoresState {}

class ColaboradoresCargados extends ColaboradoresState {}

class ColaboradoresCargadosLista extends ColaboradoresState {
  final List<Dato> colaboradores;

  ColaboradoresCargadosLista({required this.colaboradores});
}

class ColaboradoresError extends ColaboradoresState {
  final String message;

  ColaboradoresError({required this.message});
}