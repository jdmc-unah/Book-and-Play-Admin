import 'package:bookandplay_admin/widgets/widgets_inicio/menu_inicio.dart';
import 'package:flutter/material.dart';

class PaginaInicio extends StatelessWidget {
  const PaginaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book & Play"),
        centerTitle: true,
        toolbarHeight: 72,
        //Muestra datos del usuario
        actions: [MenuInicio()],
      ),
      body: Column(children: [Text('Pantalla de Inicio')]),
    );
  }
}
