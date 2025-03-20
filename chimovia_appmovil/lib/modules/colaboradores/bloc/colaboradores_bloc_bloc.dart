// lib/modules/colaboradores/bloc/colaboradores_bloc.dart
import 'package:chimovia_appmovil/modules/colaboradores/bloc/colaboradores_bloc_event.dart';
import 'package:chimovia_appmovil/modules/colaboradores/bloc/colaboradores_bloc_state.dart';
import 'package:chimovia_appmovil/modules/colaboradores/domain/repository/colaborador_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColaboradoresBloc extends Bloc<ColaboradoresEvent, ColaboradoresState> {
  final ColaboradoresRepository repository;

  ColaboradoresBloc({required this.repository})
    : super(ColaboradoresInitial()) {
    on<LoadColaboradores>((event, emit) async {
      emit(ColaboradoresLoading());
      try {
        final colaboradores = await repository.getColaboradores();
        final listadoDatos =
            colaboradores.expand((colaborador) => colaborador.datos).toList();
        emit(ColaboradoresLoaded(colaboradores: listadoDatos));
      } catch (e) {
        emit(ColaboradoresError(message: e.toString()));
      }
    });

    on<AddColaborador>((event, emit) async {
      emit(ColaboradoresLoading());
      try {
        await repository.addColaborador(event.colaborador);
        final colaboradores = await repository.getColaboradores();
        final listadoDatos =
            colaboradores.expand((colaborador) => colaborador.datos).toList();
        emit(ColaboradoresLoaded(colaboradores: listadoDatos));
      } catch (e) {
        emit(ColaboradoresError(message: e.toString()));
      }
    });
  }
}
