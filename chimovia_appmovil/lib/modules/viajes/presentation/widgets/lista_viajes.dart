import 'package:chimovia_appmovil/modules/viajes/bloc/viajes_bloc_bloc.dart';
import 'package:chimovia_appmovil/modules/viajes/presentation/widgets/card_viajes.dart';
import 'package:flutter/material.dart';
import 'package:chimovia_appmovil/modules/viajes/domain/entities/viajes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListaViajes extends StatelessWidget {
  final List<Viajes> viajesFiltrados;

  const ListaViajes({super.key, required this.viajesFiltrados});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViajesBlocBloc, ViajesBlocState>(
      builder: (context, state) {
        if (state is ViajesCargados) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ViajesError) {
          return Center(child: Text('Error: ${state.mensaje}'));
        } else if (state is ViajesCargadosLista) {
          if (viajesFiltrados.isEmpty) {
            return const Center(child: Text('No se encontraron viajes'));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: viajesFiltrados.length,
            itemBuilder: (context, index) {
              final viaje = viajesFiltrados[index];
              return CardViajes(viaje: viaje);
            },
          );
        }
        return const Center(child: Text('Cargando viajes...'));
      },
    );
  }
}
