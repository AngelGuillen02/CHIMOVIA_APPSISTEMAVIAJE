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

  @override
  void initState() {
    super.initState();
    // Load the collaborators when the screen is first initialized
    BlocProvider.of<ColaboradoresBloc>(context).add(LoadColaboradores());
    //context.read<ColaboradoresBloc>().add(LoadColaboradores());
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
        // TODO: implement listener
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Collaborators',
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
          onPressed: () {
            // Add action for new collaborator
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Add new collaborator pressed')),
            );
          },
          backgroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 4,
          child: Icon(Icons.add, size: 28),
        ),
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
            hintText: 'buscar colaborador',
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
                'No collaborators found',
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
        return Center(child: Text('No collaborators available'));
      },
    );
  }

  Widget _buildCollaboratorCard(Dato collaborator) {
    //final dateFormat = DateFormat('MMM dd, yyyy');
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
            collaborator.sexo == Sexo.M ? 'Masculino' : 'Femenino',
          ),
          //_buildInfoRow('Birth Date', dateFormat.format(collaborator.fechaNacimiento)),
          _buildInfoRow('Cargo', collaborator.cargoDescripcion.toString().split('.').last),
   
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
      Color(0xFF2E86C1), // Blue
      Color(0xFF2ECC71), // Green
      Color(0xFF16A085), // Teal
      Color(0xFF3498DB), // Light Blue
      Color(0xFF27AE60), // Emerald
    ];
    final int index = letter.codeUnitAt(0) % colors.length;
    return colors[index];
  }
}
