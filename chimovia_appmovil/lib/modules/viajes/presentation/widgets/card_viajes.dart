import 'package:chimovia_appmovil/config/enviroment.dart';
import 'package:flutter/material.dart';
import 'package:chimovia_appmovil/modules/viajes/domain/entities/viajes.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

class CardViajes extends StatefulWidget {
  final Viajes viaje;

  const CardViajes({super.key, required this.viaje});

  @override
  _CardViajesState createState() => _CardViajesState();
}

class _CardViajesState extends State<CardViajes> {

  @override
  void initState() {
    super.initState();
  }

 

  @override
  Widget build(BuildContext context) {
    final viaje = widget.viaje;

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
          Text('Fecha: ${DateFormat('dd/MM/yyyy').format(viaje.fecha)}'),
          Text('Usuario: ${viaje.nombreUsuario}'),
          for (var detalle in viaje.detalles)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Distancia Total: ${detalle.distanciaTotal} km'),
                  Text('Costo: L${detalle.costo}'),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
