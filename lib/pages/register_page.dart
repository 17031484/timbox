import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/my_textfield%20copy.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/config.dart' as routes;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final rfcController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  bool _validate = false;

  String msg = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 76, 187, 150),
        body: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50.0),
                      child: Text(
                        'FORMULARIO DE REGISTRO',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                        controller: nameController,
                        hintText: 'Nombre',
                        obscureText: false,
                        validate: _validate),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                        controller: emailController,
                        hintText: 'Correo',
                        obscureText: false,
                        validate: _validate),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                        controller: rfcController,
                        hintText: 'RFC',
                        obscureText: false,
                        validate: _validate),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                        controller: passwordController,
                        hintText: 'Contraseña',
                        obscureText: true,
                        validate: _validate),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                        controller: confirmController,
                        hintText: 'Confirmar contraseña',
                        obscureText: true,
                        validate: _validate),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () => {guardarDatos()},
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.symmetric(horizontal: 50),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: Text(
                            'Registrar',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Text(
                        msg,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.red),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
    ;
  }

  Future<void> guardarDatos() async {
    List<TextEditingController> controllers = [
      nameController,
      emailController,
      rfcController,
      passwordController,
      confirmController
    ];

    bool allFieldsFilled =
        controllers.every((controller) => controller.text.isNotEmpty);
    if (allFieldsFilled) {
      if (passwordController.text == confirmController.text) {
        final RegExp rfcRegExp = RegExp(r'^[A-ZÑ&]{3,4}\d{6}(?:[A-Z\d]{3})?$');
        if (rfcRegExp.hasMatch(rfcController.text)) {
          print('Procediendo');
          var regBody = {
            "username": nameController.text,
            "email": emailController.text,
            "pass": passwordController.text,
            "rfc": rfcController.text,
          };
          try {
            var response = await http.post(
              Uri.parse(routes.addUser),
              headers: {"Content-Type": "application/json; charset=utf-8"},
              body: jsonEncode(regBody),
            );

            if (response.statusCode == 201) {
              print(response.body);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }
          } catch (e) {
            print('Error en la solicitud POST: $e');
            // Manejar el error, como mostrar un mensaje de error al usuario
          }
        } else {
          setState(() {
            msg = 'Por favor ingrese un RFC válido';
          });
        }
      } else {
        setState(() {
          msg = 'Las contraseñas no coinciden';
        });
      }
    } else {
      //hacer un text con un set satate para mostrar el error
      print('No se llenaron todos los campos correspondientes');
      setState(() {
        msg = 'No se llenaron todos los campos correspondientes';
      });
    }
  }
}
