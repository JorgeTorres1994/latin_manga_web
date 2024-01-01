/*
import 'dart:async';
import 'package:aplicacion_manga_admin_panel/inner_screens/DonacionesScreen.dart';
import 'package:aplicacion_manga_admin_panel/inner_screens/LoginScreen.dart';
import 'package:aplicacion_manga_admin_panel/inner_screens/MapScreen.dart';
import 'package:aplicacion_manga_admin_panel/inner_screens/detalle_mangas_usuario.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashBoardScreenUsuario extends StatefulWidget {
  const DashBoardScreenUsuario({Key? key}) : super(key: key);

  @override
  _DashBoardScreenUsuarioState createState() => _DashBoardScreenUsuarioState();
}

class _DashBoardScreenUsuarioState extends State<DashBoardScreenUsuario> {
  String selectedCategory = 'Todos';
  final double bannerHeight = 80.0;
  final double letterSize = 36.0;

  User? _currentUser;
  String? _creatorUsername;

  Map<String, bool> hoveredMangas = {};
  Map<String, bool> pressedMangas = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(bannerHeight),
        child: AppBar(
          backgroundColor: Colors.green,
          title: Center(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'LATIN MANGA',
                  style: TextStyle(
                    fontSize: letterSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            User? user = snapshot.data;

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user?.uid)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                Map<String, dynamic>? userData =
                    (userSnapshot.data?.data() as Map<String, dynamic>?);

                return ListView(
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.green,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  user?.providerData[0].providerId ==
                                          'google.com'
                                      ? NetworkImage(user?.photoURL ?? '')
                                          as ImageProvider<Object>?
                                      : AssetImage('images/anime2.jpg'),
                              radius: 30,
                            ),
                            SizedBox(height: 10),
                            Text(
                              user?.providerData[0]?.providerId == 'google.com'
                                  ? user?.displayName ?? 'Usuario'
                                  : userData?['usuario'] ?? 'Usuario',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              user?.providerData[0]?.providerId == 'google.com'
                                  ? user?.providerData[0]?.email ??
                                      'Correo electrónico'
                                  : userData?['correo'] ?? 'Correo electrónico',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                        title: Text(
                          'Ubicación de tiendas',
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MapScreen()),
                          );
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                        title: Text(
                          'Donaciones',
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DonacionesScreen()),
                          );
                        }),
                    SizedBox(
                      height: 200,
                    ),
                    ListTile(
                      title: Text(
                        'Cerrar Sesión',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () async {
                        // Mostrar cuadro de diálogo de confirmación
                        bool confirmarCerrarSesion = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirmar'),
                              content:
                                  Text('¿Seguro que deseas cerrar sesión?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Text('Aceptar'),
                                ),
                              ],
                            );
                          },
                        );

                        // Si se confirma, cerrar sesión
                        if (confirmarCerrarSesion == true) {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCategoryButton('Todos'),
                    _buildCategoryButton('Shonen'),
                    _buildCategoryButton('Comedia'),
                    _buildCategoryButton('Romance'),
                    _buildCategoryButton('Gore'),
                    _buildCategoryButton('Escolar'),
                    _buildCategoryButton('Misterio'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey[200],
                padding: EdgeInsets.all(16),
                child: _buildMangaGrid(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedCategory = category;
          });
        },
        style: ElevatedButton.styleFrom(
          primary:
              category == selectedCategory ? Colors.green : Colors.transparent,
          onPrimary: Colors.white,
          side: BorderSide(color: Colors.white),
        ),
        child: Text(category),
      ),
    );
  }

  Widget _buildMangaGrid() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('mangas').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        var mangas = snapshot.data!.docs
            .where((doc) =>
                selectedCategory == 'Todos' ||
                doc['mangaCategoryName'] == selectedCategory)
            .toList();

        return Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: mangas.length,
                itemBuilder: (context, index) {
                  var manga = mangas[index];
                  return _buildMangaTile(manga);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                '# Resultados ${mangas.length}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMangaTile(QueryDocumentSnapshot manga) {
    final String mangaId = manga.id;

    return InkWell(
      onTap: () {
        // Lógica de selección al hacer clic
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalleMangasUsuario(mangaId: mangaId),
          ),
        );

        setState(() {
          pressedMangas[mangaId] = true;
        });

        Timer(Duration(milliseconds: 100), () {
          setState(() {
            pressedMangas[mangaId] = false;
          });
        });
      },
      onHover: (isHovered) {
        setState(() {
          hoveredMangas[mangaId] = isHovered;
        });
      },
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: pressedMangas[mangaId] == true
              ? Colors.grey
                  .withOpacity(0.5) // Color de fondo cuando está presionado
              : hoveredMangas[mangaId] == true
                  ? Colors.grey.withOpacity(
                      0.2) // Color de fondo cuando está seleccionado
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              manga['title'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                manga['imageUrl'],
                fit: BoxFit.cover,
                width: 250,
                height: 280,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

*/

import 'dart:async';
import 'package:aplicacion_manga_admin_panel/inner_screens/DonacionesScreen.dart';
import 'package:aplicacion_manga_admin_panel/inner_screens/LoginScreen.dart';
import 'package:aplicacion_manga_admin_panel/inner_screens/MapScreen.dart';
import 'package:aplicacion_manga_admin_panel/inner_screens/detalle_mangas_usuario.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashBoardScreenUsuario extends StatefulWidget {
  const DashBoardScreenUsuario({Key? key}) : super(key: key);

  @override
  _DashBoardScreenUsuarioState createState() => _DashBoardScreenUsuarioState();
}

class _DashBoardScreenUsuarioState extends State<DashBoardScreenUsuario> {
  String selectedCategory = 'Todos';
  final double bannerHeight = 80.0;
  final double letterSize = 36.0;

  User? _currentUser;
  Map<String, dynamic>? _userData;

  Map<String, bool> hoveredMangas = {};
  Map<String, bool> pressedMangas = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(bannerHeight),
        child: AppBar(
          backgroundColor: Colors.green,
          title: Center(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'LATIN MANGA',
                  style: TextStyle(
                    fontSize: letterSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: FutureBuilder<User?>(
          future: FirebaseAuth.instance.authStateChanges().first,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            User? user = snapshot.data;

            if (user == null) {
              return Container(); // No hay usuario autenticado
            }

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (!userSnapshot.hasData || userSnapshot.data == null) {
                  return Container(); // No hay datos de usuario
                }

                Map<String, dynamic>? userData =
                    userSnapshot.data!.data() as Map<String, dynamic>?;

                return ListView(
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.green,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  user.providerData[0].providerId ==
                                          'google.com'
                                      ? NetworkImage(user.photoURL ?? '')
                                          as ImageProvider<Object>?
                                      : AssetImage('images/anime2.jpg'),
                              radius: 30,
                            ),
                            SizedBox(height: 10),
                            Text(
                              user.providerData[0]?.providerId == 'google.com'
                                  ? user.displayName ?? 'Usuario'
                                  : userData?['usuario'] ?? 'Usuario',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              user.providerData[0]?.providerId == 'google.com'
                                  ? user.providerData[0]?.email ??
                                      'Correo electrónico'
                                  : userData?['correo'] ?? 'Correo electrónico',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Ubicación de tiendas',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MapScreen()),
                        );
                        Navigator.pop(context); // Cierra el Drawer
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      title: Text(
                        'Donaciones',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DonacionesScreen()),
                        );
                        Navigator.pop(context); // Cierra el Drawer
                      },
                    ),
                    SizedBox(
                      height: 200,
                    ),
                    ListTile(
                      title: Text(
                        'Cerrar Sesión',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () async {
                        bool confirmarCerrarSesion = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirmar'),
                              content:
                                  Text('¿Seguro que deseas cerrar sesión?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Text('Aceptar'),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirmarCerrarSesion == true) {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCategoryButton('Todos'),
                    _buildCategoryButton('Shonen'),
                    _buildCategoryButton('Comedia'),
                    _buildCategoryButton('Romance'),
                    _buildCategoryButton('Gore'),
                    _buildCategoryButton('Escolar'),
                    _buildCategoryButton('Misterio'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey[200],
                padding: EdgeInsets.all(16),
                child: _buildMangaGrid(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedCategory = category;
          });
        },
        style: ElevatedButton.styleFrom(
          primary:
              category == selectedCategory ? Colors.green : Colors.transparent,
          onPrimary: Colors.white,
          side: BorderSide(color: Colors.white),
        ),
        child: Text(category),
      ),
    );
  }

  /*Widget _buildMangaGrid() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('mangas').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        var mangas = snapshot.data!.docs
            .where((doc) =>
                selectedCategory == 'Todos' ||
                doc['mangaCategoryName'] == selectedCategory)
            .toList();

        return Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: mangas.length,
                itemBuilder: (context, index) {
                  var manga = mangas[index];
                  return _buildMangaTile(manga);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                '# Resultados ${mangas.length}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }*/

  Widget _buildMangaGrid() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('mangas').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        var mangas = snapshot.data!.docs
            .where((doc) =>
                selectedCategory == 'Todos' ||
                doc['mangaCategoryName'] == selectedCategory)
            .toList();

        return Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: mangas.length,
                itemBuilder: (context, index) {
                  var manga = mangas[index];
                  return _buildMangaTile(manga);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                '# Resultados ${mangas.length}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMangaTile(QueryDocumentSnapshot manga) {
    final String mangaId = manga.id;

    return InkWell(
      onTap: () {
        /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalleMangasUsuario(mangaId: mangaId),
          ),
        );*/
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalleMangasUsuario(
                mangaId: mangaId,
                userRating:
                    0.0), // Reemplaza 0.0 con el valor real de userRating
          ),
        );

        setState(() {
          pressedMangas[mangaId] = true;
        });

        Timer(Duration(milliseconds: 100), () {
          setState(() {
            pressedMangas[mangaId] = false;
          });
        });
      },
      onHover: (isHovered) {
        setState(() {
          hoveredMangas[mangaId] = isHovered;
        });
      },
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: pressedMangas[mangaId] == true
              ? Colors.grey.withOpacity(0.5)
              : hoveredMangas[mangaId] == true
                  ? Colors.grey.withOpacity(0.2)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              manga['title'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                manga['imageUrl'],
                fit: BoxFit.cover,
                width: 250,
                height: 280,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
