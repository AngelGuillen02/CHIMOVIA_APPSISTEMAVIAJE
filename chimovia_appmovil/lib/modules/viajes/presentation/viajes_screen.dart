import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:chimovia_appmovil/config/enviroment.dart';
import 'package:chimovia_appmovil/modules/viajes/bloc/viajes_bloc_bloc.dart';
import 'package:chimovia_appmovil/modules/viajes/domain/entities/viajes.dart';
import 'package:chimovia_appmovil/modules/viajes/presentation/widgets/lista_viajes.dart';

class ViajesScreen extends StatefulWidget {
  const ViajesScreen({super.key});

  @override
  ViajesScreenState createState() => ViajesScreenState();
}

class ViajesScreenState extends State<ViajesScreen> {
  final TextEditingController _buscarController = TextEditingController();
  String _buscarQuery = '';

  void agregarViaje(Viajes viaje) {
    context.read<ViajesBlocBloc>().add(AgregarViaje(viaje: viaje));
  }

  @override
  void initState() {
    super.initState();
    context.read<ViajesBlocBloc>().add(CargarViajes());
      SystemChannels.textInput.invokeMethod('TextInput.hide');

  }

  List<Viajes> get _filtrarViaje {
    final estadoActual = context.read<ViajesBlocBloc>().state;
    if (estadoActual is ViajesCargadosLista) {
      if (_buscarQuery.isEmpty) {
        return estadoActual.viajes;
      }
      return estadoActual.viajes.where((viaje) {
        final String descripcion = viaje.descripcion.toLowerCase();
        return descripcion.contains(_buscarQuery.toLowerCase());
      }).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ViajesBlocBloc, ViajesBlocState>(
      listener: (context, state) {
        if (state is ViajesError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.mensaje)));
        } else if (state is ViajesCargadosLista) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Viajes actualizados')));
        }
      },
      child: BlocBuilder<ViajesBlocBloc, ViajesBlocState>(
        builder: (context, state) {
          if (state is ViajesBlocInitial) {
            return const Center(child: Text('Cargando viajes...'));
          } else if (state is ViajesCargados) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ViajesError) {
            return Center(child: Text('Error: ${state.mensaje}'));
          } else if (state is ViajesCargadosLista) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Viajes',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              body: Column(
                children: [
                  _barraBuscar(),
                  Expanded(child: ListaViajes(viajesFiltrados: _filtrarViaje)),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed:
                    () => showDialog(
                      context: context,
                      builder:
                          (context) => _AgregarViajeDialog(onAdd: agregarViaje),
                    ),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                elevation: 4,
                child: const Icon(Icons.add, size: 28),
              ),
            );
          }
          return const Center(child: Text('Estado desconocido'));
        },
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: TextField(
          controller: _buscarController,
          onChanged: (value) => setState(() => _buscarQuery = value),
          decoration: InputDecoration(
            hintText: 'Buscar viaje',
            prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
            suffixIcon:
                _buscarQuery.isNotEmpty
                    ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey[600]),
                      onPressed: () {
                        _buscarController.clear();
                        setState(() => _buscarQuery = '');
                        FocusScope.of(context).unfocus();
                      },
                    )
                    : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }
}

class _AgregarViajeDialog extends StatefulWidget {
  final Function(Viajes) onAdd;

  const _AgregarViajeDialog({required this.onAdd});

  @override
  State<_AgregarViajeDialog> createState() => _AgregarViajeDialogState();
}

class _AgregarViajeDialogState extends State<_AgregarViajeDialog> {
  final formKey = GlobalKey<FormState>();
  final descripcionController = TextEditingController();
  final fechaController = TextEditingController();
  final horaLlegadaController = TextEditingController();

  int? selectedTransportistaId;
  int? selectedSucursalId;
  List<int> selectedColaboradores = [];

  List<Map<String, dynamic>> transportistas = [];
  List<Map<String, dynamic>> sucursales = [];
  List<Map<String, dynamic>> colaboradores = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAllData();
  }

  Future<void> loadTransportistas() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${EnviromentApi.apiUrl}/Transportista/ListadoTransportistas',
        ),
        headers: {'Content-Type': 'application/json'},
      );
 

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
          transportistas = List<Map<String, dynamic>>.from(data);
        });
      } else {
        _showError('Error al cargar transportistas: ${response.reasonPhrase}');
      }
    } catch (e) {
      _showError('Error al cargar transportistas: $e');
    }
  }

  Future<void> loadSucursales() async {
    try {
      final response = await http.get(
        Uri.parse('${EnviromentApi.apiUrl}/Sucursales/ListadoSucursales'),
        headers: {'Content-Type': 'application/json'},
      );


      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
          sucursales = List<Map<String, dynamic>>.from(data);
        });
      } else {
        _showError('Error al cargar sucursales: ${response.reasonPhrase}');
      }
    } catch (e) {
      _showError('Error al cargar sucursales: $e');
    }
  }

  Future<void> loadColaboradores() async {
    try {
      final response = await http.get(
        Uri.parse('${EnviromentApi.apiUrl}/colaboradores/ListadoColaboradores'),
        headers: {'Content-Type': 'application/json'},
      );
     

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
   
        if (data['datos'] is String) {
          final decodedDatos = jsonDecode(data['datos'] as String);
          if (decodedDatos is List) {
            setState(() {
              colaboradores = List<Map<String, dynamic>>.from(decodedDatos);
            });
          } else {
            _showError(
              'Error: "datos" no es una lista válida en colaboradores',
            );
          }
        } else if (data['datos'] is List) {
          setState(() {
            colaboradores = List<Map<String, dynamic>>.from(data['datos']);
          });
        } else {
          _showError('Error: formato inesperado de "datos" en colaboradores');
        }
      } else {
        _showError('Error al cargar colaboradores: ${response.reasonPhrase}');
      }
    } catch (e) {
      _showError('Error al cargar colaboradores: $e');
    }
  }

  Future<void> loadAllData() async {
    setState(() => isLoading = true);
    await Future.wait([
      loadTransportistas(),
      loadSucursales(),
      loadColaboradores(),
    ]);
    setState(() => isLoading = false);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar Viaje'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: descripcionController,
                          decoration: const InputDecoration(
                            labelText: 'Descripción del Viaje',
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Descripción es requerida'
                                      : null,
                        ),
                        DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: 'Transportista',
                          ),
                          hint: const Text('Seleccione transportista'),
                          items:
                              transportistas.map((transportista) {
                                return DropdownMenuItem<int>(
                                  value: transportista['transportista_Id'],
                                  child: Text(
                                    transportista['nombre'] ?? 'Sin nombre',
                                  ),
                                );
                              }).toList(),
                          onChanged:
                              (value) => setState(
                                () => selectedTransportistaId = value,
                              ),
                          validator:
                              (value) =>
                                  value == null
                                      ? 'Transportista es requerido'
                                      : null,
                        ),
                        DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: 'Sucursal',
                          ),
                          hint: const Text('Seleccione sucursal'),
                          items:
                              sucursales.map((sucursal) {
                                return DropdownMenuItem<int>(
                                  value: sucursal['sucursal_Id'],
                                  child: Text(
                                    sucursal['nombre'] ?? 'Sin nombre',
                                  ),
                                );
                              }).toList(),
                          onChanged:
                              (value) =>
                                  setState(() => selectedSucursalId = value),
                          validator:
                              (value) =>
                                  value == null
                                      ? 'Sucursal es requerida'
                                      : null,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Seleccione Colaboradores',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: colaboradores.length,
                            itemBuilder: (context, index) {
                              final colaborador = colaboradores[index];
                              return CheckboxListTile(
                                title: Text(
                                  '${colaborador['nombre']} ${colaborador['apellido'] ?? ''}',
                                ),
                                value: selectedColaboradores.contains(
                                  colaborador['colaborador_Id'],
                                ),
                                onChanged: (bool? selected) {
                                  setState(() {
                                    if (selected == true) {
                                      selectedColaboradores.add(
                                        colaborador['colaborador_Id'],
                                      );
                                    } else {
                                      selectedColaboradores.remove(
                                        colaborador['colaborador_Id'],
                                      );
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        TextFormField(
                          controller: fechaController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Fecha del Viaje',
                          ),
                          onTap: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                fechaController.text = DateFormat(
                                  'yyyy-MM-dd',
                                ).format(selectedDate);
                              });
                            }
                          },
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Fecha es requerida'
                                      : null,
                        ),
                        TextFormField(
                          controller: horaLlegadaController,
                          decoration: const InputDecoration(
                            labelText: 'Hora de Llegada (HH:MM:SS)',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Hora de llegada es requerida';
                            if (!RegExp(r'^\d{2}:\d{2}:\d{2}$').hasMatch(value))
                              return 'Formato HH:MM:SS requerido';
                            return null;
                          },
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
            if (formKey.currentState!.validate() &&
                selectedColaboradores.isNotEmpty) {
              final nuevoViaje = Viajes(
                viajeId: 0,
                descripcion: descripcionController.text,
                distanciaParcial: 0.0,
                fecha: DateTime.parse(fechaController.text),
                horaLlegada: horaLlegadaController.text,
                transportistaId: selectedTransportistaId!,
                sucursalId: selectedSucursalId!,
                nombreUsuario: 'Usuario Actual', 
                usuarioId: 1, 
                detalles:
                    selectedColaboradores
                        .map(
                          (id) => Detalle(
                            viajeDetalleId: 0,
                            distanciaTotal: 0.0, 
                            costo: 0.0, 
                            fecha: DateTime.parse(fechaController.text),
                            solicitudViajeId: null,
                            viajeId: 0,
                            colaboradorId: id,
                            usuarioId: null,
                          ),
                        )
                        .toList(),
              );
              widget.onAdd(nuevoViaje);
              Navigator.pop(context);
            } else if (selectedColaboradores.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Debe seleccionar al menos un colaborador'),
                ),
              );
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
