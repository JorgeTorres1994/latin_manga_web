/*import 'package:aplicacion_manga_admin_panel/consts/constants.dart';
import 'package:aplicacion_manga_admin_panel/inner_screens/agregar_manga.dart';
import 'package:aplicacion_manga_admin_panel/inner_screens/todos_mangas.dart';
import 'package:aplicacion_manga_admin_panel/responsive.dart';
import 'package:aplicacion_manga_admin_panel/services/utils.dart';
import 'package:aplicacion_manga_admin_panel/widgets/MangaGridWidget.dart';
import 'package:aplicacion_manga_admin_panel/widgets/buttons.dart';
import 'package:aplicacion_manga_admin_panel/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String searchTerm = '';
  List<DocumentSnapshot> searchResults = [];

  void _onSearch() {
    FirebaseFirestore.instance
        .collection('mangas')
        .where('title', isGreaterThanOrEqualTo: searchTerm)
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        searchResults = querySnapshot.docs.where((doc) {
          // Utilizamos una expresión regular para buscar coincidencias exactas
          RegExp regex = RegExp("\\b$searchTerm\\b", caseSensitive: false);
          return regex.hasMatch(doc['title']);
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    // Lógica para abrir el menú lateral
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Panel Administrativo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                // Otros elementos del encabezado
              ],
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  searchTerm = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Buscar manga",
                fillColor: Theme.of(context).cardColor,
                filled: true,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                suffixIcon: InkWell(
                  onTap: _onSearch,
                  child: Container(
                    padding: const EdgeInsets.all(defaultPadding * 0.75),
                    margin: const EdgeInsets.symmetric(
                        horizontal: defaultPadding / 2),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: const Icon(
                      Icons.search,
                      size: 25,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextWidget(
                        text: 'Últimos mangas',
                        color: Utils(context).color,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          ButtonsWidget(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TodosMangas(),
                                ),
                              );
                            },
                            text: 'Ver todo',
                            icon: Icons.book_online,
                            backgroundColor: Colors.blueGrey,
                          ),
                          const Spacer(),
                          ButtonsWidget(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AgregarMangaForm(),
                                ),
                              );
                            },
                            text: 'Agregar mangas',
                            icon: Icons.add,
                            backgroundColor: Colors.blueGrey,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Responsive(
                        mobile: MangaGridWidget(
                          crossAxisCount: size.width < 650 ? 2 : 4,
                          childAspectRatio:
                              size.width < 650 && size.width > 350 ? 1.1 : 0.8,
                          isInMain: true,
                          searchResults:
                              searchTerm.isNotEmpty ? searchResults : null,
                        ),
                        desktop: MangaGridWidget(
                          crossAxisCount: size.width < 650 ? 2 : 4,
                          childAspectRatio: size.width < 1400 ? 0.8 : 1.05,
                          isInMain: true,
                          searchResults:
                              searchTerm.isNotEmpty ? searchResults : null,
                        ),
                      ),
                      const SizedBox(height: defaultPadding),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
*/

import 'package:aplicacion_manga_admin_panel/consts/constants.dart';
import 'package:aplicacion_manga_admin_panel/inner_screens/agregar_manga.dart';
import 'package:aplicacion_manga_admin_panel/inner_screens/todos_mangas.dart';
import 'package:aplicacion_manga_admin_panel/responsive.dart';
import 'package:aplicacion_manga_admin_panel/services/utils.dart';
import 'package:aplicacion_manga_admin_panel/widgets/MangaGridWidget.dart';
import 'package:aplicacion_manga_admin_panel/widgets/buttons.dart';
import 'package:aplicacion_manga_admin_panel/widgets/side_menu.dart';
import 'package:aplicacion_manga_admin_panel/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashboarScreenAdmin extends StatefulWidget {
  const DashboarScreenAdmin({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboarScreenAdmin> {
  String searchTerm = '';
  List<DocumentSnapshot> searchResults = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onSearch() {
    FirebaseFirestore.instance
        .collection('mangas')
        .where('title', isGreaterThanOrEqualTo: searchTerm)
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        searchResults = querySnapshot.docs.where((doc) {
          RegExp regex = RegExp("\\b$searchTerm\\b", caseSensitive: false);
          return regex.hasMatch(doc['title']);
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          title: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Panel Administrativo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        drawer: const SideMenu(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    searchTerm = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Buscar manga",
                  fillColor: Theme.of(context).cardColor,
                  filled: true,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  suffixIcon: InkWell(
                    onTap: _onSearch,
                    child: Container(
                      padding: const EdgeInsets.all(defaultPadding * 0.75),
                      margin: const EdgeInsets.symmetric(
                          horizontal: defaultPadding / 2),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: const Icon(
                        Icons.search,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        TextWidget(
                          text: 'Últimos mangas',
                          color: Utils(context).color,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            ButtonsWidget(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TodosMangas(),
                                  ),
                                );
                              },
                              text: 'Ver todo',
                              icon: Icons.book_online,
                              backgroundColor: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black // Color para el tema claro
                                  : Colors.white, // Color para el tema oscuro
                              textColor: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors
                                      .white // Color del texto para el tema claro
                                  : Colors
                                      .black, // Color del texto para el tema oscuro
                            ),
                            const Spacer(),
                            ButtonsWidget(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AgregarMangaForm(),
                                  ),
                                );
                              },
                              text: 'Agregar mangas',
                              icon: Icons.add,
                              backgroundColor: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black // Color para el tema claro
                                  : Colors.white, // Color para el tema oscuro
                              textColor: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors
                                      .white // Color del texto para el tema claro
                                  : Colors
                                      .black, // Color del texto para el tema oscuro
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Responsive(
                          mobile: MangaGridWidget(
                            crossAxisCount: size.width < 650 ? 2 : 4,
                            childAspectRatio:
                                size.width < 650 && size.width > 350
                                    ? 1.1
                                    : 0.8,
                            isInMain: true,
                            searchResults:
                                searchTerm.isNotEmpty ? searchResults : null,
                          ),
                          desktop: MangaGridWidget(
                            crossAxisCount: size.width < 650 ? 2 : 4,
                            childAspectRatio: size.width < 1400 ? 0.8 : 1.05,
                            isInMain: true,
                            searchResults:
                                searchTerm.isNotEmpty ? searchResults : null,
                          ),
                        ),
                        const SizedBox(height: defaultPadding),
                      ],
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
}
