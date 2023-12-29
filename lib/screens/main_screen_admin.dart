import 'package:flutter/material.dart';
import 'package:aplicacion_manga_admin_panel/inner_screens/LoginScreen.dart';
import 'package:aplicacion_manga_admin_panel/responsive.dart';
import 'package:aplicacion_manga_admin_panel/screens/dashboard_screen_admin.dart';
import 'package:aplicacion_manga_admin_panel/widgets/side_menu.dart';

class MainScreenAdmin extends StatelessWidget {
  final bool isAuthenticated;

  MainScreenAdmin({Key? key, required this.isAuthenticated}) : super(key: key) {
    print('MainScreen constructor - isAuthenticated: $isAuthenticated');
  }

  @override
  Widget build(BuildContext context) {
    print('MainScreen build - isAuthenticated: $isAuthenticated');
    return Responsive(
      mobile: Scaffold(
        //drawer: const SideMenu(),
        body: SafeArea(
          child: isAuthenticated ? DashboarScreenAdmin() : LoginScreen(),
        ),
      ),
      desktop: Scaffold(
        drawer: const SideMenu(),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*Expanded(
                child: SideMenu(),
              ),*/
              Expanded(
                flex: 5,
                child: isAuthenticated ? DashboarScreenAdmin() : LoginScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
