import 'package:flutter/material.dart';

class BarraBusquedaColaboradores extends StatefulWidget {
  final TextEditingController searchController;

  const BarraBusquedaColaboradores({super.key, required this.searchController});

  @override
  State<BarraBusquedaColaboradores> createState() =>
      _BarraBusquedaColaboradoresState();
}

class _BarraBusquedaColaboradoresState
    extends State<BarraBusquedaColaboradores> {
  @override
  Widget build(BuildContext context) {
    return _barraBusqueda(widget.searchController, context);
  }
}

Widget _barraBusqueda(TextEditingController searchController, BuildContext context) {
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
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Buscar colaborador',
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[600]),
                  onPressed: () {
                    searchController.clear();
                    FocusScope.of(context).unfocus(); // Aquí ya tenemos acceso a 'context'
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
