import 'package:chimovia_appmovil/modules/colaboradores/bloc/colaboradores_bloc_bloc.dart';
import 'package:chimovia_appmovil/modules/colaboradores/bloc/colaboradores_bloc_state.dart';
import 'package:chimovia_appmovil/modules/colaboradores/domain/entities/colaborador.dart';
import 'package:chimovia_appmovil/modules/colaboradores/presentation/widgets/card_colaboradores.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListaColaboradores extends StatefulWidget {

  final List<Dato> colaboradoresFiltrados;
  const ListaColaboradores({super.key, required this.colaboradoresFiltrados});

  @override
  State<ListaColaboradores> createState() => _ListaColaboradoresState();
}

class _ListaColaboradoresState extends State<ListaColaboradores> {
  @override
  Widget build(BuildContext context) {
    return _construirListaColaborador(widget.colaboradoresFiltrados);
  }
}

Widget _construirListaColaborador(List<Dato> colaboradoresFiltrados) {
    return BlocBuilder<ColaboradoresBloc, ColaboradoresState>(
      builder: (context, state) {
        if (state is ColaboradoresCargados) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ColaboradoresError) {
          return Center(child: Text(state.message));
        } else if (state is ColaboradoresCargadosLista) {
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
              return CardColaboradores(colaborador: collaborator);
            },
          );
        }
        return Center(child: Text('Colaborador no disponible'));
      },
    );
  }