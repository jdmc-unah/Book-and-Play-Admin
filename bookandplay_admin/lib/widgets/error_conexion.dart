import 'package:flutter/material.dart';

class ErrorConexion extends StatelessWidget {
  const ErrorConexion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/iconos/no-internet1.gif', height: 250),
                SizedBox(height: 20),
                Text('Oops!', style: TextStyle(fontSize: 50)),
                SizedBox(height: 20),

                Text(
                  'No estás conectado a internet',
                  style: TextStyle(fontSize: 25),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
