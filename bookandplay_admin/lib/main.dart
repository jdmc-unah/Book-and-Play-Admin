import 'dart:async';

import 'package:bookandplay_admin/controladores/filtro_controlador.dart';
import 'package:bookandplay_admin/vistas/informacion_usuario.dart';
import 'package:bookandplay_admin/widgets/error_conexion.dart';
import 'package:bookandplay_admin/estilos/colores.dart';
import 'package:bookandplay_admin/firebase_options.dart';
import 'package:bookandplay_admin/vistas/crud_cancha.dart';
import 'package:bookandplay_admin/vistas/pagina_inicio.dart';
import 'package:bookandplay_admin/vistas/login.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(ControladorFiltros(), permanent: true);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool conectado = false;
  StreamSubscription? _internetStreamSub;

  @override
  void initState() {
    super.initState();
    //* Valida conexion a internet
    _internetStreamSub = InternetConnection().onStatusChange.listen((event) {
      if (event == InternetStatus.connected) {
        setState(() {
          conectado = true;
          GetStorage().write('conectado', true);
        });
      } else {
        setState(() {
          conectado = false;
          GetStorage().write('conectado', false);
        });
      }
    });
  }

  @override
  void dispose() {
    _internetStreamSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colores.fondoPrimario,
          selectionColor: Colores.fondoPrimario,
          selectionHandleColor: Colores.fondoPrimario,
        ),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: GoRouter(
        navigatorKey: Get.key,
        redirect: (context, state) {
          //* Valida Conexion a internet
          final conectado = GetStorage().read('conectado');
          if (conectado == false) {
            return '/errorconexion';
          }

          //* Valida Sesion Iniciada
          final sesionIniciada = GetStorage().read('sesionIniciada') ?? false;
          final rutaActual = state.fullPath;

          if (!sesionIniciada && rutaActual == '/inicio') {
            return '/login';
          }

          return null;
        },
        initialLocation: '/inicio',
        routes: [
          GoRoute(
            name: 'login',
            path: '/login',
            builder: (context, state) => Login(),
          ),

          GoRoute(
            name: 'inicio',
            path: '/inicio',
            builder: (context, state) {
              return PaginaInicio(); //TODO >> pagina de inicio
            },
            routes: [
              GoRoute(
                path: '/informacion',
                name: 'informacion',
                builder: (context, state) => InfoUsuario(),
              ),
            ],
          ),

          GoRoute(
            name: 'cancha',
            path: '/cancha',
            builder: (context, state) => CRUDCancha(), //TODO>>> para el CRUD
          ),

          GoRoute(
            path: '/errorconexion',
            name: 'errorconexion',
            builder: (context, state) => ErrorConexion(),
          ),
        ],
      ),
    );
  }
}
