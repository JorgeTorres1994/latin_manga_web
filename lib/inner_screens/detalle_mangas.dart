/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalleMangasWidget extends StatelessWidget {
  final String id;
  final String title;
  final String? mangaCat;
  final String? typeLibro;
  final String? imageUrl;
  final String? numberPages;
  final String? pdfUrl;
  final double userRating;
  final double averageRating;

  DetalleMangasWidget({
    required this.id,
    required this.title,
    this.mangaCat,
    this.typeLibro,
    this.imageUrl,
    this.numberPages,
    this.pdfUrl,
    required this.userRating,
    required this.averageRating,
  });

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
        title: Text('Detalles de Manga'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<DocumentSnapshot>(
            // Asegúrate de importar 'package:cloud_firestore/cloud_firestore.dart';
            future:
                FirebaseFirestore.instance.collection('mangas').doc(id).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              var mangaData = snapshot.data?.data() as Map<String, dynamic>;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                    mangaData['imageUrl'] ??
                        'https://thumbs.dreamstime.com/b/fondo-del-vector-de-la-tela-blanca-con-las-ondas-blanco-abstracto-pa%C3%B1o-lujo-onda-l%C3%ADquida-o-los-dobleces-ondulados-textura-seda-141911376.jpg',
                    fit: BoxFit.cover,
                    height: 300,
                  ),
                  SizedBox(height: 16),
                  Text(
                    mangaData['title'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  if (mangaCat != null)
                    Text('Género: ${mangaData['mangaCategoryName']}',
                        style: TextStyle(fontSize: 18)),
                  if (typeLibro != null)
                    Text('Tipo: ${mangaData['type']}',
                        style: TextStyle(fontSize: 18)),
                  if (typeLibro != null)
                    Text('# Páginas: ${mangaData['numberPages']}',
                        style: TextStyle(fontSize: 18)),
                  SizedBox(height: 16),
                  RatingBar.builder(
                    initialRating: userRating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 30,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (newRating) {
                      // Puedes agregar lógica para actualizar la calificación si es necesario
                      print('Nueva calificación: $newRating');
                    },
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Puntuación Promedio: ${averageRating.toStringAsFixed(1)}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _launchPDFDownload(mangaData['pdfUrl'] ?? '');
                        },
                        child: Text('Descargar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Validar si existe el linkManga antes de abrirlo
                          final linkManga = mangaData['linkManga'] as String?;
                          if (linkManga != null && linkManga.isNotEmpty) {
                            _launchOnlineViewer(linkManga);
                          } else {
                            _mostrarDialog(
                              context,
                              'No existe un manga almacenado en Google Drive.',
                            );
                          }
                        },
                        child: Row(
                          children: [
                            Icon(Icons.open_in_browser),
                            SizedBox(width: 8),
                            Text('Ver online'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalleMangasWidget extends StatelessWidget {
  final String id;
  final String title;
  final String? mangaCat;
  final String? typeLibro;
  final String? imageUrl;
  final String? numberPages;
  final String? pdfUrl;
  final double userRating;
  final double averageRating;

  DetalleMangasWidget({
    required this.id,
    required this.title,
    this.mangaCat,
    this.typeLibro,
    this.imageUrl,
    this.numberPages,
    this.pdfUrl,
    required this.userRating,
    required this.averageRating,
  });

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
        title: Text('Detalles de Manga'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<DocumentSnapshot>(
            // Asegúrate de importar 'package:cloud_firestore/cloud_firestore.dart';
            future:
                FirebaseFirestore.instance.collection('mangas').doc(id).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              var mangaData = snapshot.data?.data() as Map<String, dynamic>;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                    mangaData['imageUrl'] ??
                        'https://thumbs.dreamstime.com/b/fondo-del-vector-de-la-tela-blanca-con-las-ondas-blanco-abstracto-pa%C3%B1o-lujo-onda-l%C3%ADquida-o-los-dobleces-ondulados-textura-seda-141911376.jpg',
                    fit: BoxFit.cover,
                    height: 300,
                  ),
                  SizedBox(height: 16),
                  Text(
                    mangaData['title'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  if (mangaCat != null)
                    Text('Género: ${mangaData['mangaCategoryName']}',
                        style: TextStyle(fontSize: 18)),
                  if (typeLibro != null)
                    Text('Tipo: ${mangaData['type']}',
                        style: TextStyle(fontSize: 18)),
                  if (typeLibro != null)
                    Text('# Páginas: ${mangaData['numberPages']}',
                        style: TextStyle(fontSize: 18)),
                  SizedBox(height: 16),
                  RatingBar.builder(
                    initialRating: userRating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 30,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (newRating) {
                      // Puedes agregar lógica para actualizar la calificación si es necesario
                      print('Nueva calificación: $newRating');
                    },
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Puntuación Promedio: ${averageRating.toStringAsFixed(1)}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _launchPDFDownload(mangaData['pdfUrl'] ?? '');
                        },
                        child: Text('Descargar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Validar si existe el linkManga antes de abrirlo
                          final linkManga = mangaData['linkManga'] as String?;
                          if (linkManga != null && linkManga.isNotEmpty) {
                            _launchOnlineViewer(linkManga);
                          } else {
                            _mostrarDialog(
                              context,
                              'No existe un manga almacenado en Google Drive.',
                            );
                          }
                        },
                        child: Row(
                          children: [
                            Icon(Icons.open_in_browser),
                            SizedBox(width: 8),
                            Text('Ver online'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
