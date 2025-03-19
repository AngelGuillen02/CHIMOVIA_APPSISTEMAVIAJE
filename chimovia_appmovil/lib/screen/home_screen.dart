import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drawer Navigation App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
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

// Colores para la aplicación
const primaryColor = Color(0xFF72A6F8);
const scaffoldBackgroundColor = Color.fromARGB(255, 220, 220, 220);
const accentColor = Color(0xFF6B7FD7);
const textColor = Color.fromARGB(255, 0, 0, 0);
const secondaryTextColor = Color.fromARGB(255, 0, 0, 0);
const drawerColor = Color(0xFF568DF5);

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = [
    const home_screens(),
    const ColaboradoresScreen(),
    const AsignacionesScreen(),
    const ViajesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: _getTitleForIndex(_selectedIndex),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color.fromARGB(255, 0, 0, 0)),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {},
          ),
        ],
      ),
      drawer: AppDrawer(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
      body: _screens[_selectedIndex],
    );
  }

  Widget _getTitleForIndex(int index) {
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
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: drawerColor,
        child: Column(
          children: [
            const SizedBox(height: 80),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    icon: Icons.home_outlined,
                    title: 'Inicio',
                    index: 0,
                  ),
                  _buildDrawerItem(
                    icon: Icons.search_outlined,
                    title: 'Colaboradores',
                    index: 1,
                  ),
                  _buildDrawerItem(
                    icon: Icons.people_outline,
                    title: 'Asignaciones',
                    index: 2,
                  ),
                  _buildDrawerItem(
                    icon: Icons.favorite_border_outlined,
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
                  const Icon(Icons.logout, color: secondaryTextColor),
                  const SizedBox(width: 10),
                  const Text(
                    'Cerrar sesión',
                    style: TextStyle(color: secondaryTextColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final bool isSelected = selectedIndex == index;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? accentColor : secondaryTextColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? textColor : secondaryTextColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () => onItemSelected(index),
      tileColor: isSelected ? accentColor.withOpacity(0.1) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      minLeadingWidth: 24,
    );
  }
}

// Pantallas individuales
class home_screens extends StatelessWidget {
  const home_screens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Pantalla de Inicio", style: TextStyle(color: Colors.black)),
    );
  }
}

class ColaboradoresScreen extends StatelessWidget {
  const ColaboradoresScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Pantalla de Colaboradores", style: TextStyle(color: Colors.black)),
    );
  }
}

class AsignacionesScreen extends StatelessWidget {
  const AsignacionesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Pantalla de Asignaciones", style: TextStyle(color: Colors.black)),
    );
  }
}

class ViajesScreen extends StatelessWidget {
  const ViajesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Pantalla de Viajes", style: TextStyle(color: Colors.black)),
    );
  }
}
