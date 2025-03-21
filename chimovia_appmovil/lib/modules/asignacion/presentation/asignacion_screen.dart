import 'package:chimovia_appmovil/modules/asignacion/bloc/asignaciones_bloc_bloc.dart';
import 'package:chimovia_appmovil/modules/asignacion/domain/entities/asignacion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AsignacionesScreen extends StatefulWidget {
  const AsignacionesScreen({super.key});

  @override
  AsignacionesScreenState createState() => AsignacionesScreenState();
}

class AsignacionesScreenState extends State<AsignacionesScreen> {
  final TextEditingController _buscarController = TextEditingController();
  String _buscarQuery = '';

  void agregarAsignacion(Asignacion asignacion) {
    context.read<AsignacionesBlocBloc>().add(AgregarAsignacion(asignacion: asignacion));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    context.read<AsignacionesBlocBloc>().add(CargarAsignaciones());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  List<Asignacion> get _filtrarAsignaciones {
    final estadoActual = context.read<AsignacionesBlocBloc>().state;
    if (estadoActual is AsignacionesCargadasLista) {
      if (_buscarQuery.isEmpty) {
        return estadoActual.asignaciones;
      }
      return estadoActual.asignaciones.where((asignacion) {
        final String sucursalId = asignacion.sucursalId.toString();
        return sucursalId.contains(_buscarQuery);
      }).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AsignacionesBlocBloc, AsignacionesBlocState>(
      listener: (context, state) {
        if (state is AsignacionesError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.mensaje)));
        } else if (state is AsignacionesCargadasLista) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Asignaciones actualizadas')));
        }
      },
      child: BlocBuilder<AsignacionesBlocBloc, AsignacionesBlocState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Asignaciones', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            body: Column(
              children: [
                _barraBuscar(),
                Expanded(
                  child: ListaAsignaciones(
                    asignacionesFiltradas: _filtrarAsignaciones,
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _agregarAsignacionShowDialog(context, agregarAsignacion),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              elevation: 4,
              child: Icon(Icons.add, size: 28),
            ),
          );
        },
      ),
    );
  }

  void _agregarAsignacionShowDialog(BuildContext context, Function(Asignacion) onAdd) {
    final formKey = GlobalKey<FormState>();
    final sucursalIdController = TextEditingController();
    final colaboradorIdController = TextEditingController();
    String? selectedEstado;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar Asignación'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.8,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: sucursalIdController,
                    decoration: const InputDecoration(labelText: 'Sucursal ID'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El ID de sucursal es requerido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: colaboradorIdController,
                    decoration: const InputDecoration(labelText: 'Colaborador ID'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El ID de colaborador es requerido';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Estado'),
                    value: selectedEstado,
                    items: ['Activo', 'Inactivo']
                        .map((estado) => DropdownMenuItem(value: estado, child: Text(estado)))
                        .toList(),
                    onChanged: (value) => selectedEstado = value,
                    validator: (value) => value == null ? 'Seleccione un estado' : null,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final nuevaAsignacion = Asignacion(
                  sucursalColaboradoresDetalleId: 0,
                  sucursalId: int.parse(sucursalIdController.text),
                  colaboradorId: int.parse(colaboradorIdController.text),
                  estado: selectedEstado,
                );
                onAdd(nuevaAsignacion);
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Widget _barraBuscar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, spreadRadius: 1)],
        ),
        child: TextField(
          controller: _buscarController,
          onChanged: (value) {
            setState(() {
              _buscarQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Buscar asignación',
            prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
            suffixIcon: _buscarQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey[600]),
                    onPressed: () {
                      _buscarController.clear();
                      setState(() {
                        _buscarQuery = '';
                      });
                      FocusScope.of(context).unfocus();
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }
}

class ListaAsignaciones extends StatelessWidget {
  final List<Asignacion> asignacionesFiltradas;

  const ListaAsignaciones({super.key, required this.asignacionesFiltradas});

  @override
  Widget build(BuildContext context) {
    return _construirListaAsignaciones(asignacionesFiltradas);
  }
}

Widget _construirListaAsignaciones(List<Asignacion> asignacionesFiltradas) {
  return ListView.builder(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    itemCount: asignacionesFiltradas.length,
    itemBuilder: (context, index) {
      final asignacion = asignacionesFiltradas[index];
      return CardAsignaciones(asignacion: asignacion);
    },
  );
}

class CardAsignaciones extends StatelessWidget {
  final Asignacion asignacion;

  const CardAsignaciones({super.key, required this.asignacion});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text('Sucursal ID: ${asignacion.sucursalId}'),
        subtitle: Text('Colaborador ID: ${asignacion.colaboradorId}'),
        trailing: Text(asignacion.estado ?? 'N/A'),
        onTap: () {
        },
      ),
    );
  }
}
