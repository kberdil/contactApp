import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constants/ColorConstants.dart';
import '../Constants/TextAndImageConstants.dart';

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
            TextAndImageConstants.imageNoContact,
          ),
          const SizedBox(height: 15),
          Text(TextAndImageConstants.emptyListTitle,
              style: GoogleFonts.nunito(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.black)),
          const SizedBox(height: 15),
          Text(TextAndImageConstants.emptyListDescription,
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
            child: const Text(TextAndImageConstants.emptyListButton),
          ),
        ],
      ),
    );
  }
}
