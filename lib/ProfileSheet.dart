import 'dart:io';

import 'package:contactsapp/Constants/ColorConstants.dart';
import 'package:contactsapp/Constants/TextAndImageConstants.dart';
import 'package:contactsapp/EditSheet.dart';
import 'package:contactsapp/Service/APIService.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'Models/Contact.dart';
import 'Models/Operation.dart';
import 'ReusableWidgets/CameraPickerBottomSheet.dart';
import 'ReusableWidgets/CustomBottomSheet.dart';
import 'ReusableWidgets/ProfileInfoField.dart';
import 'ReusableWidgets/RoundedTextField.dart';
import 'ReusableWidgets/YesNoQuestion.dart';

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
  final TextEditingController _controllerEditFirstName =
      TextEditingController();
  final TextEditingController _controllerEditLastName = TextEditingController();
  final TextEditingController _controllerEditPhoneNumber =
      TextEditingController();
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

    _controllerEditFirstName.addListener(_updateButtonState);
    _controllerEditLastName.addListener(_updateButtonState);
    _controllerEditPhoneNumber.addListener(_updateButtonState);

    _controllerEditFirstName.text = widget.contact?.firstName ?? '';
    _controllerEditLastName.text = widget.contact?.lastName ?? '';
    _controllerEditPhoneNumber.text = widget.contact?.phoneNumber ?? '';
  }

  @override
  void dispose() {
    _controllerFirstName.removeListener(_updateButtonState);
    _controllerLastName.removeListener(_updateButtonState);
    _controllerPhoneNumber.removeListener(_updateButtonState);

    _controllerEditFirstName.removeListener(_updateButtonState);
    _controllerEditLastName.removeListener(_updateButtonState);
    _controllerEditPhoneNumber.removeListener(_updateButtonState);

    _controllerFirstName.dispose();
    _controllerLastName.dispose();
    _controllerPhoneNumber.dispose();

    _controllerEditFirstName.dispose();
    _controllerEditLastName.dispose();
    _controllerEditPhoneNumber.dispose();
    _isButtonEnabled.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    if (widget.profileSheetType == ProfileSheetType.editing) {
      var isEnabled =
          !(_controllerEditFirstName.text == widget.contact?.firstName &&
              _controllerEditLastName.text == widget.contact?.lastName &&
              _controllerEditPhoneNumber.text == widget.contact?.phoneNumber);
      _isButtonEnabled.value = isEnabled;
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

  void updateAfterEdit(Contact contact) {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        // update data here
        if (operationType != OperationType.added) {
          operationType = OperationType.edited;
        }
        widget.profileSheetType = ProfileSheetType.info;
        widget.contact = contact;

        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (BuildContext context) {
            return const CustomBottomSheet(
                message: TextAndImageConstants.accountEditedMessage);
          },
        );
      });
    });
  }

  void showEditSheet(Contact contact) async {
    final result = await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
                child: Container(
                    child: EditSheet(
                  contact: contact,
                )),
              ),
            )
          ],
        );
      },
    );
    if (result != null) {
      updateAfterEdit(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
      children: [
        const SizedBox(height: 10),
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
              child: const Text(TextAndImageConstants.cancel),
            ),
            if (widget.profileSheetType == ProfileSheetType.adding ||
                operationType == OperationType.added) ...[
              Text(
                TextAndImageConstants.newContact,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.black,
                ),
              ),
            ] else ...[
              const SizedBox(width: 20),
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
                              FocusScope.of(context).requestFocus(FocusNode());
                              APIService()
                                  .createUser(await getNewContactInfo())
                                  .then((value) => {
                                        Future.delayed(
                                            const Duration(milliseconds: 500),
                                            () {
                                          setState(() {
                                            if (value != null) {
                                              widget.profileSheetType =
                                                  ProfileSheetType.info;
                                              widget.contact = value;
                                              operationType =
                                                  OperationType.added;
                                              showModalBottomSheet(
                                                backgroundColor:
                                                    Colors.transparent,
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return const CustomBottomSheet(
                                                      message: TextAndImageConstants
                                                          .accountAddedMessage);
                                                },
                                              );
                                            }
                                          });
                                        })
                                      });
                            }
                          }
                        : null,
                    style: TextButton.styleFrom(
                      textStyle: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.blue,
                      ),
                      foregroundColor:
                          isEnabled ? ColorConstants.blue : ColorConstants.grey,
                    ),
                    child: const Text(TextAndImageConstants.done),
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
                  // --------------------------------------------------------------------------------------
                  // I changed this part because of the problem I mentioned in the readme file.
                  // If the line below is commented out and the code block in the comment is uncommented,
                  // the problem I mentioned will occur.
                  // --------------------------------------------------------------------------------------
                  showEditSheet(widget.contact!);
                  /*setState(() {
                    widget.profileSheetType = ProfileSheetType.editing;
                  });*/
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
                        : const AssetImage(TextAndImageConstants.imageProfile)
                            as ImageProvider,
                backgroundColor: Colors.transparent,
              ),
        const SizedBox(height: 10),
        if (widget.profileSheetType != ProfileSheetType.info) ...[
          TextButton(
            onPressed: () {
              _showPicker(context);
            },
            child: Text(
              (_image != null ||
                      (widget.contact?.profileImageUrl ?? '').isNotEmpty)
                  ? TextAndImageConstants.changePhoto
                  : TextAndImageConstants.addPhoto,
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ColorConstants.black,
              ),
            ),
          ),
        ],
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // new contact page
              if (widget.profileSheetType == ProfileSheetType.adding) ...[
                RoundedTextField(
                  hintText: TextAndImageConstants.firstNameInputPlaceholder,
                  controller: _controllerFirstName,
                ),
                const SizedBox(height: 10),
                RoundedTextField(
                  hintText: TextAndImageConstants.lastNameInputPlaceholder,
                  controller: _controllerLastName,
                ),
                const SizedBox(height: 10),
                RoundedTextField(
                    hintText: TextAndImageConstants.phoneNumberInputPlaceholder,
                    controller: _controllerPhoneNumber,
                    numericOnly: true),
              ] // editing page
              else if (widget.profileSheetType == ProfileSheetType.editing) ...[
                RoundedTextField(
                  hintText: TextAndImageConstants.firstNameInputPlaceholder,
                  controller: _controllerEditFirstName,
                ),
                const SizedBox(height: 10),
                RoundedTextField(
                  hintText: TextAndImageConstants.lastNameInputPlaceholder,
                  controller: _controllerEditFirstName,
                ),
                const SizedBox(height: 10),
                RoundedTextField(
                    hintText: TextAndImageConstants.phoneNumberInputPlaceholder,
                    controller: _controllerEditPhoneNumber,
                    numericOnly: true),
              ] // info page
              else ...[
                ProfileInfoField(text: widget.contact?.firstName ?? ''),
                const Divider(thickness: 1, color: ColorConstants.grey),
                ProfileInfoField(text: widget.contact?.lastName ?? ''),
                const Divider(thickness: 1, color: ColorConstants.grey),
                ProfileInfoField(text: widget.contact?.phoneNumber ?? ''),
                const Divider(thickness: 1, color: ColorConstants.grey),
                Container(
                  alignment: Alignment.topLeft,
                  decoration: const BoxDecoration(color: Colors.transparent),
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
                          title: TextAndImageConstants
                              .deleteAccountBottomSheetTitle,
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
                    child: Text(TextAndImageConstants.deleteContact,
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
