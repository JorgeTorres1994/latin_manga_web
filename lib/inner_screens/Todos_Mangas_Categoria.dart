import 'package:aplicacion_manga_admin_panel/consts/constants.dart';
import 'package:aplicacion_manga_admin_panel/responsive.dart';
import 'package:aplicacion_manga_admin_panel/services/utils.dart';
import 'package:aplicacion_manga_admin_panel/widgets/mangas_widget.dart';
import 'package:aplicacion_manga_admin_panel/widgets/side_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TodosMangasCategoria extends StatefulWidget {
  final String? categoria;
  final int crossAxisCount;
  final double childAspectRatio;
  final bool isInMain;

  const TodosMangasCategoria({
    Key? key,
    this.categoria,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    this.isInMain = true,
  }) : super(key: key);

  @override
  _TodosMangasCategoriaState createState() => _TodosMangasCategoriaState();
}

class _TodosMangasCategoriaState extends State<TodosMangasCategoria> {
  String searchTerm = '';
  List<DocumentSnapshot> searchResults = [];

  void _onSearch() {
    FirebaseFirestore.instance
        .collection('mangas')
        .where('mangaCategoryName', isEqualTo: widget.categoria)
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
    final Color color = Utils(context).color;
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
              child: CustomScrollView(
                controller: ScrollController(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Mangas de ${widget.categoria}',
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                      ],
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('mangas')
                        .where('mangaCategoryName', isEqualTo: widget.categoria)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SliverFillRemaining(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.active) {
                        if (snapshot.data!.docs.isNotEmpty) {
                          return SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  4, // Ajusta según tus preferencias
                              childAspectRatio:
                                  0.8, // Ajusta este valor para mantener la consistencia
                              crossAxisSpacing: defaultPadding,
                              mainAxisSpacing: defaultPadding,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                if (snapshot.data!.docs.isNotEmpty) {
                                  final mangaDoc = searchTerm.isNotEmpty
                                      ? searchResults[index]
                                      : snapshot.data!.docs[index];
                                  return MangasWidget(id: mangaDoc.id);
                                } else {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(18.0),
                                      child: Text(
                                          'No hay mangas disponibles para esta categoría'),
                                    ),
                                  );
                                }
                              },
                              childCount: searchTerm.isNotEmpty
                                  ? searchResults.length
                                  : snapshot.data!.docs.length,
                            ),
                          );
                        } else {
                          return const SliverFillRemaining(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(18.0),
                                child: Text(
                                    'No hay mangas disponibles para esta categoría'),
                              ),
                            ),
                          );
                        }
                      }
                      return const SliverFillRemaining(
                        child: Center(
                          child: Text(
                            'Ocurrió un error',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
