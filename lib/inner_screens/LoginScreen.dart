/*
import 'package:aplicacion_manga_admin_panel/providers/AuthProvider.dart';
import 'package:aplicacion_manga_admin_panel/responsive.dart';
import 'package:aplicacion_manga_admin_panel/screens/dashboard_screen_usuario.dart';
import 'package:aplicacion_manga_admin_panel/services/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:aplicacion_manga_admin_panel/providers/dark_theme_provider.dart';
import 'package:aplicacion_manga_admin_panel/screens/loading_manager.dart';
import 'package:aplicacion_manga_admin_panel/screens/main_screen_admin.dart';
import 'package:aplicacion_manga_admin_panel/widgets/textos_widget.dart';

final images = [
  "https://static1.cbrimages.com/wordpress/wp-content/uploads/2020/04/perfected-super-saiyan-blue-vegeta.jpg",
  "https://e.rpp-noticias.io/xlarge/2019/04/22/463246_780848.jpg",
  "https://static1.cbrimages.com/wordpress/wp-content/uploads/2023/06/beast-gohan-on-dragon-ball-super.jpg",
  "https://pbs.twimg.com/media/D8ouFw6XkAIte5i?format=jpg&name=large",
  "https://e.rpp-noticias.io/xlarge/2018/11/22/484448_715070.jpg",
];

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isDarkMode = false;
  late DarkThemeProvider themeState;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initTheme();
  }

  void _initTheme() async {
    await Future.delayed(Duration.zero);
    themeState = Provider.of<DarkThemeProvider>(context, listen: false);
    setState(() {
      isDarkMode = themeState.getDarkTheme;
    });
  }

  Future<void> signInWithEmailAndPassword() async {
    setState(() {
      isLoading = true;
    });

    try {
      final String email = emailController.text.trim();
      final String password = passwordController.text.trim();

      UserCredential authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = authResult.user;

      if (user != null) {
        // Consultar Firestore para obtener información adicional del usuario
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
            .instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          // Verificar el campo isAdmin antes de redirigir
          bool isAdmin = userDoc.data()!['isAdmin'] ?? false;

          if (isAdmin) {
            print('Inicio de sesión exitoso: ${user.displayName}');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreenAdmin(
                  isAuthenticated: true,
                ),
              ),
            );
          } else {
            print(
                'Inicio de sesión exitoso, pero el usuario no es un administrador.');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DashBoardScreenUsuario(),
              ),
            );
          }
        }
      }
    } catch (e) {
      // Manejar errores de inicio de sesión con correo y contraseña aquí
      print('Error al iniciar sesión: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User? user = authResult.user;

        if (user != null) {
          print('Inicio de sesión con Google exitoso: ${user.displayName}');
          // Si el inicio de sesión con Google es exitoso, redirige al MainScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreenAdmin(
                isAuthenticated: true,
              ),
            ),
          );
        }
      }
    } catch (e) {
      // Manejar errores de inicio de sesión con Google aquí
      print('Error al iniciar sesión con Google: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.accessToken != null) {
        final AuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(result.accessToken! as String);

        // Iniciar sesión con Firebase
        await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);

        // Actualizar el estado de autenticación
        Provider.of<AuthProvider>(context, listen: false).signIn();
      } else {
        print('Inicio de sesión con Facebook cancelado o fallido.');
      }
    } catch (e, stackTrace) {
      print('Error al iniciar sesión con Facebook: $e');
      print('Stack Trace: $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final bool isDarkMode = themeState.getDarkTheme;
    final Color color = isDarkMode ? Colors.white : Colors.black;

    return Responsive(
      mobile: _buildMobileLoginScreen(color, themeState),
      desktop: _buildDesktopLoginScreen(color, themeState),
    );
  }

  Widget _buildMobileLoginScreen(Color color, DarkThemeProvider themeState) {
    final theme = Utils(context).getTheme;
    return Scaffold(
      body: LoadingManager(
        isLoading: isLoading,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CarouselSlider.builder(
                options: CarouselOptions(
                  height: 180,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  autoPlayInterval: const Duration(seconds: 2),
                ),
                itemCount: images.length,
                itemBuilder: (context, index, realIndex) {
                  final urlImage = images[index];
                  return buildImage(urlImage, index);
                },
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: TextosWidget(
                  text: 'LATIN MANGA',
                  color: color,
                  textSize: 32,
                  isTitle: true,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: isLoading ? null : signInWithEmailAndPassword,
                child: Text('Ingresar'),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'O ingresa con',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: isLoading ? null : signInWithGoogle,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/google_icon.png',
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(width: 12),
                    Text('Iniciar sesión con Google'),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: isLoading ? null : signInWithGoogle,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 90, 145, 241),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'iconos/facebook.png',
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(width: 12),
                    Text('Iniciar sesión con Facebook'),
                  ],
                ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLoginScreen(Color color, DarkThemeProvider themeState) {
    final theme = Utils(context).getTheme;
    return Scaffold(
      body: LoadingManager(
        isLoading: isLoading,
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CarouselSlider.builder(
                      options: CarouselOptions(
                        height: 180,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        autoPlayInterval: Duration(seconds: 2),
                      ),
                      itemCount: images.length,
                      itemBuilder: (context, index, realIndex) {
                        final urlImage = images[index];
                        return buildImage(urlImage, index);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: TextosWidget(
                        text: 'LATIN MANGA',
                        color: color,
                        textSize: 32,
                        isTitle: true,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: isLoading ? null : signInWithEmailAndPassword,
                      child: Text('Ingresar'),
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'O ingresa con',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: isLoading ? null : signInWithGoogle,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/google_icon.png',
                            width: 24,
                            height: 24,
                          ),
                          SizedBox(width: 12),
                          Text('Iniciar sesión con Google'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImage(String urlImage, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(urlImage),
        ),
      ),
    );
  }
}
*/

import 'package:aplicacion_manga_admin_panel/responsive.dart';
import 'package:aplicacion_manga_admin_panel/screens/dashboard_screen_usuario.dart';
import 'package:aplicacion_manga_admin_panel/screens/main_screen_usuarios.dart';
import 'package:aplicacion_manga_admin_panel/services/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:aplicacion_manga_admin_panel/providers/dark_theme_provider.dart';
import 'package:aplicacion_manga_admin_panel/screens/loading_manager.dart';
import 'package:aplicacion_manga_admin_panel/screens/main_screen_admin.dart';
import 'package:aplicacion_manga_admin_panel/widgets/textos_widget.dart';

final images = [
  "https://static1.cbrimages.com/wordpress/wp-content/uploads/2020/04/perfected-super-saiyan-blue-vegeta.jpg",
  "https://e.rpp-noticias.io/xlarge/2019/04/22/463246_780848.jpg",
  "https://static1.cbrimages.com/wordpress/wp-content/uploads/2023/06/beast-gohan-on-dragon-ball-super.jpg",
  "https://pbs.twimg.com/media/D8ouFw6XkAIte5i?format=jpg&name=large",
  "https://e.rpp-noticias.io/xlarge/2018/11/22/484448_715070.jpg",
];

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isDarkMode = false;
  late DarkThemeProvider themeState;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initTheme();
  }

  void _initTheme() async {
    await Future.delayed(Duration.zero);
    themeState = Provider.of<DarkThemeProvider>(context, listen: false);
    setState(() {
      isDarkMode = themeState.getDarkTheme;
    });
  }

  Future<void> signInWithEmailAndPassword() async {
    setState(() {
      isLoading = true;
    });

    try {
      final String email = emailController.text.trim();
      final String password = passwordController.text.trim();

      UserCredential authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = authResult.user;

      if (user != null) {
        // Consultar Firestore para obtener información adicional del usuario
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
            .instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          // Verificar el campo isAdmin antes de redirigir
          bool isAdmin = userDoc.data()!['isAdmin'] ?? false;

          if (isAdmin) {
            print('Inicio de sesión exitoso: ${user.displayName}');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreenAdmin(
                  isAuthenticated: true,
                ),
              ),
            );
          } else {
            print(
                'Inicio de sesión exitoso, pero el usuario no es un administrador.');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DashBoardScreenUsuario(),
              ),
            );
          }
        }
      }
    } catch (e) {
      // Manejar errores de inicio de sesión con correo y contraseña aquí
      print('Error al iniciar sesión: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /*Future<void> signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User? user = authResult.user;

        if (user != null) {
          // Verifica si el usuario ya existe en Firestore
          DocumentSnapshot<Map<String, dynamic>> userDoc =
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get();

          if (userDoc.exists) {
            // Usuario ya existe, redirige al MainScreenUsuario
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DashBoardScreenUsuario(),
              ),
            );
          } else {
            // Usuario no existe, agrégalo a la colección 'users'
            final List<String> nameParts = user.displayName!.split(" ");
            final String firstName =
                nameParts.isNotEmpty ? nameParts.first : "";
            final String lastName = nameParts.length > 1 ? nameParts.last : "";

            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set({
              'userId': user.uid,
              'email': user.email,
              'usuario': user.displayName,
              'nombres': firstName,
              'apellidos': lastName,
              'fecha_registro': DateTime.now(),
              'isAdmin': false,
            });

            print('Inicio de sesión con Google exitoso: ${user.displayName}');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DashBoardScreenUsuario(),
              ),
            );
          }
        }
      }
    } catch (e) {
      // Manejar errores de inicio de sesión con Google aquí
      print('Error al iniciar sesión con Google: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }*/

  Future<void> signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User? user = authResult.user;

        if (user != null) {
          // Verifica si el usuario ya existe en Firestore
          DocumentSnapshot<Map<String, dynamic>> userDoc =
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get();

          if (userDoc.exists) {
            // Usuario ya existe, redirige al MainScreenUsuario
            print('Usuario ya existe en Firestore');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DashBoardScreenUsuario(),
              ),
            );
          } else {
            // Usuario no existe, agrégalo a la colección 'users'
            final List<String> nameParts = user.displayName!.split(" ");
            final String firstName =
                nameParts.isNotEmpty ? nameParts.first : "";
            final String lastName = nameParts.length > 1 ? nameParts.last : "";

            // Recupera el correo electrónico directamente del proveedor de Google
            final GoogleSignInAccount? googleSignInAccount =
                await googleSignIn.signInSilently();
            final String userEmail = googleSignInAccount?.email ?? '';

            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set({
              'userId': user.uid,
              'correo': userEmail,
              'usuario': user.displayName,
              'nombres': firstName,
              'apellidos': lastName,
              'fecha_registro': DateTime.now(),
              'isAdmin': false,
            });

            print('Inicio de sesión con Google exitoso: ${user.displayName}');
            print('Correo almacenado en Firestore: $userEmail');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DashBoardScreenUsuario(),
              ),
            );
          }
        }
      }
    } catch (e) {
      // Manejar errores de inicio de sesión con Google aquí
      print('Error al iniciar sesión con Google: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final bool isDarkMode = themeState.getDarkTheme;
    final Color color = isDarkMode ? Colors.white : Colors.black;

    return Responsive(
      mobile: _buildMobileLoginScreen(color, themeState),
      desktop: _buildDesktopLoginScreen(color, themeState),
    );
  }

  Widget _buildMobileLoginScreen(Color color, DarkThemeProvider themeState) {
    final theme = Utils(context).getTheme;
    return Scaffold(
      body: LoadingManager(
        isLoading: isLoading,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CarouselSlider.builder(
                options: CarouselOptions(
                  height: 180,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  autoPlayInterval: const Duration(seconds: 2),
                ),
                itemCount: images.length,
                itemBuilder: (context, index, realIndex) {
                  final urlImage = images[index];
                  return buildImage(urlImage, index);
                },
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: TextosWidget(
                  text: 'LATIN MANGA',
                  color: color,
                  textSize: 32,
                  isTitle: true,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: isLoading ? null : signInWithEmailAndPassword,
                child: Text('Ingresar'),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'O ingresa con',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: isLoading ? null : signInWithGoogle,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/google_icon.png',
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(width: 12),
                    Text('Iniciar sesión con Google'),
                  ],
                ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLoginScreen(Color color, DarkThemeProvider themeState) {
    final theme = Utils(context).getTheme;
    return Scaffold(
      body: LoadingManager(
        isLoading: isLoading,
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CarouselSlider.builder(
                      options: CarouselOptions(
                        height: 180,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        autoPlayInterval: Duration(seconds: 2),
                      ),
                      itemCount: images.length,
                      itemBuilder: (context, index, realIndex) {
                        final urlImage = images[index];
                        return buildImage(urlImage, index);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: TextosWidget(
                        text: 'LATIN MANGA',
                        color: color,
                        textSize: 32,
                        isTitle: true,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: isLoading ? null : signInWithEmailAndPassword,
                      child: Text('Ingresar'),
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'O ingresa con',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: isLoading ? null : signInWithGoogle,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/google_icon.png',
                            width: 24,
                            height: 24,
                          ),
                          SizedBox(width: 12),
                          Text('Iniciar sesión con Google'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImage(String urlImage, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(urlImage),
        ),
      ),
    );
  }
}
