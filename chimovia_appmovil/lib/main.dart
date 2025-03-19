import 'package:chimovia_appmovil/config/goroute.dart';
import 'package:chimovia_appmovil/modules/colaboradores/bloc/colaboradores_bloc_bloc.dart';
import 'package:chimovia_appmovil/modules/colaboradores/infraestructure/datasource/colaboradores_datasoruce_implementacion.dart';
import 'package:chimovia_appmovil/modules/colaboradores/presentation/colaboradores_screen.dart';
import 'package:chimovia_appmovil/screen/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp.router(
      routerConfig: appRoutes,
      debugShowCheckedModeBanner: false,

      // BlocProvider(
      //   create: (context) => ColaboradorBloc(
      //     repository: ColaboradorDataSource(),
      //   )..add(LoadColaboradores()),
      //   child: ColaboradorListScreen(),
      // )
    );
  }
}
