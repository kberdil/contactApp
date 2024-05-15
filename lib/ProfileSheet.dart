import 'package:contactsapp/Constants/ColorConstants.dart';
import 'package:contactsapp/Service/APIService.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'CustomBottomSheet.dart';
import 'Models/Contact.dart';
import 'ProfileInfoField.dart';
import 'RoundedTextField.dart';
import 'YesNoQuestion.dart';

enum ProfileSheetType { adding, editing, info }
/*
class ProfileScreen extends StatefulWidget {
  final ProfileSheetType defaultProfileSheetType;
  final Contact? contact;

  const ProfileScreen(
      {Key? key,
      this.defaultProfileSheetType = ProfileSheetType.info,
      this.contact})
      : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileSheetType profileSheetType = ProfileSheetType.info;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfileSheet(
        profileSheetType: widget.defaultProfileSheetType,
        onProfileSheetTypeChanged: (newType) {
          setState(() {
            profileSheetType = newType;
          });
        },
        contact: widget.contact,
      ),
    );
  }
}
*/

class ProfileSheet extends StatefulWidget {
  Contact? contact;
  ProfileSheetType profileSheetType;
  //final Function(ProfileSheetType) onProfileSheetTypeChanged;
  //bool isEditing;

  ProfileSheet({super.key, this.contact, required this.profileSheetType});

  @override
  State<ProfileSheet> createState() => _ProfileSheetState();
}

class _ProfileSheetState extends State<ProfileSheet> {
  final TextEditingController _controllerFirstName = TextEditingController();
  final TextEditingController _controllerLastName = TextEditingController();
  final TextEditingController _controllerPhoneNumber = TextEditingController();
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _controllerFirstName.addListener(_updateButtonState);
    _controllerLastName.addListener(_updateButtonState);
    _controllerPhoneNumber.addListener(_updateButtonState);
    _controllerPhoneNumber.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _controllerFirstName.removeListener(_updateButtonState);
    _controllerLastName.removeListener(_updateButtonState);
    _controllerPhoneNumber.removeListener(_updateButtonState);

    _controllerFirstName.dispose();
    _controllerLastName.dispose();
    _controllerPhoneNumber.dispose();
    _isButtonEnabled.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    if (widget.profileSheetType == ProfileSheetType.editing) {
      /*var isEnabled =
          !(_controllerFirstName.text == widget.contact?.firstName &&
              _controllerLastName.text == widget.contact?.lastName &&
              _controllerPhoneNumber.text == widget.contact?.phoneNumber);
      _isButtonEnabled.value = isEnabled;*/
    } else if (widget.profileSheetType == ProfileSheetType.adding) {
      var isEnabled = _controllerFirstName.text.isNotEmpty &&
          _controllerLastName.text.isNotEmpty &&
          _controllerPhoneNumber.text.isNotEmpty;
      _isButtonEnabled.value = isEnabled;
    }
  }

  Contact getNewContactInfo() {
    return Contact(
      firstName: _controllerFirstName.text,
      lastName: _controllerLastName.text,
      phoneNumber: _controllerPhoneNumber.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.blue,
                ),
              ),
              onPressed: () {
                switch (widget.profileSheetType) {
                  case ProfileSheetType.adding:
                    Navigator.pop(context);
                    break;
                  case ProfileSheetType.editing:
                    //widget.onProfileSheetTypeChanged(ProfileSheetType.info);
                    setState(() {
                      widget.profileSheetType = ProfileSheetType.info;
                    });
                    break;
                  case ProfileSheetType.info:
                    Navigator.pop(context);
                    break;
                }
              },
              child: const Text('Cancel'),
            ),
            Text(
              "New Contact",
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ColorConstants.black,
              ),
            ),
            if (widget.profileSheetType == ProfileSheetType.adding) ...[
              ValueListenableBuilder<bool>(
                valueListenable: _isButtonEnabled,
                builder: (context, isEnabled, child) {
                  return TextButton(
                    onPressed: isEnabled
                        ? () {
                            if (false) {
                              print('eeeeeedited');
                            } else {
                              APIService()
                                  .createUser(getNewContactInfo())
                                  .then((value) => {
                                        setState(() {
                                          if (value != null) {
                                            widget.profileSheetType =
                                                ProfileSheetType.info;
                                            widget.contact = value;
                                            showModalBottomSheet(
                                              backgroundColor:
                                                  Colors.transparent,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return const CustomBottomSheet(
                                                    message: 'User added !');
                                              },
                                            );
                                          }
                                        })
                                      });
                            }
                          }
                        : null,
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 16),
                      foregroundColor:
                          isEnabled ? ColorConstants.blue : ColorConstants.grey,
                    ),
                    child: Text('Done'),
                  );
                },
              ),
            ] else if (widget.profileSheetType == ProfileSheetType.editing)
              ...[]
            else ...[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.blue,
                  ),
                ),
                onPressed: () {
                  //widget.onProfileSheetTypeChanged(ProfileSheetType.editing);
                  setState(() {
                    widget.profileSheetType = ProfileSheetType.editing;
                  });
                },
                child: const Text('Edit'),
              ),
            ]

            /*if (widget.contact == null ||
                (widget.contact != null && widget.isEditing)) ...[
              ValueListenableBuilder<bool>(
                valueListenable: _isButtonEnabled,
                builder: (context, isEnabled, child) {
                  return TextButton(
                    onPressed: isEnabled
                        ? () {
                            if (widget.isEditing) {
                              print('eeeeeedited');
                            } else {
                              APIService()
                                  .createUser(getNewContactInfo())
                                  .then((value) => {
                                        setState(() {
                                          if (value != null) {
                                            widget.contact = value;
                                            showModalBottomSheet(
                                              backgroundColor:
                                                  Colors.transparent,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return const CustomBottomSheet(
                                                    message: 'User added !');
                                              },
                                            );
                                          }
                                        })
                                      });
                            }
                          }
                        : null,
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 16),
                      foregroundColor:
                          isEnabled ? ColorConstants.blue : ColorConstants.grey,
                    ),
                    child: Text('Done'),
                  );
                },
              ),
            ] else
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.blue,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    widget.isEditing = true;
                  });
                },
                child: const Text('Edit'),
              ),*/
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
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (BuildContext context) {
                return const CustomBottomSheet(message: 'User added !');
              },
            );
          },
          child: const Text('Add photo'),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // new contact page

              if (widget.profileSheetType == ProfileSheetType.adding) ...[
                RoundedTextField(
                  hintText: 'First name',
                  controller: _controllerFirstName,
                ),
                SizedBox(height: 10),
                RoundedTextField(
                  hintText: 'Last name',
                  controller: _controllerLastName,
                ),
                SizedBox(height: 10),
                RoundedTextField(
                    hintText: 'Phone number',
                    controller: _controllerPhoneNumber,
                    numericOnly: true),
              ] else if (widget.profileSheetType ==
                  ProfileSheetType.editing) ...[
                TextField(
                  onTap: () {
                    print('____');
                  },
                )
              ] else ...[
                ProfileInfoField(text: widget.contact?.firstName ?? ""),
                const Divider(thickness: 1, color: ColorConstants.grey),
                ProfileInfoField(text: widget.contact?.lastName ?? ""),
                const Divider(thickness: 1, color: ColorConstants.grey),
                ProfileInfoField(text: widget.contact?.phoneNumber ?? ""),
                const Divider(thickness: 1, color: ColorConstants.grey),
                Container(
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25.0),
                          ),
                        ),
                        builder: (context) => YesNoDialog(
                          title: 'Delete Account?',
                          onYesButtonPressed: () {
                            var userId = widget.contact?.id;
                            if (userId != null) {
                              APIService()
                                  .deleteUserById(userId)
                                  .then((value) => {
                                        setState(() {
                                          if (value) {
                                            Navigator.pop(context);
                                            Navigator.pop(
                                                context,
                                                Operation(widget.contact!,
                                                    OperationType.deleted));
                                          }
                                        })
                                      });
                            }
                          },
                        ),
                      );
                    },
                    child: Text('Delete contact',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.red,
                        )),
                  ),
                )
              ]

              /*if (widget.contact == null) ...[
                RoundedTextField(
                  hintText: 'First name',
                  controller: _controllerFirstName,
                ),
                SizedBox(height: 10),
                RoundedTextField(
                  hintText: 'Last name',
                  controller: _controllerLastName,
                ),
                SizedBox(height: 10),
                RoundedTextField(
                    hintText: 'Phone number',
                    controller: _controllerPhoneNumber,
                    numericOnly: true),
              ] else if (widget.isEditing) ...[
                RoundedTextField(
                  hintText: 'Last name',
                  controller: _controllerLastName,
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
              ] else ...[
                ProfileInfoField(text: widget.contact?.firstName ?? ""),
                const Divider(thickness: 1, color: ColorConstants.grey),
                ProfileInfoField(text: widget.contact?.lastName ?? ""),
                const Divider(thickness: 1, color: ColorConstants.grey),
                ProfileInfoField(text: widget.contact?.phoneNumber ?? ""),
                const Divider(thickness: 1, color: ColorConstants.grey),
                Container(
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25.0),
                          ),
                        ),
                        builder: (context) => YesNoDialog(
                          title: 'Delete Account?',
                          onYesButtonPressed: () {
                            var userId = widget.contact?.id;
                            if (userId != null) {
                              APIService()
                                  .deleteUserById(userId)
                                  .then((value) => {
                                        setState(() {
                                          if (value) {
                                            Navigator.pop(context);
                                            Navigator.pop(
                                                context,
                                                Operation(widget.contact!,
                                                    OperationType.deleted));
                                          }
                                        })
                                      });
                            }
                          },
                        ),
                      );
                    },
                    child: Text('Delete contact',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.red,
                        )),
                  ),
                )
              ] */
            ],
          ),
        ),
      ],
    ))));
  }
}

class Operation {
  final Contact contact;
  final OperationType type;
  Operation(this.contact, this.type);
}

enum OperationType { added, edited, deleted }
