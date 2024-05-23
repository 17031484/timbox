import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/colaborador.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/config.dart' as routes;

class ListColaborators extends StatefulWidget {
  const ListColaborators({super.key});

  @override
  State<ListColaborators> createState() => _ListColaboratorsState();
}

class _ListColaboratorsState extends State<ListColaborators> {
  final List<Colaborador> _colaboradores = [];
  late StreamSubscription<Colaborador> _subscription;
  final StreamController<Colaborador> _streamController =
      StreamController<Colaborador>();

  @override
  void initState() {
    super.initState();
    _subscription = fetchRecords().listen((colaborador) {
      setState(() {
        _colaboradores.add(colaborador);
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _colaboradores.isEmpty
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _colaboradores.length,
            itemBuilder: (context, index) {
              final colaborador = _colaboradores[index];
              return ListTile(
                title: Text(colaborador.nombre),
                subtitle: Text(colaborador.correo),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Lógica para editar el colaborador

                        print('Editar ${colaborador.nombre}');
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirmar eliminación'),
                              content: Text(
                                  '¿Estás seguro de que deseas eliminar a ${colaborador.nombre}?'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Cancelar'),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Cerrar el diálogo
                                  },
                                ),
                                TextButton(
                                  child: Text('Eliminar'),
                                  onPressed: () async {
                                    // Lógica para eliminar el colaborador
                                    var regBody = {
                                      "id_colaborator":
                                          colaborador.id_colaborator
                                    };
                                    try {
                                      var response = await http.delete(
                                        Uri.parse(routes.deleteColaborator),
                                        headers: {
                                          "Content-Type":
                                              "application/json; charset=utf-8"
                                        },
                                        body: jsonEncode(regBody),
                                      );
                                      if (response.statusCode == 200) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HomePage()),
                                        );
                                      }
                                    } catch (error) {
                                      print(
                                          'Error en la solicitud DELETE: $error');
                                    }

                                    print(
                                        'Eliminar ${colaborador.id_colaborator}');
                                    setState(() {
                                      _colaboradores.removeAt(
                                          index); // Eliminar el colaborador de la lista
                                    });
                                    Navigator.of(context)
                                        .pop(); // Cerrar el diálogo
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
  }

  Stream<Colaborador> fetchRecords() async* {
    final response = await http.get(Uri.parse(routes.getColaborators));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      //print('.............ROWS................');
      //print(data['result']['rows']);
      //print(data['result']['rows'][0]['name']);
      if (data['result']['rowCount'] > 0) {
        // Obtiene la lista de registros del mapa
        final List<dynamic> registrosData = data['result']['rows'];

        for (var registroData in registrosData) {
          yield Colaborador(
            id_colaborator: registroData['id_colaborator'],
            nombre: registroData['name'],
            correo: registroData['correo'],
            rfc: registroData['rfc'],
            domfiscal: registroData['domfiscal'],
            curp: registroData['curp'],
            nss: registroData['nss'],
            fechainicio: registroData['fechainicio'],
            tipocontrato: registroData['tipocontrato'],
            depto: registroData['depto'],
            puesto: registroData['puesto'],
            salariodia: registroData['salariodia'],
            salario: registroData['salario'],
            clventidad: registroData['clventidad'],
            estado: registroData['estado'],
          );
        }

        // Mapea los datos a objetos de tipo COLABORADOR
      } else {
        // Si no se encuentra la lista de registros en el mapa, lanza una excepción
        throw Exception(
            'La respuesta del servidor no contiene la lista de registros');
      }
    } else {
      throw Exception('Error al cargar los datos');
    }
  }
}
