/*import 'package:aplicacion_manga_admin_panel/inner_screens/LoginScreen.dart';
import 'package:aplicacion_manga_admin_panel/inner_screens/agregar_manga.dart';
import 'package:aplicacion_manga_admin_panel/providers/AuthProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:aplicacion_manga_admin_panel/screens/main_screen_admin.dart';
import 'package:provider/provider.dart';

import 'providers/dark_theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: const FirebaseOptions(
      apiKey: "AIzaSyBDwRJUgyR4SkUIFNn78XmFjXTBxYL1ZxY",
      appId: "1:845848151713:web:fd6794a88b7872dd3e92e0",
      messagingSenderId: "845848151713",
      projectId: "latin-manga",
      storageBucket: "latin-manga.appspot.com",
    ),
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DarkThemeProvider>(
          create: (_) => themeChangeProvider,
        ),
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            theme: themeProvider.getDarkTheme
                ? ThemeData.dark()
                : ThemeData.light(),
            debugShowCheckedModeBanner: false,
            title: 'LATIN MANGA - PANEL ADMINISTRATIVO',
            //theme: Styles.themeData(themeProvider.getDarkTheme, context),
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final User? user = snapshot.data;
                  // Si el usuario está autenticado, muestra MainScreen, de lo contrario, muestra LoginScreen
                  return user != null
                      ? MainScreenAdmin(isAuthenticated: true)
                      : LoginScreen();
                } else {
                  // Muestra una pantalla de carga o cualquier otro indicador mientras se verifica la autenticación
                  return const CircularProgressIndicator();
                }
              },
            ),
            routes: {
              LoginScreen.routeName: (context) => LoginScreen(),
              AgregarMangaForm.routeName: (context) => const AgregarMangaForm(),
              //EditMangaForm.routeName: (context) => const EditMangaForm()
            },
          );
        },
      ),
    );
  }
}
*/

import 'package:aplicacion_manga_admin_panel/inner_screens/LoginScreen.dart';
import 'package:aplicacion_manga_admin_panel/inner_screens/agregar_manga.dart';
import 'package:aplicacion_manga_admin_panel/providers/AuthProvider.dart';
import 'package:aplicacion_manga_admin_panel/screens/main_screen_usuarios.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:aplicacion_manga_admin_panel/screens/main_screen_admin.dart';
import 'package:provider/provider.dart';

import 'providers/dark_theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: const FirebaseOptions(
      apiKey: "AIzaSyBDwRJUgyR4SkUIFNn78XmFjXTBxYL1ZxY",
      appId: "1:845848151713:web:fd6794a88b7872dd3e92e0",
      messagingSenderId: "845848151713",
      projectId: "latin-manga",
      storageBucket: "latin-manga.appspot.com",
    ),
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DarkThemeProvider>(
          create: (_) => themeChangeProvider,
        ),
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            theme: themeProvider.getDarkTheme
                ? ThemeData.dark()
                : ThemeData.light(),
            debugShowCheckedModeBanner: false,
            title: 'LATIN MANGA',
            //theme: Styles.themeData(themeProvider.getDarkTheme, context),
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final User? user = snapshot.data;

                  if (user != null) {
                    // Obtén la información adicional del usuario desde Cloud Firestore
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .get()
                        .then((DocumentSnapshot snapshot) {
                      if (snapshot.exists) {
                        final userData =
                            snapshot.data() as Map<String, dynamic>?;

                        if (userData?['isAdmin'] == true) {
                          // Si el usuario es administrador, muestra MainScreenAdmin
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MainScreenAdmin(isAuthenticated: true),
                            ),
                          );
                        } else {
                          // Si el usuario no es administrador, muestra MainPrincipalUsuario
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainScreenUsuario(
                                isAuthenticated: true,
                              ),
                            ),
                          );
                        }
                      }
                    });
                  } else {
                    // Si el usuario es null, muestra LoginScreen
                    return LoginScreen();
                  }
                } else {
                  // Muestra una pantalla de carga o cualquier otro indicador mientras se verifica la autenticación
                  return const CircularProgressIndicator();
                }

                // Añade un return adicional para asegurar que se devuelva un valor en todos los casos
                return const CircularProgressIndicator();
              },
            ),

            routes: {
              LoginScreen.routeName: (context) => LoginScreen(),
              //AgregarMangaForm.routeName: (context) => const AgregarMangaForm(),
              AgregarMangaForm.routeName: (context) => AgregarMangaForm(),
              //EditMangaForm.routeName: (context) => const EditMangaForm()
            },
          );
        },
      ),
    );
  }
}

// Supongamos que ya tienes una referencia a tu instancia de Firestore
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Luego, cuando creas un nuevo usuario o actualizas su información, también establece su rol
void updateUserData(User user) {
  _firestore.collection('users').doc(user.uid).set({
    'email': user.email,
    'isAdmin': false, // Cambia esto según el rol del usuario
    // Otros campos de usuario si es necesario
  });
}
