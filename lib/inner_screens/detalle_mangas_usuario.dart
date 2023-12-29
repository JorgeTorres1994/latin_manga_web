/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalleMangasUsuario extends StatelessWidget {
  final String mangaId;

  const DetalleMangasUsuario({Key? key, required this.mangaId})
      : super(key: key);

  void _launchPDFDownload(String pdfUrl) async {
    if (await canLaunch(pdfUrl)) {
      await launch(pdfUrl);
    } else {
      print('No se pudo abrir el enlace del PDF.');
    }
  }

  void _launchOnlineViewer(String onlineUrl) async {
    if (await canLaunch(onlineUrl)) {
      await launch(onlineUrl);
    } else {
      print('No se pudo abrir el enlace en línea.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Manga'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey[100],
        ),
        child: Center(
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('mangas')
                .doc(mangaId)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              var mangaData = snapshot.data?.data() as Map<String, dynamic>;

              return Card(
                elevation: 8,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          '${mangaData['title']}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            mangaData['imageUrl'],
                            fit: BoxFit.cover,
                            width: 250,
                            height: 300,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Categoría: ${mangaData['mangaCategoryName']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tipo: ${mangaData['type']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Número de Páginas: ${mangaData['numberPages']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _launchPDFDownload(mangaData['pdfUrl']);
                              },
                              child: Text('Descargar'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _launchOnlineViewer(mangaData['linkManga']);
                              },
                              child: Text('Ver online'),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        // Sección de comentarios
                        ComentariosSection(mangaId: mangaId),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ComentarioTile extends StatelessWidget {
  final String contenido;
  final String fecha;
  final String usuarioId;

  const ComentarioTile({
    Key? key,
    required this.contenido,
    required this.fecha,
    required this.usuarioId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.person),
      ),
      title: Text(contenido),
      subtitle: Text(fecha),
    );
  }
}

class ComentariosSection extends StatelessWidget {
  final String mangaId;

  const ComentariosSection({Key? key, required this.mangaId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comentarios',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('comments')
              .where('mangaId', isEqualTo: mangaId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            var comentarios = snapshot.data?.docs ?? [];
            return Column(
              children: comentarios
                  .map((comentario) => ComentarioTile(
                        contenido: comentario['contenido'],
                        fecha: comentario['fecha'],
                        usuarioId: comentario['usuarioId'],
                      ))
                  .toList(),
            );
          },
        ),
        SizedBox(height: 8),
        // Formulario de comentarios
        ComentariosForm(mangaId: mangaId),
      ],
    );
  }
}

class ComentariosForm extends StatefulWidget {
  final String mangaId;

  const ComentariosForm({Key? key, required this.mangaId}) : super(key: key);

  @override
  _ComentariosFormState createState() => _ComentariosFormState();
}

class _ComentariosFormState extends State<ComentariosForm> {
  final TextEditingController _comentarioController = TextEditingController();

  Future<void> _mostrarDialog(String mensaje) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(mensaje),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Añadir Comentario',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextField(
          controller: _comentarioController,
          decoration: InputDecoration(
            labelText: 'Comentario',
          ),
        ),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            // Validación para evitar comentarios vacíos
            if (_comentarioController.text.trim().isEmpty) {
              _mostrarDialog('El comentario no puede estar vacío.');
            } else {
              FirebaseFirestore.instance.collection('comments').add({
                'contenido': _comentarioController.text,
                'fecha': DateTime.now().toString(),
                'mangaId': widget.mangaId,
                'usuarioDocRef':
                    'usuarioDocRef', // Reemplaza con el valor correcto
                'usuarioId': 'usuarioId', // Reemplaza con el valor correcto
              });

              _comentarioController.clear();
            }
          },
          child: Text('Enviar Comentario'),
        ),
      ],
    );
  }
}

*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalleMangasUsuario extends StatelessWidget {
  final String mangaId;

  const DetalleMangasUsuario({Key? key, required this.mangaId})
      : super(key: key);

  void _launchPDFDownload(String pdfUrl) async {
    if (await canLaunch(pdfUrl)) {
      await launch(pdfUrl);
    } else {
      print('No se pudo abrir el enlace del PDF.');
    }
  }

  void _launchOnlineViewer(String onlineUrl) async {
    if (await canLaunch(onlineUrl)) {
      await launch(onlineUrl);
    } else {
      print('No se pudo abrir el enlace en línea.');
    }
  }

  Future<void> _mostrarDialog(BuildContext context, String mensaje) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(mensaje),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Manga'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey[100],
        ),
        child: Center(
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('mangas')
                .doc(mangaId)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              var mangaData = snapshot.data?.data() as Map<String, dynamic>;

              return Card(
                elevation: 8,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          '${mangaData['title']}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            mangaData['imageUrl'],
                            fit: BoxFit.cover,
                            width: 250,
                            height: 300,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Categoría: ${mangaData['mangaCategoryName']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tipo: ${mangaData['type']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Número de Páginas: ${mangaData['numberPages']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _launchPDFDownload(mangaData['pdfUrl']);
                              },
                              child: Text('Descargar'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Validar si existe el linkManga antes de abrirlo
                                if (mangaData['linkManga'] != null &&
                                    mangaData['linkManga'].isNotEmpty) {
                                  _launchOnlineViewer(mangaData['linkManga']);
                                } else {
                                  _mostrarDialog(context,
                                      'No existe un manga almacenado en Google Drive.');
                                }
                              },
                              child: Text('Ver online'),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        // Sección de comentarios
                        ComentariosSection(mangaId: mangaId),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ComentarioTile extends StatelessWidget {
  final String contenido;
  final String fecha;
  final String usuarioId;

  const ComentarioTile({
    Key? key,
    required this.contenido,
    required this.fecha,
    required this.usuarioId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.person),
      ),
      title: Text(contenido),
      subtitle: Text(fecha),
    );
  }
}

class ComentariosSection extends StatelessWidget {
  final String mangaId;

  const ComentariosSection({Key? key, required this.mangaId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comentarios',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('comments')
              .where('mangaId', isEqualTo: mangaId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            var comentarios = snapshot.data?.docs ?? [];
            return Column(
              children: comentarios
                  .map((comentario) => ComentarioTile(
                        contenido: comentario['contenido'],
                        fecha: comentario['fecha'],
                        usuarioId: comentario['usuarioId'],
                      ))
                  .toList(),
            );
          },
        ),
        SizedBox(height: 8),
        // Formulario de comentarios
        ComentariosForm(mangaId: mangaId),
      ],
    );
  }
}

class ComentariosForm extends StatefulWidget {
  final String mangaId;

  const ComentariosForm({Key? key, required this.mangaId}) : super(key: key);

  @override
  _ComentariosFormState createState() => _ComentariosFormState();
}

class _ComentariosFormState extends State<ComentariosForm> {
  final TextEditingController _comentarioController = TextEditingController();

  Future<void> _mostrarDialog(String mensaje) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(mensaje),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Añadir Comentario',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextField(
          controller: _comentarioController,
          decoration: InputDecoration(
            labelText: 'Comentario',
          ),
        ),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            // Validación para evitar comentarios vacíos
            if (_comentarioController.text.trim().isEmpty) {
              _mostrarDialog('El comentario no puede estar vacío.');
            } else {
              FirebaseFirestore.instance.collection('comments').add({
                'contenido': _comentarioController.text,
                'fecha': DateTime.now().toString(),
                'mangaId': widget.mangaId,
                'usuarioDocRef':
                    'usuarioDocRef', // Reemplaza con el valor correcto
                'usuarioId': 'usuarioId', // Reemplaza con el valor correcto
              });

              _comentarioController.clear();
            }
          },
          child: Text('Enviar Comentario'),
        ),
      ],
    );
  }
}
