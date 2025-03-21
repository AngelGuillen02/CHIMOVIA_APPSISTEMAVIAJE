

import 'package:chimovia_appmovil/modules/colaboradores/bloc/colaboradores_bloc_bloc.dart';
import 'package:chimovia_appmovil/modules/colaboradores/bloc/colaboradores_bloc_event.dart';
import 'package:chimovia_appmovil/modules/colaboradores/bloc/colaboradores_bloc_state.dart';
import 'package:chimovia_appmovil/modules/colaboradores/domain/entities/colaborador.dart';
import 'package:chimovia_appmovil/modules/colaboradores/presentation/widgets/lista_colaboradores.dart';
import 'package:chimovia_appmovil/modules/colaboradores/presentation/widgets/mapa_colaborador.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class ColaboradorsScreen extends StatefulWidget {
  const ColaboradorsScreen({super.key});

  @override
  ColaboradorsScreenState createState() => ColaboradorsScreenState();
} 

class ColaboradorsScreenState extends State<ColaboradorsScreen> {
  final TextEditingController _buscarController = TextEditingController();
  String _buscarQuery = '';

 void _onDistanceCalculated(double distance) {
    setState(() {
      _calculatedDistance = distance;
    });
  }
  double? _calculatedDistance; 

  void agregarColaborador(Colaboradores colaborador) {
    context.read<ColaboradoresBloc>().add(
      AgregarColaborador(colaborador: colaborador),
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    context.read<ColaboradoresBloc>().add(CargarColaboradores());
  }

  List<Dato> get _filtrarcolaborador {
    final estadoActual = context.read<ColaboradoresBloc>().state;
    if (estadoActual is ColaboradoresCargadosLista) {
      if (_buscarQuery.isEmpty) {
        return estadoActual.colaboradores;
      }
      return estadoActual.colaboradores.where((collaborator) {
        final String nombreCompleto =
            '${collaborator.nombre} ${collaborator.apellido}'.toLowerCase();
        return nombreCompleto.contains(_buscarQuery.toLowerCase());
      }).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ColaboradoresBloc, ColaboradoresState>(
      listener: (context, state) {
        if (state is ColaboradoresError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is ColaboradoresCargadosLista) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Colaboradores actualizados')));
        }
      },
      child: BlocBuilder<ColaboradoresBloc, ColaboradoresState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Colaborador',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            body: Column(
              children: [
                _barraBuscar(),
                Expanded(
                  child: ListaColaboradores(
                    colaboradoresFiltrados: _filtrarcolaborador,
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed:
                  () => _agregarColaboradorShowDialog(context, agregarColaborador),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              elevation: 4,
              child: Icon(Icons.add, size: 28),
            ),
          );
        },
      ),
    );
  }

void _agregarColaboradorShowDialog(
    BuildContext context,
    Function(Colaboradores) onAdd,
) {
  final formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final identidadController = TextEditingController();
  final telefonoController = TextEditingController();
  final emailController = TextEditingController();
  final fechaController = TextEditingController();
  final direccionController = TextEditingController();
  String? selectedGender;
  int? selectedCargoId;
  DateTime? selectedBirthDate;
  LatLng? selectedLocation;

  final List<Map<String, dynamic>> cargos = [
    {"id": 3, "descripcion": "Chofer"},
    {"id": 2, "descripcion": "Gerente"},
  ];

  void openStreetMapScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OpenStreetMapScreen(
          onLocationSelected: (LatLng point, String address) {
            
            setState(() {
              selectedLocation = point;
              direccionController.text = address;
            });
          },
        ),
      ),
    );
  }

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Agregar Colaborador'),
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
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: 'Primer Nombre'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El nombre es requerido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: apellidoController,
                  decoration: const InputDecoration(labelText: 'Primer Apellido'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El apellido es requerido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: identidadController,
                  decoration: const InputDecoration(labelText: 'Identidad'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La identidad es requerida';
                    }
                    if (!RegExp(r'^\d+$').hasMatch(value)) {
                      return 'La identidad debe contener solo números';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: telefonoController,
                  decoration: const InputDecoration(labelText: 'Telefono'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value != null && value.isNotEmpty && value.length < 8) {
                      return 'El número de teléfono debe tener al menos 8 dígitos';
                    }
                    if (value != null && value.isNotEmpty && !RegExp(r'^\d+$').hasMatch(value)) {
                      return 'El teléfono debe contener solo números';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Correo'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El correo es requerido';
                    }
                    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
                      return 'Formato de correo inválido';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Sexo'),
                  value: selectedGender,
                  items: ['M', 'F']
                      .map((gender) => DropdownMenuItem(
                            value: gender,
                            child: Text(gender == 'M' ? 'Masculino' : 'Femenino'),
                          ))
                      .toList(),
                  onChanged: (value) => selectedGender = value,
                  validator: (value) => value == null ? 'Seleccione un sexo válido (M o F)' : null,
                ),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Cargo'),
                  value: selectedCargoId,
                  items: cargos
                      .map((cargo) => DropdownMenuItem<int>(
                            value: cargo['id'],
                            child: Text(cargo['descripcion']),
                          ))
                      .toList(),
                  onChanged: (value) => selectedCargoId = value,
                  validator: (value) => value == null ? 'Seleccione un cargo válido' : null,
                ),
                TextFormField(
                  controller: fechaController,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Fecha de Nacimiento'),
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedBirthDate ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (selectedDate != null) {
                      selectedBirthDate = selectedDate;
                      fechaController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Fecha de nacimiento es requerida';
                    }
                    if (selectedBirthDate != null) {
                      if (selectedBirthDate!.isAfter(DateTime.now())) {
                        return 'La fecha de nacimiento no puede ser futura';
                      }
                      if (DateTime.now().year - selectedBirthDate!.year < 18) {
                        return 'El colaborador debe tener al menos 18 años';
                      }
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Ubicación del Colaborador",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: direccionController,
                        decoration: const InputDecoration(
                          labelText: 'Dirección',
                          hintText: 'Seleccione una ubicación en el mapa',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor seleccione una ubicación';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: openStreetMapScreen,
                        child: Text('Seleccionar Ubicación en el Mapa'),
                      ),
                    ],
                  ),
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
              if (selectedGender != null && selectedCargoId != null && selectedBirthDate != null && selectedLocation != null) {
                final nuevoColaborador = Colaboradores(
                  valido: true,
                  mensaje: 'Colaborador agregado',
                  datos: [
                    Dato(
                      colaboradorId: 0,
                      identidad: identidadController.text,
                      nombre: nombreController.text,
                      apellido: apellidoController.text,
                      telefono: telefonoController.text,
                      email: emailController.text,
                      sexo: selectedGender!,
                      fechaNacimiento: selectedBirthDate!,
                      latitud: selectedLocation!.latitude,
                      longitud: selectedLocation!.longitude,
                      cargoDescripcion: cargos
                          .firstWhere((cargo) => cargo['id'] == selectedCargoId)['descripcion']!,
                      cargoId: selectedCargoId!,
                      direccion: direccionController.text,
                    ),
                  ],
                );
                onAdd(nuevoColaborador);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Por favor, complete todos los campos requeridos.')),
                );
              }
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
          onChanged: (value) {
            setState(() {
              _buscarQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Buscar colaborador',
            prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
            suffixIcon:
                _buscarQuery.isNotEmpty
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
