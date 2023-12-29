/*import 'package:aplicacion_manga_admin_panel/consts/constants.dart';
import 'package:aplicacion_manga_admin_panel/services/utils.dart';
import 'package:aplicacion_manga_admin_panel/widgets/mangas_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MangaGridWidget extends StatelessWidget {
  const MangaGridWidget({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    this.isInMain = true,
    this.searchResults, // Agrega el parámetro searchResults aquí
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  final bool isInMain;
  final List<DocumentSnapshot>?
      searchResults; // Declara searchResults como List<DocumentSnapshot>?

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('mangas').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          final List<DocumentSnapshot> displayedMangas = searchResults ??
              snapshot.data!
                  .docs; // Usa searchResults si está presente, de lo contrario, usa todos los mangas

          if (displayedMangas.isNotEmpty) {
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: isInMain && displayedMangas.length > 4
                  ? 4
                  : displayedMangas.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: defaultPadding,
                mainAxisSpacing: defaultPadding,
              ),
              itemBuilder: (context, index) {
                final mangaDoc = displayedMangas[index];
                return MangasWidget(id: mangaDoc.id);
              },
            );
          } else {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: Text('Tu tienda está vacía'),
              ),
            );
          }
        }
        return const Center(
          child: Text(
            'Ocurrió un error',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        );
      },
    );
  }
}

*/

import 'package:aplicacion_manga_admin_panel/consts/constants.dart';
import 'package:aplicacion_manga_admin_panel/services/utils.dart';
import 'package:aplicacion_manga_admin_panel/widgets/mangas_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MangaGridWidget extends StatelessWidget {
  const MangaGridWidget({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    this.isInMain = true,
    this.searchResults, // Agrega el parámetro searchResults aquí
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  final bool isInMain;
  final List<DocumentSnapshot>?
      searchResults; // Declara searchResults como List<DocumentSnapshot>?

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('mangas').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          final List<DocumentSnapshot> displayedMangas = searchResults ??
              snapshot.data!
                  .docs; // Usa searchResults si está presente, de lo contrario, usa todos los mangas

          if (displayedMangas.isNotEmpty) {
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: isInMain && displayedMangas.length > 4
                  ? 4
                  : displayedMangas.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: defaultPadding,
                mainAxisSpacing: defaultPadding,
              ),
              itemBuilder: (context, index) {
                final mangaDoc = displayedMangas[index];
                return MangasWidget(id: mangaDoc.id);
              },
            );
          } else {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: Text('El sistema de mangas está vacío'),
              ),
            );
          }
        }
        return const Center(
          child: Text(
            'Ocurrió un error',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        );
      },
    );
  }
}
