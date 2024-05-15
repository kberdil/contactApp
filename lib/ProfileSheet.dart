import 'dart:io';

import 'package:contactsapp/Constants/ColorConstants.dart';
import 'package:contactsapp/Service/APIService.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'Models/Contact.dart';
import 'Reusable Widgets/CameraPickerBottomSheet.dart';
import 'Reusable Widgets/CustomBottomSheet.dart';
import 'Reusable Widgets/ProfileInfoField.dart';
import 'Reusable Widgets/RoundedTextField.dart';
import 'Reusable Widgets/YesNoQuestion.dart';

enum ProfileSheetType { adding, editing, info }

class ProfileSheet extends StatefulWidget {
  Contact? contact;
  ProfileSheetType profileSheetType;

  ProfileSheet({super.key, this.contact, required this.profileSheetType});

  @override
  State<ProfileSheet> createState() => _ProfileSheetState();
}

class _ProfileSheetState extends State<ProfileSheet> {
  final TextEditingController _controllerFirstName = TextEditingController();
  final TextEditingController _controllerLastName = TextEditingController();
  final TextEditingController _controllerPhoneNumber = TextEditingController();
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier<bool>(false);
  File? _image;
  final ImagePicker _picker = ImagePicker();
  OperationType? operationType;

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

  Future<Contact> getNewContactInfo() async {
    var newContact = Contact(
      firstName: _controllerFirstName.text,
      lastName: _controllerLastName.text,
      phoneNumber: _controllerPhoneNumber.text,
    );
    if (_image != null) {
      await APIService().uploadImage(_image!).then((value) => {
            if (value != null) {newContact.profileImageUrl = value}
          });
    }
    return newContact;
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext bc) {
        return CameraPickerBottomSheet(
          onCameraPressed: () {
            _pickImage(ImageSource.camera);
            Navigator.of(context).pop();
          },
          onGalleryPressed: () {
            _pickImage(ImageSource.gallery);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
      children: [
        SizedBox(height: 10),
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
                    if (operationType == null) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(
                          context, Operation(widget.contact!, operationType!));
                    }
                    break;
                }
              },
              child: const Text('Cancel'),
            ),
            if (widget.profileSheetType == ProfileSheetType.adding ||
                operationType == OperationType.added) ...[
              Text(
                "New Contact",
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.black,
                ),
              ),
            ] else ...[
              SizedBox(width: 20),
            ],
            if (widget.profileSheetType != ProfileSheetType.info) ...[
              ValueListenableBuilder<bool>(
                valueListenable: _isButtonEnabled,
                builder: (context, isEnabled, child) {
                  return TextButton(
                    onPressed: isEnabled
                        ? () async {
                            if (widget.profileSheetType ==
                                ProfileSheetType.editing) {
                            } else {
                              APIService()
                                  .createUser(await getNewContactInfo())
                                  .then((value) => {
                                        setState(() {
                                          if (value != null) {
                                            widget.profileSheetType =
                                                ProfileSheetType.info;
                                            widget.contact = value;
                                            operationType = OperationType.added;
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
            ] else ...[
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
          ],
        ),
        const SizedBox(height: 10),
        _image != null
            ? CircleAvatar(
                radius: 97,
                backgroundImage: FileImage(_image!),
              )
            : CircleAvatar(
                radius: 97,
                backgroundImage:
                    (widget.contact?.profileImageUrl ?? '').isNotEmpty
                        ? NetworkImage(widget.contact!.profileImageUrl!)
                        : const AssetImage('assets/images/profile.png')
                            as ImageProvider,
                backgroundColor: Colors.transparent,
              ),
        const SizedBox(height: 10),
        if (widget.profileSheetType != ProfileSheetType.info) ...[
          if (_image != null) ...[
            TextButton(
              onPressed: () {
                _showPicker(context);
              },
              child: Text(
                'Change photo',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.black,
                ),
              ),
            )
          ] else
            TextButton(
              onPressed: () {
                _showPicker(context);
              },
              child: Text(
                'Add photo',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.black,
                ),
              ),
            )
        ],
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
