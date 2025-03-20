import 'package:chimovia_appmovil/modules/colaboradores/bloc/colaboradores_bloc_bloc.dart';
import 'package:chimovia_appmovil/modules/colaboradores/bloc/colaboradores_bloc_event.dart';
import 'package:chimovia_appmovil/modules/colaboradores/bloc/colaboradores_bloc_state.dart';
import 'package:chimovia_appmovil/modules/colaboradores/domain/entities/colaborador.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollaboratorsScreen extends StatefulWidget {
  const CollaboratorsScreen({super.key});

  @override
  CollaboratorsScreenState createState() => CollaboratorsScreenState();
}

class CollaboratorsScreenState extends State<CollaboratorsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';


  void agregarColaborador(Colaboradores colaborador) {
    context.read<ColaboradoresBloc>().add(AddColaborador(colaborador: colaborador));
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
                Expanded(child: _buildCollaboratorsList()),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showAddCollaboratorDialog(context,agregarColaborador),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              elevation: 4,
              child: Icon(Icons.add, size: 28),
            ),
          );
        },
      ),
    );
  }

  void _showAddCollaboratorDialog(BuildContext context, Function(Colaboradores) onAdd) {
    final formKey = GlobalKey<FormState>();
    final nombreController = TextEditingController();
    final apellidoController = TextEditingController();
    final identidadController = TextEditingController();
    final telefonoController = TextEditingController();
    final emailController = TextEditingController();
    String? selectedGender;
    final cargoController = TextEditingController();
    final latitudController = TextEditingController();
    final longitudController = TextEditingController(); // Callback para seleccionar la fecha
    
    DateTime?
    selectedBirthDate; // Variable para almacenar la fecha seleccionada
    int? selectedCargoId;

    // List of cargos
    final List<Map<String, dynamic>> _cargos = [
      {"id": 1, "description": "Chofer"},
      {"id": 2, "description": "Gerente"},
      {"id": 3, "description": "Supervisor"},
      // Add more cargos if needed
    ];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Agregar Colaborador'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Primer Nombre',
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty
                                  ? 'Primer Nombre es requerido'
                                  : null,
                    ),
                    TextFormField(
                      controller: apellidoController,
                      decoration: const InputDecoration(
                        labelText: 'Primer Apellido',
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty
                                  ? 'Primer Apellido es requerido'
                                  : null,
                    ),
                    TextFormField(
                      controller: identidadController,
                      decoration: const InputDecoration(labelText: 'Identidad'),
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Identidad es requerido' : null,
                    ),
                    TextFormField(
                      controller: telefonoController,
                      decoration: const InputDecoration(labelText: 'Telefono'),
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Telefono es requerido' : null,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Correo'),
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Correo es requerido' : null,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Sexo'),
                      items:
                          ['M', 'F']
                              .map(
                                (gender) => DropdownMenuItem(
                                  value: gender,
                                  child: Text(
                                    gender == 'M' ? 'Masculino' : 'Femenino',
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged:
                          (value) => setState(() {
                            selectedGender = value;
                          }),
                      validator:
                          (value) => value == null ? 'Sexo es requerido' : null,
                    ),
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(labelText: 'Cargo'),
                      value: selectedCargoId,
                      items:
                          _cargos.map((cargo) {
                            return DropdownMenuItem<int>(
                              value: cargo['id'],
                              child: Text(cargo['description']),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCargoId = value;
                        });
                      },
                      validator:
                          (value) =>
                              value == null ? 'Seleccione un cargo' : null,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedBirthDate ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            selectedBirthDate = selectedDate;
                            
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Fecha de Nacimiento',
                            hintText:
                                selectedBirthDate != null
                                    ? "${selectedBirthDate!.day}/${selectedBirthDate!.month}/${selectedBirthDate!.year}"
                                    : "Seleccionar Fecha",
                          ),
                          // validator: (value) =>
                          //     value!.isEmpty ? 'Fecha de Nacimiento es requerida' : null,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: latitudController,
                      decoration: const InputDecoration(labelText: 'Latitud'),
                      keyboardType: TextInputType.number,
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Latitud es requerido' : null,
                    ),
                    TextFormField(
                      controller: longitudController,
                      decoration: const InputDecoration(labelText: 'Longitud'),
                      keyboardType: TextInputType.number,
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Longitud es requerido' : null,
                    ),
                  ],
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

                            latitud: double.parse(latitudController.text),
                            longitud: double.parse(longitudController.text),
                            cargoDescripcion:
                                _cargos.firstWhere(
                                  (cargo) => cargo['id'] == selectedCargoId,
                                )['description']!,
                            cargoId: selectedCargoId!,
                          ),
                        ],
                      );
                      onAdd(nuevoColaborador);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Por favor, seleccione todos los campos.',
                          ),
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

  Widget _buildCollaboratorsList() {
    return BlocBuilder<ColaboradoresBloc, ColaboradoresState>(
      builder: (context, state) {
        if (state is ColaboradoresLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ColaboradoresError) {
          return Center(child: Text(state.message));
        } else if (state is ColaboradoresLoaded) {
          if (_filteredCollaborators.isEmpty) {
            return Center(
              child: Text(
                'Colaborador no encontrado',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _filteredCollaborators.length,
            itemBuilder: (context, index) {
              final collaborator = _filteredCollaborators[index];
              return _buildCollaboratorCard(collaborator);
            },
          );
        }
        return Center(child: Text('Colaborador no disponible'));
      },
    );
  }

  Widget _buildCollaboratorCard(Dato collaborator) {
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
              backgroundColor: _getColorForLetter(collaborator.nombre[0]),
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
          _buildInfoRow('identidad', collaborator.identidad),
          _buildInfoRow('telefono', collaborator.telefono),
          _buildInfoRow(
            'sexo',
            collaborator.sexo == 'M' ? 'Masculino' : 'Femenino',
          ),
          _buildInfoRow(
            'Cargo',
            collaborator.cargoDescripcion.toString().split('.').last,
          ),
          _buildInfoRow(
            'Localizacion',
            '${collaborator.latitud ?? "N/A"}, ${collaborator.longitud ?? "N/A"}',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(child: Text(value, style: TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }

  Color _getColorForLetter(String letter) {
    final List<Color> colors = [
      Color(0xFF2E86C1),
      Color(0xFF2ECC71),
      Color(0xFF16A085),
      Color(0xFF3498DB),
      Color(0xFF27AE60),
    ];
    final int index = letter.codeUnitAt(0) % colors.length;
    return colors[index];
  }
}
