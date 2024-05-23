import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/my_textfield copy.dart';
import 'package:flutter_application_1/config.dart' as routes;
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:http/http.dart' as http;

const List<String> estadosDeMexico = <String>[
  'Aguascalientes',
  'Baja California',
  'Baja California Sur',
  'Campeche',
  'Chiapas',
  'Chihuahua',
  'Ciudad de México',
  'Coahuila',
  'Colima',
  'Durango',
  'Estado de México',
  'Guanajuato',
  'Guerrero',
  'Hidalgo',
  'Jalisco',
  'Michoacán',
  'Morelos',
  'Nayarit',
  'Nuevo León',
  'Oaxaca',
  'Puebla',
  'Querétaro',
  'Quintana Roo',
  'San Luis Potosí',
  'Sinaloa',
  'Sonora',
  'Tabasco',
  'Tamaulipas',
  'Tlaxcala',
  'Veracruz',
  'Yucatán',
  'Zacatecas',
];

class AddColaborator extends StatefulWidget {
  const AddColaborator({super.key});

  @override
  State<AddColaborator> createState() => _AddColaboratorState();
}

class _AddColaboratorState extends State<AddColaborator> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final rfcController = TextEditingController();
  final domfisController = TextEditingController();
  final curpController = TextEditingController();
  final nssController = TextEditingController();
  final fechainiciolaboralController = TextEditingController();
  final tipocontratoController = TextEditingController();
  final deptoController = TextEditingController();
  final puestoController = TextEditingController();
  final salariodiarioController = TextEditingController();
  final salarioController = TextEditingController();
  final clventidadController = TextEditingController();

  bool _validate = false;
  String dropdownValue = estadosDeMexico.first;
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
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50.0),
                      child: Text('FORMULARIO'),
                    ),
                    const SizedBox(
                      height: 60,
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
                        controller: domfisController,
                        hintText: 'Domicilio fiscal',
                        obscureText: false,
                        validate: _validate),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                        controller: curpController,
                        hintText: 'CURP',
                        obscureText: false,
                        validate: _validate),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                        controller: nssController,
                        hintText: 'NSS',
                        obscureText: false,
                        validate: _validate),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                        controller: fechainiciolaboralController,
                        hintText: 'Fecha de inicio laboral',
                        obscureText: false,
                        validate: _validate)
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    MyTextField(
                        controller: tipocontratoController,
                        hintText: 'Tipo de contrato',
                        obscureText: false,
                        validate: _validate),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                        controller: deptoController,
                        hintText: 'Departamento',
                        obscureText: false,
                        validate: _validate),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                        controller: puestoController,
                        hintText: 'Puesto',
                        obscureText: false,
                        validate: _validate),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                        controller: salariodiarioController,
                        hintText: 'Salario diario',
                        obscureText: false,
                        validate: _validate),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                        controller: salarioController,
                        hintText: 'Salario',
                        obscureText: false,
                        validate: _validate),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                        controller: clventidadController,
                        hintText: 'Clave entidad',
                        obscureText: false,
                        validate: _validate),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            dropdownValue = value!;
                          });
                          //print(dropdownValue);
                        },
                        items: estadosDeMexico
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
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
                            'Guardar',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> guardarDatos() async {
    List<TextEditingController> controllers = [
      nameController,
      emailController,
      rfcController,
      domfisController,
      curpController,
      nssController,
      fechainiciolaboralController,
      tipocontratoController,
      deptoController,
      puestoController,
      salariodiarioController,
      salarioController,
      clventidadController,
    ];

    bool allFieldsFilled =
        controllers.every((controller) => controller.text.isNotEmpty);
    if (allFieldsFilled) {
      print('Preocediendo');
      var regBody = {
        "nombre": nameController.text,
        "correo": emailController.text,
        "rfc": rfcController.text,
        "domfiscal": domfisController.text,
        "curp": curpController.text,
        "nss": nssController.text,
        "fechainicio": fechainiciolaboralController.text,
        "tipocontrato": tipocontratoController.text,
        "depto": deptoController.text,
        "puesto": puestoController.text,
        "salariodiario": salarioController.text,
        "salario": salarioController.text,
        "clventidad": clventidadController.text,
        "estado": dropdownValue,
      };
      try {
        var response = await http.post(
          Uri.parse(routes.addColaborator),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: jsonEncode(regBody),
        );
        //print(response.statusCode);
        //print(response.body);

        if (response.statusCode == 200) {
          //Permite acceder, usuario y contraseña correctas
          print(response.body);
        }
       
      } catch (e) {
        print('Error en la solicitud POST: $e');
        // Manejar el error, como mostrar un mensaje de error al usuario
      }
    } else {
      //hacer un text con un set satate para mostrar el error
      print('No se llenaron todos los campos correspondientes');
    }
  }
}
