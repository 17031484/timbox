import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/my_button.dart';
import 'package:flutter_application_1/components/my_textfield.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/pages/register_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/config.dart' as routes;
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //controladores del texto
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool _validate = false;

  //login function
  Future<void> login() async {
    /*PRIMERO DEBEMOS REVISAR VARIAS COSAS ANTES DE HACER EL LOGIN:
        1. Que los campos no estén vacios
        2. Que la contraseña sea correcta
    */

    if (emailController.text.isNotEmpty && passController.text.isNotEmpty) {
      var regBody = {
        "email": emailController.text,
        "pass": passController.text,
      };

      try {
        var response = await http.post(
          Uri.parse(routes.login),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: jsonEncode(regBody),
        );
        print(response.statusCode);
        print(response.body);

        if (response.statusCode == 200) {
          //Permite acceder, usuario y contraseña correctas
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
        if (response.statusCode == 401) {
          //NO Permite acceder, contraseña incorrecta
        }
        if (response.statusCode == 404) {
          //USUARIO NO ENCONTRADO
        }
      } catch (e) {
        print('Error en la solicitud POST: $e');
        // Manejar el error, como mostrar un mensaje de error al usuario
      }
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 76, 187, 150),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 25,
                ),
                //ICONO
                const Icon(
                  Icons.lock_person,
                  size: 100,
                ),
                const SizedBox(
                  height: 25,
                ),

                //MENSAJES DE BIENVENIDA
                const Text(
                  '¡Bienvenido, es un gusto tenerte de regreso!',
                  style: TextStyle(
                      color: Color.fromARGB(255, 43, 42, 42), fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                //USERNAME BOX
                MyTextField(
                  controller: emailController,
                  hintText: 'Correo',
                  obscureText: false,
                  validate: _validate,
                ),

                const SizedBox(
                  height: 20,
                ),
                //PASSWORD
                MyTextField(
                  controller: passController,
                  hintText: 'Contraseña',
                  obscureText: true,
                  validate: _validate,
                ),

                //REGISTRO
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 450),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(
                            color: Color.fromARGB(255, 43, 42, 42),
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                MyButton(
                  onTap: login,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 450),
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿No estás registrado?'),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterPage()),
                        )
                      },
                      child: const Text(
                        'Registrate aquí',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
