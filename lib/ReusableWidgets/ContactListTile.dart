import 'package:contactsapp/Constants/TextAndImageConstants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constants/ColorConstants.dart';
import '../Models/Contact.dart';

class ContactListTile extends StatelessWidget {
  final Contact contact;
  final void Function(Contact) onTap;

  const ContactListTile({
    Key? key,
    required this.contact,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
        child: GestureDetector(
          onTap: () => onTap(contact),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: ColorConstants.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: CircleAvatar(
                    radius: 17,
                    backgroundImage: (contact.profileImageUrl ?? '').isNotEmpty
                        ? NetworkImage(contact.profileImageUrl!)
                        : const AssetImage(TextAndImageConstants.imageContact)
                            as ImageProvider,
                    backgroundColor: Colors.transparent,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${contact.firstName} ${contact.lastName}',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.black,
                          )),
                      Text(contact.phoneNumber ?? '',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: ColorConstants.grey,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
