import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constants/ColorConstants.dart';

class ProfileInfoField extends StatelessWidget {
  ProfileInfoField({super.key, required this.text});
  String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(color: Colors.transparent),
      child: Text(text,
          textAlign: TextAlign.left,
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ColorConstants.black,
          )),
    );
  }
}
