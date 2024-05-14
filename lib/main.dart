import 'package:flutter/material.dart';

import 'HomePage.dart';

void main() async {
  runApp(const ContactsAppRoot());
}

class ContactsAppRoot extends StatelessWidget {
  const ContactsAppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Contacts App', theme: ThemeData(), home: HomePage());
  }
}
