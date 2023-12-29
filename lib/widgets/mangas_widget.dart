/*
import 'package:aplicacion_manga_admin_panel/inner_screens/detalle_mangas.dart';
import 'package:aplicacion_manga_admin_panel/inner_screens/editar_mangas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MangasWidget extends StatefulWidget {
  const MangasWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  _MangasWidgetState createState() => _MangasWidgetState();
}

class _MangasWidgetState extends State<MangasWidget> {
  double userRating = 0;
  double averageRating = 0.0;
  String? imageUrl;
  String title = '';
  String mangaCat = '';
  String typeLibro = '';
  String? numberPages;
  String? pdfUrl;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  void onRatingChanged(double newRating) {
    setState(() {
      userRating = newRating;
    });

    // Actualiza la puntuación en Firebase
    updateRatingInFirebase(newRating);
  }

  void updateRatingInFirebase(double newRating) {
    // Actualiza el campo "rating" en la colección "mangas" en Firebase
    FirebaseFirestore.instance.collection('mangas').doc(widget.id).update({
      'rating': newRating,
    }).then((value) {
      print('Puntuación actualizada en Firebase');
    }).catchError((error) {
      print('Error al actualizar la puntuación en Firebase: $error');
    });
  }

  Future<void> eliminarManga() async {
    String mangaId = widget.id; // Almacena el ID localmente
    try {
      await FirebaseFirestore.instance
          .collection('mangas')
          .doc(mangaId)
          .delete();
      print('Manga eliminado exitosamente');
    } catch (error) {
      print('Error al eliminar el manga: $error');
      // Puedes manejar el error de manera adecuada aquí
    }
  }

  void getUserData() async {
    setState(() {});

    String mangaId = widget.id;

    try {
      final DocumentSnapshot mangaDoc = await FirebaseFirestore.instance
          .collection('mangas')
          .doc(mangaId)
          .get();

      if (mangaDoc.exists) {
        setState(() {
          imageUrl = mangaDoc.get('imageUrl') ?? 'N/A';
          title = mangaDoc.get('title') ?? 'N/A';
          mangaCat = mangaDoc.get('mangaCategoryName') ?? 'N/A';
          typeLibro = mangaDoc.get('type') ?? 'N/A';
          numberPages = mangaDoc.get('numberPages') ?? 'N/A';
          pdfUrl = mangaDoc.get('pdfUrl') ?? 'N/A';
        });

        updateAverageRating();
      } else {
        print('El documento no existe');
      }
    } catch (error) {
      setState(() {});
      print('Error: $error');
    } finally {
      setState(() {});
    }
  }

  void updateAverageRating() {
    // Obtener la puntuación promedio de todos los usuarios
    FirebaseFirestore.instance
        .collection('mangas')
        .doc(widget.id)
        .collection('ratings')
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.docs.isNotEmpty) {
        // Calcular la puntuación promedio
        double totalRating = 0;
        snapshot.docs.forEach((doc) {
          totalRating += doc.get('rating');
        });
        double average = totalRating / snapshot.docs.length;

        // Actualizar la variable averageRating
        setState(() {
          averageRating = average;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Theme.of(context).cardColor.withOpacity(0.6),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetalleMangasWidget(
                  id: widget.id,
                  title: title,
                  mangaCat: mangaCat,
                  typeLibro: typeLibro,
                  imageUrl: imageUrl,
                  numberPages: numberPages,
                  pdfUrl: pdfUrl,
                  userRating: userRating,
                  averageRating: averageRating,
                ),
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Image.network(
                      imageUrl ??
                          'https://thumbs.dreamstime.com/b/fondo-del-vector-de-la-tela-blanca-con-las-ondas-blanco-abstracto-pa%C3%B1o-lujo-onda-l%C3%ADquida-o-los-dobleces-ondulados-textura-seda-141911376.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditarMangaScreen(
                          id: widget.id,
                          title: title,
                          productCat: mangaCat,
                          type: typeLibro,
                          imageUrl: imageUrl == null
                              ? 'https://thumbs.dreamstime.com/b/fondo-del-vector-de-la-tela-blanca-con-las-ondas-blanco-abstracto-pa%C3%B1o-lujo-onda-l%C3%ADquida-o-los-dobleces-ondulados-textura-seda-141911376.jpg'
                              : imageUrl!,
                          numberPages: numberPages.toString(),
                          pdfUrl: pdfUrl.toString(),
                        ),
                      ));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      bool confirmar = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Eliminar Manga"),
                            content: Text(
                                "¿Estás seguro de que quieres eliminar este manga?"),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text("Cancelar"),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: Text("Eliminar"),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmar != null && confirmar) {
                        // Lógica para eliminar el manga
                        await eliminarManga();

                        // Esperar un breve momento antes de volver para asegurar que la eliminación se haya completado
                        await Future.delayed(Duration(milliseconds: 500));

                        // Regresar a la pantalla anterior
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

*/

import 'package:aplicacion_manga_admin_panel/inner_screens/detalle_mangas.dart';
import 'package:aplicacion_manga_admin_panel/inner_screens/editar_mangas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MangasWidget extends StatefulWidget {
  const MangasWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  _MangasWidgetState createState() => _MangasWidgetState();
}

class _MangasWidgetState extends State<MangasWidget> {
  double userRating = 0;
  double averageRating = 0.0;
  String? imageUrl;
  String title = '';
  String mangaCat = '';
  String typeLibro = '';
  String? numberPages;
  String? pdfUrl;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  void onRatingChanged(double newRating) {
    setState(() {
      userRating = newRating;
    });

    // Actualiza la puntuación en Firebase
    updateRatingInFirebase(newRating);
  }

  void updateRatingInFirebase(double newRating) {
    // Actualiza el campo "rating" en la colección "mangas" en Firebase
    FirebaseFirestore.instance.collection('mangas').doc(widget.id).update({
      'rating': newRating,
    }).then((value) {
      print('Puntuación actualizada en Firebase');
    }).catchError((error) {
      print('Error al actualizar la puntuación en Firebase: $error');
    });
  }

  Future<void> eliminarManga() async {
    String mangaId = widget.id; // Almacena el ID localmente
    try {
      await FirebaseFirestore.instance
          .collection('mangas')
          .doc(mangaId)
          .delete();
      print('Manga eliminado exitosamente');
    } catch (error) {
      print('Error al eliminar el manga: $error');
      // Puedes manejar el error de manera adecuada aquí
    }
  }

  void getUserData() async {
    setState(() {});

    String mangaId = widget.id;

    try {
      final DocumentSnapshot mangaDoc = await FirebaseFirestore.instance
          .collection('mangas')
          .doc(mangaId)
          .get();

      if (mangaDoc.exists) {
        setState(() {
          imageUrl = mangaDoc.get('imageUrl') ?? 'N/A';
          title = mangaDoc.get('title') ?? 'N/A';
          mangaCat = mangaDoc.get('mangaCategoryName') ?? 'N/A';
          typeLibro = mangaDoc.get('type') ?? 'N/A';
          numberPages = mangaDoc.get('numberPages') ?? 'N/A';
          pdfUrl = mangaDoc.get('pdfUrl') ?? 'N/A';
        });

        updateAverageRating();
      } else {
        print('El documento no existe');
      }
    } catch (error) {
      setState(() {});
      print('Error: $error');
    } finally {
      setState(() {});
    }
  }

  void updateAverageRating() {
    // Obtener la puntuación promedio de todos los usuarios
    FirebaseFirestore.instance
        .collection('mangas')
        .doc(widget.id)
        .collection('ratings')
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.docs.isNotEmpty) {
        // Calcular la puntuación promedio
        double totalRating = 0;
        snapshot.docs.forEach((doc) {
          totalRating += doc.get('rating');
        });
        double average = totalRating / snapshot.docs.length;

        // Actualizar la variable averageRating
        setState(() {
          averageRating = average;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Theme.of(context).cardColor.withOpacity(0.6),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetalleMangasWidget(
                  id: widget.id,
                  title: title,
                  mangaCat: mangaCat,
                  typeLibro: typeLibro,
                  imageUrl: imageUrl,
                  numberPages: numberPages,
                  pdfUrl: pdfUrl,
                  userRating: userRating,
                  averageRating: averageRating,
                ),
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Image.network(
                      imageUrl ??
                          'https://thumbs.dreamstime.com/b/fondo-del-vector-de-la-tela-blanca-con-las-ondas-blanco-abstracto-pa%C3%B1o-lujo-onda-l%C3%ADquida-o-los-dobleces-ondulados-textura-seda-141911376.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditarMangaScreen(
                          id: widget.id,
                          title: title,
                          productCat: mangaCat,
                          type: typeLibro,
                          imageUrl: imageUrl == null
                              ? 'https://thumbs.dreamstime.com/b/fondo-del-vector-de-la-tela-blanca-con-las-ondas-blanco-abstracto-pa%C3%B1o-lujo-onda-l%C3%ADquida-o-los-dobleces-ondulados-textura-seda-141911376.jpg'
                              : imageUrl!,
                          numberPages: numberPages.toString(),
                          pdfUrl: pdfUrl.toString(),
                        ),
                      ));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      bool confirmar = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Eliminar Manga"),
                            content: Text(
                                "¿Estás seguro de que quieres eliminar este manga?"),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text("Cancelar"),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: Text("Eliminar"),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmar != null && confirmar) {
                        // Lógica para eliminar el manga
                        await eliminarManga();

                        // Esperar un breve momento antes de volver para asegurar que la eliminación se haya completado
                        await Future.delayed(Duration(milliseconds: 500));

                        // Regresar a la pantalla anterior
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
