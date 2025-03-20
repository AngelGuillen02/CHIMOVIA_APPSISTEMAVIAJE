import 'package:chimovia_appmovil/modules/colaboradores/bloc/colaboradores_bloc_bloc.dart';
import 'package:chimovia_appmovil/modules/colaboradores/bloc/colaboradores_bloc_state.dart';
import 'package:chimovia_appmovil/modules/colaboradores/domain/entities/colaborador.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget _buildCollaboratorsList(List<Dato> colaboradoresFiltrados) {
    return BlocBuilder<ColaboradoresBloc, ColaboradoresState>(
      builder: (context, state) {
        if (state is ColaboradoresLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ColaboradoresError) {
          return Center(child: Text(state.message));
        } else if (state is ColaboradoresLoaded) {
          if (colaboradoresFiltrados.isEmpty) {
            return Center(
              child: Text(
                'Colaborador no encontrado',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: colaboradoresFiltrados.length,
            itemBuilder: (context, index) {
              final collaborator = colaboradoresFiltrados[index];
              return _buildCollaboratorCard(collaborator);
            },
          );
        }
        return Center(child: Text('Colaborador no disponible'));
      },
    );
  }