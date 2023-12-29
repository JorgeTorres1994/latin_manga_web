import 'package:aplicacion_manga_admin_panel/consts/constants.dart';
import 'package:aplicacion_manga_admin_panel/responsive.dart';
import 'package:aplicacion_manga_admin_panel/services/utils.dart';
import 'package:aplicacion_manga_admin_panel/widgets/MangaGridWidget.dart';
import 'package:aplicacion_manga_admin_panel/widgets/side_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TodosMangas extends StatefulWidget {
  const TodosMangas({Key? key}) : super(key: key);

  @override
  State<TodosMangas> createState() => _TodosMangasState();
}

class _TodosMangasState extends State<TodosMangas> {
  String searchTerm = '';
  List<DocumentSnapshot<Object?>> searchResults = [];

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
    return Scaffold(
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              const Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'TODOS LOS MANGAS',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
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
                    SizedBox(
                      height: 30,
                    ),
                    Responsive(
                      mobile: MangaGridWidget(
                        crossAxisCount: size.width < 650 ? 2 : 4,
                        childAspectRatio:
                            size.width < 650 && size.width > 350 ? 1.1 : 0.8,
                        isInMain: false,
                        searchResults:
                            searchTerm.isNotEmpty ? searchResults : null,
                      ),
                      desktop: MangaGridWidget(
                        childAspectRatio: size.width < 1400 ? 0.8 : 1.05,
                        isInMain: false,
                        searchResults:
                            searchTerm.isNotEmpty ? searchResults : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
