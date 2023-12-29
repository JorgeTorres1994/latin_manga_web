/*
                                          /*MODO ESPECTADOR*/

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:universal_html/html.dart' as html;

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

  void _downloadPdf() async {
    if (pdfUrl != null) {
      try {
        final anchor = html.AnchorElement(href: pdfUrl!)
          ..target = '_blank'
          ..download = 'manga.pdf'
          ..click();
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Error al descargar el manga: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "El manga no tiene un archivo PDF para descargar",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
      );
    }
  }

  void _openPdfViewerOnline() {
    // Implementa la lógica de visualización en línea aquí
    print('Abriendo visor de PDF en línea...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de Manga'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 300, // Ajusta la altura según tus necesidades
                width: double.infinity,
                child: Image.network(
                  imageUrl ??
                      'https://thumbs.dreamstime.com/b/fondo-del-vector-de-la-tela-blanca-con-las-ondas-blanco-abstracto-pa%C3%B1o-lujo-onda-l%C3%ADquida-o-los-dobleces-ondulados-textura-seda-141911376.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              if (mangaCat != null)
                Text('Género: $mangaCat', style: TextStyle(fontSize: 18)),
              if (typeLibro != null)
                Text('Tipo: $typeLibro', style: TextStyle(fontSize: 18)),
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
              if (pdfUrl != null && pdfUrl!.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _openPdfViewerOnline,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Ver Online',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _downloadPdf,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Descargar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}*/

/*MODO ADMIN*/

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:universal_html/html.dart' as html;

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

  void _downloadPdf() async {
    if (pdfUrl != null) {
      try {
        final anchor = html.AnchorElement(href: pdfUrl!)
          ..target = '_blank'
          ..download = 'manga.pdf'
          ..click();
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Error al descargar el manga: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "El manga no tiene un archivo PDF para descargar",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
      );
    }
  }

  void _openPdfViewerOnline() {
    // Implementa la lógica de visualización en línea aquí
    print('Abriendo visor de PDF en línea...');
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  imageUrl ??
                      'https://thumbs.dreamstime.com/b/fondo-del-vector-de-la-tela-blanca-con-las-ondas-blanco-abstracto-pa%C3%B1o-lujo-onda-l%C3%ADquida-o-los-dobleces-ondulados-textura-seda-141911376.jpg',
                  fit: BoxFit.cover,
                  height: 300, // Ajusta la altura según tus necesidades
                ),
                SizedBox(height: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                if (mangaCat != null)
                  Text('Género: $mangaCat', style: TextStyle(fontSize: 18)),
                if (typeLibro != null)
                  Text('Tipo: $typeLibro', style: TextStyle(fontSize: 18)),
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
              ],
            ),
          ),
        ));
  }
}
