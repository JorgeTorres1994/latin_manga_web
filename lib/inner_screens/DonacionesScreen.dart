/*import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Donaciones App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DonacionesScreen(),
    );
  }
}

class DonacionesScreen extends StatefulWidget {
  @override
  _DonacionesScreenState createState() => _DonacionesScreenState();
}

class _DonacionesScreenState extends State<DonacionesScreen> {
  String selectedOption = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('¡Ayúdanos a crecer!'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Selecciona una opción de donación',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            DonationOption(
              label: 'Tarjeta de Crédito',
              icon: Icons.credit_card,
              isSelected: selectedOption == 'Tarjeta de Crédito',
              onTap: () {
                selectOption('Tarjeta de Crédito');
                showCreditCardMessage(context);
              },
            ),
            DonationOption(
              label: 'PayPal',
              icon: Icons.account_circle,
              isSelected: selectedOption == 'PayPal',
              onTap: () {
                selectOption('PayPal');
                launch(
                    'https://paypal.me/JTorresPastor?country.x=PE&locale.x=es_XC');
              },
            ),
            DonationOption(
              label: 'Mercado Pago',
              icon: Icons.attach_money,
              isSelected: selectedOption == 'Mercado Pago',
              onTap: () {
                selectOption('Mercado Pago');
                launch('https://mpago.la/2sgeRUt');
              },
            ),
            SizedBox(height: 20.0),
            Text(
              '¡Gracias por tu apoyo!',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void selectOption(String option) {
    setState(() {
      selectedOption = option;
    });
    print('Seleccionaste $option');
  }

  void showCreditCardMessage(BuildContext context) {
    final fakeCreditCardNumber = '**** **** **** 1234';
    final fakeBankAccount = 'Cuenta Bancaria: 1234-5678-9012-3456';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Número de Tarjeta para Donar: $fakeCreditCardNumber'),
            SizedBox(height: 8.0),
            Text(fakeBankAccount),
          ],
        ),
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Cerrar',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}

class DonationOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  DonationOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: isSelected ? 8.0 : 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: isSelected ? Colors.blue[100] : null,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 50.0,
                color: isSelected ? Colors.blue : null,
              ),
              SizedBox(height: 10.0),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.blue : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DonacionesScreen extends StatefulWidget {
  @override
  _DonacionesScreenState createState() => _DonacionesScreenState();
}

class _DonacionesScreenState extends State<DonacionesScreen> {
  String selectedOption = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('¡Ayúdanos a crecer!'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Selecciona una opción de donación',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            DonationOption(
              label: 'Tarjeta de Crédito',
              icon: Icons.credit_card,
              isSelected: selectedOption == 'Tarjeta de Crédito',
              onTap: () {
                selectOption('Tarjeta de Crédito');
                showCreditCardMessage(context);
              },
            ),
            DonationOption(
              label: 'PayPal',
              icon: Icons.account_circle,
              isSelected: selectedOption == 'PayPal',
              onTap: () {
                selectOption('PayPal');
                launch(
                    'https://paypal.me/JTorresPastor?country.x=PE&locale.x=es_XC');
              },
            ),
            DonationOption(
              label: 'Mercado Pago',
              icon: Icons.attach_money,
              isSelected: selectedOption == 'Mercado Pago',
              onTap: () {
                selectOption('Mercado Pago');
                launch('https://mpago.la/2sgeRUt');
              },
            ),
            SizedBox(height: 20.0),
            Text(
              '¡Gracias por tu apoyo!',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void selectOption(String option) {
    setState(() {
      selectedOption = option;
    });
    print('Seleccionaste $option');
  }

  void showCreditCardMessage(BuildContext context) {
    final fakeCreditCardNumber = '**** **** **** 1234';
    final fakeBankAccount = 'Cuenta Bancaria: 1234-5678-9012-3456';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Número de Tarjeta para Donar: $fakeCreditCardNumber'),
            SizedBox(height: 8.0),
            Text(fakeBankAccount),
          ],
        ),
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Cerrar',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}

class DonationOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  DonationOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: isSelected ? 8.0 : 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: isSelected ? Colors.blue[100] : null,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 50.0,
                color: isSelected ? Colors.blue : null,
              ),
              SizedBox(height: 10.0),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.blue : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
