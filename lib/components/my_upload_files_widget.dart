import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/registro.dart';
import 'package:flutter_application_1/config.dart' as routes;
import 'package:http/http.dart' as http;

class FileUploadPage extends StatefulWidget {
  @override
  State<FileUploadPage> createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
// Variable para controlar si se ha cargado el archivo
  bool _archivoCargado = false;

  // Método para cargar el archivo al servidor
  Future<void> _cargarArchivo(Map<String, String> regBody) async {
    // URL del punto final en el servidor donde se cargará el archivo
    var url = Uri.parse(routes.upload);

    /// Crea una solicitud HTTP POST con los metadatos del archivo
    var response = await http.post(url,
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: jsonEncode(regBody));

    // Maneja la respuesta
    if (response.statusCode == 200) {
      print('Informacion del archivo cargado exitosamente');
      // Establece el estado de "_archivoCargado" como verdadero
      setState(() {
        _archivoCargado = true;
      });
    } else {
      print('Error al cargar informacion el archivo: ${response.reasonPhrase}');
    }
  }

  // Método para seleccionar un archivo
  Future<void> _seleccionarArchivo(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'xlsx'],
    );

    if (result != null && result.files.isNotEmpty) {
      var nombreArchivo = result.files.single.name;
      String extensionArchivo = '';

      // Busca la posición del último punto en el nombre del archivo
      int indicePunto = nombreArchivo.lastIndexOf('.');

      if (indicePunto != -1 && indicePunto < nombreArchivo.length - 1) {
        // Obtiene la extensión del archivo
        extensionArchivo = nombreArchivo.substring(indicePunto + 1);
      } else {
        // No se encontró un punto o no hay caracteres siguientes al punto
        print(
            'No se encontró un punto o no hay caracteres siguientes al punto.');
        extensionArchivo = '?';
      }

      // Obtiene la fecha actual
      DateTime fechaSubida = DateTime.now();
      // Formatea la fecha en un formato legible
      String fechaFormateada = fechaSubida.toIso8601String();

      var regBody = {
        'nombre': nombreArchivo,
        'extension': extensionArchivo,
        'fecha': fechaFormateada,
      };
      // Carga la informacion del archivo seleccionado al servidor
      await _cargarArchivo(regBody);
    } else {
      print(
          'El usuario canceló la selección de archivo o no seleccionó ningún archivo');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cargar Archivo'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () => _seleccionarArchivo(context),
                child: Text('Seleccionar Archivo'),
              ),
              SizedBox(
                  height: 20), 
              Expanded(
                child: FutureBuilder<List<Registro>>(
                  future:
                      obtenerRegistros(), // Función para obtener los registros de la base de datos
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtienen los registros
                    } else if (snapshot.hasError) {
                      return Text(
                          'Error al cargar los registros: ${snapshot.error}');
                    } else {
                      List<Registro> registros = snapshot.data ??
                          []; // Obtiene los registros del snapshot
                      return ListView.builder(
                        itemCount: registros.length,
                        itemBuilder: (context, index) {
                          Registro registro = registros[index];
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 5.0),
                            padding: EdgeInsets.symmetric(horizontal: 600),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0,
                                      3), 
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(registro.nombre),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(registro.extension),
                                  SizedBox(height: 5.0),
                                  Text(registro.fecha)
                                ],
                              ),
                             
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Registro>> obtenerRegistros() async {
    // URL del endpoint en el backend para obtener los registros
    final url = Uri.parse(routes.getFiles);

    try {
      // Realiza una solicitud GET al servidor backend
      final response = await http.get(url);

      // Verifica si la respuesta fue exitosa (código de estado 200)
      if (response.statusCode == 200) {
        // Decodifica los datos JSON de la respuesta
        final Map<String, dynamic> data = jsonDecode(response.body);

        print(data['result']['rows']);

        // Mapea los datos a objetos de tipo Registro
        // Verifica si el mapa contiene una clave que representa la lista de registros
        if (data['result']['rowCount'] > 0) {
          // Obtiene la lista de registros del mapa
          final List<dynamic> registrosData = data['result']['rows'];

          // Mapea los datos a objetos de tipo Registro
          return registrosData.map((registroData) {
            return Registro(
              nombre: registroData['nombre'],
              extension: registroData['extension'],
              fecha: registroData['fecha'],
            );
          }).toList();
        } else {
          // Si no se encuentra la lista de registros en el mapa, lanza una excepción
          throw Exception(
              'La respuesta del servidor no contiene la lista de registros');
        }
      } else {
        // Si la solicitud no fue exitosa, lanza una excepción
        throw Exception(
            'Error al obtener los registros: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Si ocurre un error durante la solicitud, lanza una excepción
      throw Exception('Error al conectarse al servidor: $e');
    }
  }
}
