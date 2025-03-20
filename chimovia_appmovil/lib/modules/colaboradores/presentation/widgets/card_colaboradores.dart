import 'package:chimovia_appmovil/modules/colaboradores/domain/entities/colaborador.dart';
import 'package:chimovia_appmovil/modules/colaboradores/presentation/widgets/filas_colaboradores.dart';
import 'package:flutter/material.dart';


class CardColaboradores extends StatefulWidget {
  final Dato colaborador;
  const CardColaboradores({super.key, required this.colaborador});

  @override
  State<CardColaboradores> createState() => _CardColaboradoresState();
}

class _CardColaboradoresState extends State<CardColaboradores> {
  @override
  Widget build(BuildContext context) {
    return _construirCardColaborador(widget.colaborador);
  }
}


Widget _construirCardColaborador(Dato collaborator) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        childrenPadding: EdgeInsets.fromLTRB(20, 0, 20, 20),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                collaborator.nombre[0],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${collaborator.nombre} ${collaborator.apellido}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    collaborator.cargoDescripcion.toString().split('.').last,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Icon(Icons.email_outlined, size: 16, color: Colors.grey[600]),
              SizedBox(width: 8),
              Text(collaborator.email, style: TextStyle(fontSize: 13)),
            ],
          ),
        ),
        children: [
          FilaColaboradores(label: 'identidad', value: collaborator.identidad),
          FilaColaboradores(label: 'telefono', value: collaborator.telefono),
          FilaColaboradores(
            label: 'sexo',
            value: collaborator.sexo == 'M' ? 'Masculino' : 'Femenino',
          ),
          FilaColaboradores(
            label: 'Cargo',
            value: collaborator.cargoDescripcion.toString().split('.').last,
          ),
          FilaColaboradores(
            label: 'Localizacion',
            value: '${collaborator.latitud ?? "N/A"}, ${collaborator.longitud ?? "N/A"}',
          ),
        ],
      ),
    );
  }