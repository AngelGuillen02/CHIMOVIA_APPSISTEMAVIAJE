
import 'package:chimovia_appmovil/modules/colaboradores/domain/entities/colaborador.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ColaboradoresState {}

class ColaboradoresInitial extends ColaboradoresState {}

class ColaboradoresLoading extends ColaboradoresState {}

class ColaboradoresLoaded extends ColaboradoresState {
  final List<Dato> colaboradores;

  ColaboradoresLoaded({required this.colaboradores});
}

class ColaboradoresError extends ColaboradoresState {
  final String message;

  ColaboradoresError({required this.message});
}