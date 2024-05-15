import 'package:contactsapp/Constants/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class YesNoDialog extends StatelessWidget {
  final String title;
  final VoidCallback onYesButtonPressed;

  YesNoDialog({
    super.key,
    required this.title,
    required this.onYesButtonPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      height: 241.0,
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.nunito(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ColorConstants.red,
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 54.0,
                  decoration: BoxDecoration(
                      color: ColorConstants.pageColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: ColorConstants.black,
                          offset: Offset(0.5, 0.5),
                          blurRadius: 1.0,
                        ),
                      ]),
                  child: TextButton(
                    onPressed: onYesButtonPressed,
                    child: Text(
                      'Yes',
                      style: GoogleFonts.nunito(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  width: double.infinity,
                  height: 54.0,
                  decoration: BoxDecoration(
                    color: ColorConstants.pageColor,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: const [
                      BoxShadow(
                        color: ColorConstants.black,
                        offset: Offset(0.5, 0.5),
                        blurRadius: 1.0,
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'No',
                      style: GoogleFonts.nunito(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
