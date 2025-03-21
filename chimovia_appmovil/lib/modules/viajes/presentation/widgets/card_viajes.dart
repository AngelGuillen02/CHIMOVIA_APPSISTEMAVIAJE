import 'package:flutter/material.dart';
import 'package:chimovia_appmovil/modules/viajes/domain/entities/viajes.dart';

class CardViajes extends StatelessWidget {
  final Viajes viaje;

  const CardViajes({super.key, required this.viaje});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(viaje.descripcion[0], style: TextStyle(color: Colors.white)),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(viaje.descripcion, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 4),
                  Text(viaje.horaLlegada, style: TextStyle(fontSize: 13)),
                  
                ],
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
              SizedBox(width: 8),
              Text(viaje.horaLlegada, style: TextStyle(fontSize: 13)),
            ],
          ),
        ),
        children: [
          Text('Fecha: ${viaje.fecha.toIso8601String()}'),
          Text('Distancia Parcial: ${viaje.distanciaParcial} km'),
        ],
      ),
    );
  }
}
