import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constants/ColorConstants.dart';

class EmptyPage extends StatelessWidget {
  final VoidCallback onButtonPressed;

  const EmptyPage({super.key, required this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/nocontact.png',
          ),
          const SizedBox(height: 15),
          Text("No Contacts",
              style: GoogleFonts.nunito(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.black)),
          const SizedBox(height: 15),
          Text("Contacts you’ve added will appear here.",
              style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.black)),
          TextButton(
            style: TextButton.styleFrom(
                textStyle: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.blue)),
            onPressed: onButtonPressed,
            child: const Text('Create new contact'),
          ),
        ],
      ),
    );
  }
}
