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
  User? _user;
  Map<String, dynamic>? _userData;
  String selectedCategory = 'Todos';

  Map<String, bool> hoveredMangas = {};
  Map<String, bool> pressedMangas = {};

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        _user = user;
        _userData = userSnapshot.data() as Map<String, dynamic>?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 600;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: Colors.green,
          title: Center(
            child: Container(
              padding: EdgeInsets.all(isLargeScreen ? 16 : 8),
              child: Center(
                child: Text(
                  'LATIN MANGA',
                  style: TextStyle(
                    fontSize: isLargeScreen ? 24.0 : 18.0,
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
        child: ListView(
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
                          _user?.providerData[0].providerId == 'google.com'
                              ? NetworkImage(_user?.photoURL ?? '')
                                  as ImageProvider<Object>?
                              : AssetImage('images/anime2.jpg'),
                      radius: 30,
                    ),
                    SizedBox(height: 10),
                    Text(
                      _user?.providerData[0]?.providerId == 'google.com'
                          ? _user?.displayName ?? 'Usuario'
                          : _userData?['usuario'] ?? 'Usuario',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _user?.providerData[0]?.providerId == 'google.com'
                          ? _user?.providerData[0]?.email ??
                              'Correo electrónico'
                          : _userData?['correo'] ?? 'Correo electrónico',
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
                style: TextStyle(color: Colors.black),
              ),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapScreen()),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              title: Text(
                'Donaciones',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DonacionesScreen()),
                );
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
                      content: Text('¿Seguro que deseas cerrar sesión?'),
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
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(
                vertical: isLargeScreen ? 20 : 10,
                horizontal: isLargeScreen ? 40 : 20,
              ),
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
                padding: EdgeInsets.all(isLargeScreen ? 24 : 16),
                child: _buildMangaGrid(isLargeScreen),
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

  Widget _buildMangaGrid(bool isLargeScreen) {
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
                  crossAxisCount: isLargeScreen ? 4 : 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: mangas.length,
                itemBuilder: (context, index) {
                  var manga = mangas[index];
                  return _buildMangaTile(manga, isLargeScreen);
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

  Widget _buildMangaTile(QueryDocumentSnapshot manga, bool isLargeScreen) {
    final String mangaId = manga.id;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetalleMangasUsuario(mangaId: mangaId, userRating: 0.0),
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
        width: isLargeScreen ? 150 : double.infinity,
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
            Flexible(
              child: Text(
                manga['title'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isLargeScreen ? 18 : 14,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: isLargeScreen ? 8 : 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                manga['imageUrl'],
                fit: BoxFit.cover,
                width: isLargeScreen ? 250 : double.infinity,
                height: isLargeScreen ? 280 : 150,
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
  User? _user;
  Map<String, dynamic>? _userData;
  String selectedCategory = 'Todos';

  Map<String, bool> hoveredMangas = {};
  Map<String, bool> pressedMangas = {};

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        _user = user;
        _userData = userSnapshot.data() as Map<String, dynamic>?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 600;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: Colors.green,
          title: Center(
            child: Container(
              padding: EdgeInsets.all(isLargeScreen ? 16 : 8),
              child: Center(
                child: Text(
                  'LATIN MANGA',
                  style: TextStyle(
                    fontSize: isLargeScreen ? 24.0 : 18.0,
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
        child: ListView(
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
                          _user?.providerData[0].providerId == 'google.com'
                              ? NetworkImage(_user?.photoURL ?? '')
                                  as ImageProvider<Object>?
                              : AssetImage('images/anime2.jpg'),
                      radius: 30,
                    ),
                    SizedBox(height: 10),
                    Text(
                      _user?.providerData[0]?.providerId == 'google.com'
                          ? _user?.displayName ?? 'Usuario'
                          : _userData?['usuario'] ?? 'Usuario',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _user?.providerData[0]?.providerId == 'google.com'
                          ? _user?.providerData[0]?.email ??
                              'Correo electrónico'
                          : _userData?['correo'] ?? 'Correo electrónico',
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
              leading: Icon(Icons.location_on),
              title: Text(
                'Ubicación de tiendas',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapScreen()),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              leading: Icon(Icons.monetization_on),
              title: Text(
                'Donaciones',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DonacionesScreen()),
                );
              },
            ),
            SizedBox(
              height: 200,
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text(
                'Cerrar Sesión',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              onTap: () async {
                bool confirmarCerrarSesion = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirmar'),
                      content: Text('¿Seguro que deseas cerrar sesión?'),
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
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(
                vertical: isLargeScreen ? 20 : 10,
                horizontal: isLargeScreen ? 40 : 20,
              ),
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
                padding: EdgeInsets.all(isLargeScreen ? 24 : 16),
                child: _buildMangaGrid(isLargeScreen),
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

  Widget _buildMangaGrid(bool isLargeScreen) {
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
                  crossAxisCount: isLargeScreen ? 4 : 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: mangas.length,
                itemBuilder: (context, index) {
                  var manga = mangas[index];
                  return _buildMangaTile(manga, isLargeScreen);
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

  Widget _buildMangaTile(QueryDocumentSnapshot manga, bool isLargeScreen) {
    final String mangaId = manga.id;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetalleMangasUsuario(mangaId: mangaId, userRating: 0.0),
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
        width: isLargeScreen ? 150 : double.infinity,
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
            Flexible(
              child: Text(
                manga['title'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isLargeScreen ? 18 : 14,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: isLargeScreen ? 8 : 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                manga['imageUrl'],
                fit: BoxFit.cover,
                width: isLargeScreen ? 250 : double.infinity,
                height: isLargeScreen ? 280 : 150,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
