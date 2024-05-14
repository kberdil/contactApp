import 'package:contactsapp/ColorConstants.dart';
import 'package:flutter/material.dart';

import 'Contact.dart';
import 'RoundedTextField.dart';

class ProfileSheet extends StatefulWidget {
  Contact? contact;
  ProfileSheet({super.key});

  @override
  State<ProfileSheet> createState() => _ProfileSheetState();
}

class _ProfileSheetState extends State<ProfileSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 16),
                  foregroundColor: ColorConstants.blue),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            if (widget.contact == null)
              Text(
                "New Contact",
                style: TextStyle(fontSize: 16),
              ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 16),
              ),
              onPressed: () {
                // TODO: save contact
              },
              child: const Text('Done'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        CircleAvatar(
            radius: 97, // Image radius
            backgroundImage: NetworkImage('https://via.placeholder.com/150')),
        const SizedBox(height: 10),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 16),
          ),
          onPressed: () {
            print("add photo pressed");
          },
          child: const Text('Add photo'),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            RoundedTextField(hintText: 'First name'),
            SizedBox(height: 10),
            RoundedTextField(hintText: 'Last name'),
            SizedBox(height: 10),
            RoundedTextField(hintText: 'Phone number', numericOnly: true),
          ]),
        ),
      ],
    )));
  }
}
