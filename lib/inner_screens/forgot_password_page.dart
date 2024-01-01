import 'package:aplicacion_manga_admin_panel/widgets/login_form.dart';
import 'package:aplicacion_manga_admin_panel/widgets/textos_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  void Dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                  '¡El link para resear tu contraseña fue enviado!, revisa tu correo'),
            );
          });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                '¡El correo no existe!, no se pudo restaurar la contraseña',
              ),
            );
          });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          //padding: kDefaultPadding,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  TextosWidget(
                    text: '¿PROBLEMAS PARA INGRESAR?',
                    color: Colors.redAccent,
                    textSize: 22,
                    isTitle: true,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextosWidget(
                    text:
                        'Ingresa tu correo electrónico para enviarte un enlace y resetear contraseña',
                    color: Colors.white,
                    textSize: 30,
                    isTitle: true,
                  ),
                  SizedBox(
                    height: 160,
                  ),
                  LogInForm(
                    controller: emailController,
                    hintText: 'Correo',
                    obscureText: false,
                  ),
                  SizedBox(
                    height: 120,
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(left: 20, bottom: 20),
                    child: MaterialButton(
                      child: Text(
                        'Enviar enlace',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20, // Tamaño de fuente del texto del botón
                        ),
                      ),
                      color: Colors.green,
                      height: 50, // Ajustar el tamaño del botón
                      onPressed: () {
                        passwordReset();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿Quieres retroceder?',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ]),
    );
  }
}
