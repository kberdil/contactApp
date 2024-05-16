import 'dart:io';

import 'package:contactsapp/Constants/TextAndImageConstants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'Constants/ColorConstants.dart';
import 'Models/Contact.dart';
import 'ReusableWidgets/CameraPickerBottomSheet.dart';
import 'ReusableWidgets/RoundedTextField.dart';
import 'Service/APIService.dart';

class EditSheet extends StatefulWidget {
  Contact contact;

  EditSheet({super.key, required this.contact});

  @override
  State<EditSheet> createState() => _EditSheetState();
}

class _EditSheetState extends State<EditSheet> {
  final TextEditingController _controllerFirstName = TextEditingController();
  final TextEditingController _controllerLastName = TextEditingController();
  final TextEditingController _controllerPhoneNumber = TextEditingController();
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier<bool>(false);
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controllerFirstName.text = widget.contact.firstName ?? '';
    _controllerLastName.text = widget.contact.lastName ?? '';
    _controllerPhoneNumber.text = widget.contact.phoneNumber ?? '';
    _controllerFirstName.addListener(_updateButtonState);
    _controllerLastName.addListener(_updateButtonState);
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
    var isEnabled = !(_controllerFirstName.text == widget.contact.firstName &&
        _controllerLastName.text == widget.contact.lastName &&
        _controllerPhoneNumber.text == widget.contact.phoneNumber &&
        _image == null);
    _isButtonEnabled.value = isEnabled;
  }

  Future<Contact> getEditedContactInfo() async {
    var newContact = Contact(
      firstName: _controllerFirstName.text,
      lastName: _controllerLastName.text,
      phoneNumber: _controllerPhoneNumber.text,
      profileImageUrl: widget.contact.profileImageUrl,
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
        _updateButtonState();
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
                Navigator.pop(context);
              },
              child: const Text(TextAndImageConstants.cancel),
            ),
            const SizedBox(width: 20),
            ValueListenableBuilder<bool>(
              valueListenable: _isButtonEnabled,
              builder: (context, isEnabled, child) {
                return TextButton(
                  onPressed: isEnabled
                      ? () async {
                          Contact updatedContact = await getEditedContactInfo();
                          APIService()
                              .updateUserById(
                                  widget.contact.id!, updatedContact)
                              .then((value) {
                            if (value != null) {
                              Navigator.pop(context, value);
                            }
                          });
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
                    (widget.contact.profileImageUrl ?? '').isNotEmpty
                        ? NetworkImage(widget.contact.profileImageUrl!)
                        : const AssetImage(TextAndImageConstants.imageProfile)
                            as ImageProvider,
                backgroundColor: Colors.transparent,
              ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            _showPicker(context);
          },
          child: Text(
            (_image != null ||
                    (widget.contact.profileImageUrl ?? '').isNotEmpty)
                ? TextAndImageConstants.changePhoto
                : TextAndImageConstants.addPhoto,
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorConstants.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
            ],
          ),
        ),
      ],
    ))));
  }
}
