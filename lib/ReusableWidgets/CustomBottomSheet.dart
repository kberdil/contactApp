import 'package:contactsapp/Constants/ColorConstants.dart';
import 'package:contactsapp/Constants/TextAndImageConstants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomSheet extends StatelessWidget {
  final String message;

  const CustomBottomSheet({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.black,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Image.asset(TextAndImageConstants.imageCheck),
            const SizedBox(width: 15),
            Text(
              message,
              style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: ColorConstants.green),
            ),
          ],
        ),
      ),
    );
  }
}
