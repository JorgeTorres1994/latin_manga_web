/*import 'package:aplicacion_manga_admin_panel/consts/constants.dart';
import 'package:aplicacion_manga_admin_panel/responsive.dart';
import 'package:aplicacion_manga_admin_panel/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/mangas_widget.dart'; // Importa el widget MangasWidget

class BuscadorMangas extends StatefulWidget {
  const BuscadorMangas({
    Key? key,
    required this.title,
    required this.fct,
    this.showTexField = true,
  }) : super(key: key);

  final String title;
  final Function fct;
  final bool showTexField;

  @override
  _BuscadorMangasState createState() => _BuscadorMangasState();
}

class _BuscadorMangasState extends State<BuscadorMangas> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> searchResults = [];

  void _onSearch() {
    // Obtener el valor del campo de búsqueda
    String searchTerm = _searchController.text.trim();

    // Realizar la búsqueda en Firestore y almacenar los resultados en searchResults
    FirebaseFirestore.instance
        .collection('mangas')
        .where('title', isEqualTo: searchTerm)
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        searchResults = querySnapshot.docs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = Utils(context).color;

    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              widget.fct();
            },
          ),
        if (Responsive.isDesktop(context))
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.title,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        if (Responsive.isDesktop(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        !widget.showTexField
            ? Container()
            : Expanded(
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      onSubmitted: (_) => _onSearch(),
                      decoration: InputDecoration(
                        hintText: "Buscar",
                        fillColor: Theme.of(context).cardColor,
                        filled: true,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        suffixIcon: InkWell(
                          onTap: _onSearch,
                          child: Container(
                            padding:
                                const EdgeInsets.all(defaultPadding * 0.75),
                            margin: const EdgeInsets.symmetric(
                                horizontal: defaultPadding / 2),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: const Icon(
                              Icons.search,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Mostrar los resultados de la búsqueda usando MangasWidget
                    if (searchResults.isNotEmpty)
                      Column(
                        children: searchResults
                            .map((doc) => MangasWidget(id: doc.id))
                            .toList(),
                      ),
                  ],
                ),
              ),
      ],
    );
  }
}
*/

import 'package:aplicacion_manga_admin_panel/consts/constants.dart';
import 'package:aplicacion_manga_admin_panel/responsive.dart';
import 'package:aplicacion_manga_admin_panel/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/mangas_widget.dart'; // Importa el widget MangasWidget

class BuscadorMangas extends StatefulWidget {
  const BuscadorMangas({
    Key? key,
    required this.title,
    required this.fct,
    this.showTexField = true,
  }) : super(key: key);

  final String title;
  final Function fct;
  final bool showTexField;

  @override
  _BuscadorMangasState createState() => _BuscadorMangasState();
}

class _BuscadorMangasState extends State<BuscadorMangas> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> searchResults = [];

  void _onSearch() {
    // Obtener el valor del campo de búsqueda
    String searchTerm = _searchController.text.trim();

    // Realizar la búsqueda en Firestore y almacenar los resultados en searchResults
    FirebaseFirestore.instance
        .collection('mangas')
        .where('title', isEqualTo: searchTerm)
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        searchResults = querySnapshot.docs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = Utils(context).color;

    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              widget.fct();
            },
          ),
        if (Responsive.isDesktop(context))
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.title,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        if (Responsive.isDesktop(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        !widget.showTexField
            ? Container()
            : Expanded(
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      onSubmitted: (_) => _onSearch(),
                      decoration: InputDecoration(
                        hintText: "Buscar",
                        fillColor: Theme.of(context).cardColor,
                        filled: true,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        suffixIcon: InkWell(
                          onTap: _onSearch,
                          child: Container(
                            padding:
                                const EdgeInsets.all(defaultPadding * 0.75),
                            margin: const EdgeInsets.symmetric(
                                horizontal: defaultPadding / 2),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: const Icon(
                              Icons.search,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Mostrar los resultados de la búsqueda usando MangasWidget
                    if (searchResults.isNotEmpty)
                      Column(
                        children: searchResults
                            .map((doc) => MangasWidget(id: doc.id))
                            .toList(),
                      ),
                  ],
                ),
              ),
      ],
    );
  }
}
