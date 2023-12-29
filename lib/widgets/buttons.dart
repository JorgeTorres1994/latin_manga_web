/*import 'package:flutter/material.dart';
import 'package:aplicacion_manga_admin_panel/consts/constants.dart';

import '../responsive.dart';

class ButtonsWidget extends StatelessWidget {
  const ButtonsWidget({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.icon,
    required this.backgroundColor,
    this.textStyle, // Nuevo parámetro para el estilo del texto
  }) : super(key: key);

  final VoidCallback onPressed;
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final TextStyle? textStyle; // Nuevo parámetro para el estilo del texto

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(
          horizontal: defaultPadding * 1.5,
          vertical: defaultPadding / (Responsive.isDesktop(context) ? 1 : 2),
        ),
      ),
      onPressed: () {
        onPressed();
      },
      icon: Icon(
        icon,
        size: 20,
      ),
      label: Text(
        text,
        style: textStyle, // Utiliza el nuevo parámetro para el estilo del texto
      ),
    );
  }
}

*/

import 'package:flutter/material.dart';
import 'package:aplicacion_manga_admin_panel/consts/constants.dart';

import '../responsive.dart';

class ButtonsWidget extends StatelessWidget {
  const ButtonsWidget({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.icon,
    required this.backgroundColor,
    this.textStyle, // Nuevo parámetro para el estilo del texto
    this.textColor, // Nuevo parámetro para el color del texto
  }) : super(key: key);

  final VoidCallback onPressed;
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final TextStyle? textStyle; // Nuevo parámetro para el estilo del texto
  final Color? textColor; // Nuevo parámetro para el color del texto

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(
          horizontal: defaultPadding * 1.5,
          vertical: defaultPadding / (Responsive.isDesktop(context) ? 1 : 2),
        ),
      ),
      onPressed: () {
        onPressed();
      },
      icon: Icon(
        icon,
        size: 20,
      ),
      label: Text(
        text,
        style:
            textStyle?.copyWith(color: textColor), // Aplica el color del texto
      ),
    );
  }
}
