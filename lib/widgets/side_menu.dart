/*import 'package:aplicacion_manga_admin_panel/inner_screens/Todos_Mangas_Categoria.dart';
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
  String? selectedCategoria; // Agrega esta línea
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
            SizedBox(
              height: 20,
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
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Icon(Icons.category), // Icono de categoría
                SizedBox(width: 16), // Espacio entre el icono y el dropdown
                DropdownButton<String>(
                  value: selectedCategoria,
                  hint: Text('Escoge un género'), // Mensaje de hint
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategoria = newValue!;
                    });

                    if (selectedCategoria != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TodosMangasCategoria(
                              categoria: selectedCategoria!),
                        ),
                      );
                    }
                  },
                  items: [
                    null, // Opción adicional para mostrar el mensaje de hint
                    'Comedia',
                    'Romance',
                    'Shonen',
                    'Gore',
                    'Misterio',
                    'Escolar'
                  ].map((String? value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child:
                          Text(value ?? 'Escoge un género'), // Manejo de null
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(
              height: 20,
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
            SizedBox(
              height: 160,
            ),
            DrawerListTile(
              title: "Cerrar sesión",
              press: () async {
                // Mostrar cuadro de diálogo de confirmación
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

                // Si se confirma, cerrar sesión
                if (confirmarCerrarSesion == true) {
                  print('Antes de cerrar sesión');
                  authProvider.signOut();
                  print('Después de cerrar sesión');
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                }
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
  String? selectedCategoria; // Agrega esta línea
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
            SizedBox(
              height: 20,
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
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Icon(Icons.category), // Icono de categoría
                SizedBox(width: 16), // Espacio entre el icono y el dropdown
                DropdownButton<String>(
                  value: selectedCategoria,
                  hint: Text('Escoge un género'), // Mensaje de hint
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategoria = newValue!;
                    });

                    if (selectedCategoria != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TodosMangasCategoria(
                              categoria: selectedCategoria!),
                        ),
                      );
                    }
                  },
                  items: [
                    null, // Opción adicional para mostrar el mensaje de hint
                    'Comedia',
                    'Romance',
                    'Shonen',
                    'Gore',
                    'Misterio',
                    'Escolar'
                  ].map((String? value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child:
                          Text(value ?? 'Escoge un género'), // Manejo de null
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(
              height: 20,
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
            SizedBox(
              height: 160,
            ),
            DrawerListTile(
              title: "Cerrar sesión",
              press: () async {
                // Mostrar cuadro de diálogo de confirmación
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

                // Si se confirma, cerrar sesión
                if (confirmarCerrarSesion == true) {
                  print('Antes de cerrar sesión');
                  authProvider.signOut();
                  print('Después de cerrar sesión');
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                }
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
