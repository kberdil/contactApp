import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constants/ColorConstants.dart';

class CameraPickerBottomSheet extends StatelessWidget {
  final Function() onCameraPressed;
  final Function() onGalleryPressed;

  const CameraPickerBottomSheet({
    Key? key,
    required this.onCameraPressed,
    required this.onGalleryPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      height: 250,
      child: Column(
        children: [
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
                      onPressed: onCameraPressed,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/camera.png'),
                          SizedBox(width: 10),
                          Text(
                            'Camera',
                            style: GoogleFonts.nunito(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: ColorConstants.black,
                            ),
                          ),
                        ],
                      )),
                ),
                SizedBox(height: 10.0),
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
                      onPressed: onGalleryPressed,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/gallery.png'),
                          SizedBox(width: 10),
                          Text(
                            'Gallery',
                            style: GoogleFonts.nunito(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: ColorConstants.black,
                            ),
                          ),
                        ],
                      )),
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
                      'Cancel',
                      style: GoogleFonts.nunito(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.blue,
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
