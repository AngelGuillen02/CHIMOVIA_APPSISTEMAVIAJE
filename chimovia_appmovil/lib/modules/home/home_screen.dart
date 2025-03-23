import 'package:chimovia_appmovil/modules/asignacion/bloc/asignaciones_bloc_bloc.dart';
import 'package:chimovia_appmovil/modules/asignacion/infraestructure/datasource/asignacion_datasource_implementacion.dart';
import 'package:chimovia_appmovil/modules/asignacion/infraestructure/repository/asignacion_repository_implementacion.dart';
import 'package:chimovia_appmovil/modules/asignacion/presentation/asignacion_screen.dart';
import 'package:chimovia_appmovil/modules/colaboradores/bloc/colaboradores_bloc_bloc.dart';
import 'package:chimovia_appmovil/modules/colaboradores/bloc/colaboradores_bloc_state.dart';
import 'package:chimovia_appmovil/modules/colaboradores/infraestructure/datasource/colaboradores_datasoruce_implementacion.dart';
import 'package:chimovia_appmovil/modules/colaboradores/infraestructure/repository/colaborador_repository_implementacion.dart';
import 'package:chimovia_appmovil/modules/colaboradores/presentation/colaboradores_screen.dart';
import 'package:chimovia_appmovil/modules/viajes/bloc/viajes_bloc_bloc.dart';
import 'package:chimovia_appmovil/modules/viajes/infraestructure/datasource/viajes_datasource_implementacion.dart';
import 'package:chimovia_appmovil/modules/viajes/infraestructure/repository/viaje_repository_implementacion.dart';
import 'package:chimovia_appmovil/modules/viajes/presentation/viajes_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CHIMOVIA APP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: colorPrimario,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: colorPrimario,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

const colorPrimario = Color(0xFF72A6F8);
const scaffoldBackgroundColor = Color.fromARGB(255, 108, 49, 49);
const accentColor = Color(0xFF6B7FD7);
const colorTexto = Color.fromARGB(255, 0, 0, 0);
const sidebarColor = Color(0xFF568DF5);

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = [
    const home_screens(),
    BlocProvider(
      create:
          (context) => ColaboradoresBloc(
            repository: ColaboradoresRepositoryImpl(
              dataSource: ColaboradoresDataSourceImpl(),
            ),
          ),
      child: ColaboradorsScreen(),
    ),
      BlocProvider(
      create:
          (context) => AsignacionesBlocBloc(
            repository: AsignacionesRepositoryImpl(
              dataSource: AsignacionesDataSourceImpl(),
            ),
          ),
      child: AsignacionesScreen(),
    ),
    BlocProvider(
      create:
          (context) => ViajesBlocBloc(
            repository: ViajesRepositoryImpl(
              dataSource: ViajesDataSourceImpl(),
            ),
          ),
      child: ViajesScreen(),
    ),
      
  ];

  void _alPrecionarlo(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ColaboradoresBloc, ColaboradoresState>(
          listener: (context, state) {},
        ),
        BlocListener<ViajesBlocBloc, ViajesBlocState>(
          listener: (context, state) {},
        ),
         BlocListener<AsignacionesBlocBloc, AsignacionesBlocState>(
          listener: (context, state) {},
        ),
      ],
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: sidebarColor,
          title: _tituloIndice(_selectedIndex),
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Color.fromARGB(255, 255, 255, 255)),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ),
        drawer: AppDrawer(
          selectedIndex: _selectedIndex,
          onItemSelected: _alPrecionarlo,
        ),
        body: _screens[_selectedIndex],
      ),
    );
  }

  Widget _tituloIndice(int index) {
    switch (index) {
      case 0:
        return const Text('Inicio');
      case 1:
        return const Text('Colaboradores');
      case 2:
        return const Text('Asignaciones');
      case 3:
        return const Text('Viajes');
      default:
        return const Text('Inicio');
    }
  }
}

class AppDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const AppDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: sidebarColor,
        child: Column(
          children: [
            const SizedBox(height: 80),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _elementoSidebar(
                    icon: Icons.home_outlined,
                    title: 'Inicio',
                    index: 0,
                  ),
                  _elementoSidebar(
                    icon: Icons.people_outline,
                    title: 'Colaboradores',
                    index: 1,
                  ),
              
                  _elementoSidebar(
                    icon: Icons.bus_alert_outlined,
                    title: 'Viajes',
                    index: 3,
                  ),
                  const Divider(
                    color: Colors.white24,
                    thickness: 0.5,
                    height: 20,
                    indent: 16,
                    endIndent: 16,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.logout, color: colorTexto),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () async {
                      final bool? confirmLogout = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Cerrar sesión'),
                            content: const Text(
                              '¿Estás seguro de que deseas cerrar sesión?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: const Text('Aceptar'),
                              ),
                            ],
                          );
                        },
                      );
                      if (confirmLogout ?? false) {
                        context.go('/');
                      }
                    },
                    child: const Text(
                      'Cerrar sesión',
                      style: TextStyle(color: colorTexto),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _elementoSidebar({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final bool isSelected = selectedIndex == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? const Color.fromARGB(255, 0, 0, 0) : colorTexto),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? colorTexto : colorTexto,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () => onItemSelected(index),
      tileColor: isSelected ? accentColor.withOpacity(0.1) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      minLeadingWidth: 24,
    );
  }
}

class home_screens extends StatelessWidget {
  const home_screens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pantalla de Inicio"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: const Text(
                  "Pantalla de Colaboradores",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: const Text(
                  "En esta pantalla podrás gestionar todos los colaboradores de la plataforma. Se pueden agregar nuevos colaboradores, con la facilidad que la tecnologia no ofrece.",
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: const Text(
                  "Pantalla de Viajes",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: const Text(
                  "Esta pantalla está dedicada a la gestión de viajes. Permite crear viajes y hacer seguimiento de los viajes de los colaboradores, incluyendo detalles como la ruta, el tiempo estimado y el estado del viaje.",
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


