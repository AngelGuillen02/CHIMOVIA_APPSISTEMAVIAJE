import 'package:chimovia_appmovil/modules/colaboradores/bloc/colaboradores_bloc_bloc.dart';
import 'package:chimovia_appmovil/modules/colaboradores/bloc/colaboradores_bloc_event.dart';
import 'package:chimovia_appmovil/modules/colaboradores/bloc/colaboradores_bloc_state.dart';
import 'package:chimovia_appmovil/modules/colaboradores/domain/entities/colaborador.dart';
import 'package:chimovia_appmovil/modules/colaboradores/presentation/widgets/lista_colaboradores.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CollaboratorsScreen extends StatefulWidget {
  const CollaboratorsScreen({super.key});

  @override
  CollaboratorsScreenState createState() => CollaboratorsScreenState();
}

class CollaboratorsScreenState extends State<CollaboratorsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  void agregarColaborador(Colaboradores colaborador) {
    context.read<ColaboradoresBloc>().add(
      AddColaborador(colaborador: colaborador),
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    context.read<ColaboradoresBloc>().add(LoadColaboradores());
  }

  List<Dato> get _filteredCollaborators {
    final currentState = context.read<ColaboradoresBloc>().state;
    if (currentState is ColaboradoresLoaded) {
      if (_searchQuery.isEmpty) {
        return currentState.colaboradores;
      }
      return currentState.colaboradores.where((collaborator) {
        final String fullName =
            '${collaborator.nombre} ${collaborator.apellido}'.toLowerCase();
        return fullName.contains(_searchQuery.toLowerCase());
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
        } else if (state is ColaboradoresLoaded) {
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
                _buildSearchBar(),
                Expanded(
                  child: ListaColaboradores(
                    colaboradoresFiltrados: _filteredCollaborators,
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed:
                  () => _showAddCollaboratorDialog(context, agregarColaborador),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              elevation: 4,
              child: Icon(Icons.add, size: 28),
            ),
          );
        },
      ),
    );
  }

 void _showAddCollaboratorDialog(
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
  String? selectedGender;
  final cargoController = TextEditingController();
  final latitudController = TextEditingController();
  final longitudController = TextEditingController();
  DateTime? selectedBirthDate;
  int? selectedCargoId;

  final List<Map<String, dynamic>> _cargos = [
    {"id": 3, "descripcion": "Chofer"},
    {"id": 2, "descripcion": "Gerente"},
  ];

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Agregar Colaborador'),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.9,
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
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
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
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
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
                      .map(
                        (gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(
                            gender == 'M' ? 'Masculino' : 'Femenino',
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    selectedGender = value;
                  },
                  validator: (value) {
                    if (value == null || (value != 'M' && value != 'F')) {
                      return 'Seleccione un sexo válido (M o F)';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Cargo'),
                  value: selectedCargoId,
                  items: _cargos.map((cargo) {
                    return DropdownMenuItem<int>(
                      value: cargo['id'],
                      child: Text(cargo['descripcion']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedCargoId = value;
                  },
                  validator: (value) {
                    if (value == null || value <= 0) {
                      return 'Seleccione un cargo válido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: fechaController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Fecha de Nacimiento',
                  ),
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedBirthDate ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (selectedDate != null) {
                      selectedBirthDate = selectedDate;
                      fechaController.text = 
                          DateFormat('dd/MM/yyyy').format(selectedDate);
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
                TextFormField(
                  controller: latitudController,
                  decoration: const InputDecoration(labelText: 'Latitud'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final lat = double.tryParse(value);
                      if (lat != null && (lat < -90 || lat > 90)) {
                        return 'Latitud debe estar entre -90 y 90';
                      }
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: longitudController,
                  decoration: const InputDecoration(labelText: 'Longitud'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final lon = double.tryParse(value);
                      if (lon != null && (lon < -180 || lon > 180)) {
                        return 'Longitud debe estar entre -180 y 180';
                      }
                    }
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
            if (formKey.currentState!.validate()) {
              if (selectedGender != null &&
                  selectedCargoId != null &&
                  selectedBirthDate != null) {
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
                      latitud: latitudController.text.isEmpty 
                          ? null 
                          : double.parse(latitudController.text),
                      longitud: longitudController.text.isEmpty 
                          ? null 
                          : double.parse(longitudController.text),
                      cargoDescripcion: _cargos
                          .firstWhere((cargo) => cargo['id'] == selectedCargoId)['descripcion']!,
                      cargoId: selectedCargoId!,
                    ),
                  ],
                );
                onAdd(nuevoColaborador);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Por favor, seleccione todos los campos.'),
                  ),
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

  Widget _buildSearchBar() {
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
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Buscar colaborador',
            prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
            suffixIcon:
                _searchQuery.isNotEmpty
                    ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey[600]),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
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
