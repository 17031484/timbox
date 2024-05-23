import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/my_colaborator.dart';
import 'package:flutter_application_1/components/my_colaboratorlist.dart';
import 'package:flutter_application_1/components/my_upload_files_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variable para almacenar la opción seleccionada del menú
  String _opcionSeleccionada = 'Inicio';

  // Método para cambiar la opción seleccionada del menú
  void _cambiarOpcion(String opcion) {
    setState(() {
      _opcionSeleccionada = opcion;
    });
    Navigator.pop(context); // Cierra el menú lateral después de seleccionar una opción
  }

  // Método para construir la vista correspondiente a la opción seleccionada
  Widget _construirVista() {
    switch (_opcionSeleccionada) {
      case 'CARGA DE ARCHIVOS':
        return FileUploadPage();
      case 'COLABORADOR':
        return AddColaborator();
      case 'EMPLEADOS':
        return ListColaborators();
      case 'SERVICIOS':
        return Text('Contenido para Servicios');
      default:
        return Text('Contenido por defecto');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 76, 187, 150),
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.attach_file),
              title: Text('CARGA DE ARCHIVOS'),
              onTap: () => _cambiarOpcion('CARGA DE ARCHIVOS'),
            ),
            ListTile(
              leading: Icon(Icons.group_add),
              title: Text('COLABORADOR'),
              onTap: () => _cambiarOpcion('COLABORADOR'),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('EMPLEADOS'),
              onTap: () => _cambiarOpcion('EMPLEADOS'),
            ),
            ListTile(
              leading: Icon(Icons.rocket_launch),
              title: Text('SERVICIOS'),
              onTap: () => _cambiarOpcion('SERVICIOS'),
            )
          ],
        ),
      ),
      body: Center(
        child: _construirVista(), // Muestra la vista correspondiente a la opción seleccionada
      ),
    );
  }
}
