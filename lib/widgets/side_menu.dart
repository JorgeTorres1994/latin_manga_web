/*import 'package:aplicacion_manga_admin_panel/widgets/TodosMangasCategoria.dart';
import 'package:flutter/material.dart';
import 'package:aplicacion_manga_admin_panel/inner_screens/LoginScreen.dart';
import 'package:aplicacion_manga_admin_panel/inner_screens/todos_mangas.dart';
import 'package:aplicacion_manga_admin_panel/providers/AuthProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../screens/main_screen.dart';
import '../providers/dark_theme_provider.dart';
import '../services/utils.dart';
import '../widgets/text_widget.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  User? _currentUser;
  String? _creatorUsername;
  String selectedCategoria = 'Romance'; // Agrega esta línea

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      if (mounted) {
        if (userDoc.exists) {
          final username = userDoc.get("usuario");
          setState(() {
            _currentUser = user;
            _creatorUsername = username;
          });
        } else {
          if (mounted) {
            setState(() {
              _currentUser = user;
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeState = Provider.of<DarkThemeProvider>(context);
    final theme = Utils(context).getTheme;
    final color = Utils(context).color;

    return Theme(
      data: ThemeData(
        brightness:
            themeState.getDarkTheme ? Brightness.dark : Brightness.light,
      ),
      child: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_creatorUsername != null)
                      Text(
                        "Bienvenido, $_creatorUsername!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (_currentUser != null &&
                        _creatorUsername ==
                            null) // Mostrar el nombre de usuario cuando no hay nombre de creador
                      Text(
                        "Bienvenido, ${_currentUser!.displayName}!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    Image.asset(
                      "images/anime2.jpg",
                    ),
                  ],
                ),
              ),
            ),
            DrawerListTile(
              title: "Inicio",
              press: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => MainScreen(
                      isAuthenticated: true,
                    ),
                  ),
                );
              },
              icon: Icons.home_filled,
            ),
            DrawerListTile(
              title: "Ver todos los mangas",
              press: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TodosMangas()));
              },
              icon: Icons.store,
            ),
            SwitchListTile(
              title: const Text('Tema'),
              secondary: Icon(themeState.getDarkTheme
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined),
              value: theme,
              onChanged: (value) {
                setState(() {
                  themeState.setDarkTheme = value;
                });
              },
            ),
            DropdownButton<String>(
              value: selectedCategoria,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategoria = newValue!;
                });

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TodosMangasCategoria(categoria: selectedCategoria),
                  ),
                );
              },
              items: ['Romance', 'Shonen', 'Gore', 'Misterio', 'Escolar']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(
              height: 240,
            ),
            DrawerListTile(
              title: "Cerrar sesión",
              press: () async {
                authProvider.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              icon: Icons.logout,
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.press,
    required this.icon,
  }) : super(key: key);

  final String title;
  final VoidCallback press;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = theme == true ? Colors.white : Colors.black;

    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Icon(
        icon,
        size: 18,
      ),
      title: TextWidget(
        text: title,
        color: color,
      ),
    );
  }
}
*/

import 'package:aplicacion_manga_admin_panel/inner_screens/Todos_Mangas_Categoria.dart';
import 'package:flutter/material.dart';
import 'package:aplicacion_manga_admin_panel/inner_screens/LoginScreen.dart';
import 'package:aplicacion_manga_admin_panel/inner_screens/todos_mangas.dart';
import 'package:aplicacion_manga_admin_panel/providers/AuthProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../screens/main_screen_admin.dart';
import '../providers/dark_theme_provider.dart';
import '../services/utils.dart';
import '../widgets/text_widget.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  User? _currentUser;
  String? _creatorUsername;
  String selectedCategoria = 'Comedia'; // Agrega esta línea
  bool addSpace = false; // Nuevo parámetro para agregar espacio

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      if (mounted) {
        if (userDoc.exists) {
          final username = userDoc.get("usuario");
          setState(() {
            _currentUser = user;
            _creatorUsername = username;
          });
        } else {
          if (mounted) {
            setState(() {
              _currentUser = user;
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeState = Provider.of<DarkThemeProvider>(context);
    final theme = Utils(context).getTheme;

    return Theme(
      data: ThemeData(
        brightness:
            themeState.getDarkTheme ? Brightness.dark : Brightness.light,
      ),
      child: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_creatorUsername != null)
                    Text(
                      "$_creatorUsername",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  if (_currentUser != null && _creatorUsername == null)
                    Text(
                      "${_currentUser!.displayName}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                  SizedBox(height: 10), // Espacio entre el texto y la imagen

                  Align(
                    alignment: Alignment.center,
                    child: _currentUser != null &&
                            _currentUser!.photoURL != null &&
                            _currentUser!.providerData[0].providerId !=
                                'password'
                        ? CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                NetworkImage(_currentUser!.photoURL!),
                          )
                        : _currentUser != null &&
                                _currentUser!.providerData[0].providerId ==
                                    'password'
                            ? CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    AssetImage('images/anime2.jpg'),
                              )
                            : const CircleAvatar(radius: 40),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            DrawerListTile(
              title: "Inicio",
              press: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => MainScreenAdmin(
                      isAuthenticated: true,
                    ),
                  ),
                );
              },
              icon: Icons.home_filled,
            ),
            DrawerListTile(
              title: "Ver todos los mangas",
              press: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TodosMangas()));
              },
              icon: Icons.store,
            ),
            SwitchListTile(
              title: const Text('Tema'),
              secondary: Icon(themeState.getDarkTheme
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined),
              value: theme,
              onChanged: (value) {
                setState(() {
                  themeState.setDarkTheme = value;
                });
              },
            ),
            DropdownButton<String>(
              value: selectedCategoria,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategoria = newValue!;
                });

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TodosMangasCategoria(categoria: selectedCategoria),
                  ),
                );
              },
              items: [
                'Comedia',
                'Romance',
                'Shonen',
                'Gore',
                'Misterio',
                'Escolar'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(
              height: 220,
            ),
            DrawerListTile(
              title: "Cerrar sesión",
              press: () async {
                print('Antes de cerrar sesión');
                authProvider.signOut();
                print('Después de cerrar sesión');
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              icon: Icons.logout,
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.press,
    required this.icon,
  }) : super(key: key);

  final String title;
  final VoidCallback press;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = theme == true ? Colors.white : Colors.black;

    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Icon(
        icon,
        size: 18,
      ),
      title: TextWidget(
        text: title,
        color: color,
      ),
    );
  }
}
