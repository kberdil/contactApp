import 'dart:async';

import 'package:contactsapp/Service/APIService.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Constants/ColorConstants.dart';
import 'Models/Contact.dart';
import 'ProfileSheet.dart';
import 'ReusableWidgets/ContactListTile.dart';
import 'ReusableWidgets/CustomBottomSheet.dart';
import 'ReusableWidgets/EmptyPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Contact>>? contactList;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    setState(() {
      contactList = APIService().getUserList();
    });
  }

  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void update(Operation operation) {
    setState(() {
      // update data here
      switch (operation.type) {
        case OperationType.added:
          contactList = addContact(operation.contact);
          break;
        case OperationType.edited:
          contactList = updateContactById(contactList!, operation.contact);
          break;
        case OperationType.deleted:
          if (contactList != null) {
            contactList =
                removeContactById(contactList!, operation.contact.id!);
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (BuildContext context) {
                return const CustomBottomSheet(message: 'Account deleted!');
              },
            );
          }
          break;
      }
    });
  }

  Future<List<Contact>> removeContactById(
      Future<List<Contact>> futureContacts, String id) async {
    return futureContacts.then((List<Contact> contacts) {
      contacts.removeWhere((contact) => contact.id == id);
      return contacts;
    });
  }

  Future<List<Contact>> addContact(Contact newContact) async {
    List<Contact> currentContacts = await contactList!;
    currentContacts.add(newContact);
    return currentContacts;
  }

  Future<List<Contact>> updateContactById(
      Future<List<Contact>> futureContacts, Contact updatedContact) async {
    return futureContacts.then((List<Contact> contacts) {
      int index =
          contacts.indexWhere((contact) => contact.id == updatedContact.id);
      if (index != -1) {
        contacts[index] = updatedContact;
      }
      return contacts;
    });
  }

  void showProfileSheet(ProfileSheetType type, [Contact? contact]) async {
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
                  child: ProfileSheet(
                    contact: contact,
                    profileSheetType: type,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
    if (result != null) {
      update(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.pageColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, top: 24, right: 24),
          child: Column(
            children: [
              Row(
                children: [
                  Text("Contacts",
                      style: GoogleFonts.nunito(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.black)),
                  Expanded(flex: 1, child: Container()),
                  IconButton(
                    icon: Image.asset('assets/images/add.png'),
                    color: Colors.blue,
                    onPressed: () {
                      showProfileSheet(ProfileSheetType.adding);
                    },
                  )
                ],
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: ColorConstants.white,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 10.0),
                    const Icon(
                      Icons.search,
                      color: ColorConstants.grey,
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search by name',
                            hintStyle: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: ColorConstants.grey)),
                        onChanged: (str) {
                          if (_debounce?.isActive ?? false) _debounce?.cancel();
                          _debounce =
                              Timer(const Duration(milliseconds: 500), () {
                            setState(() {
                              contactList = APIService().getUserList(term: str);
                            });
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              FutureBuilder<List<Contact>>(
                future: contactList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    print('Error: ${snapshot.error}');
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData && snapshot.data!.length > 0) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height *
                                0.8, // Adjust the height as needed
                            child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                Contact contact = snapshot.data![index];
                                return ContactListTile(
                                  contact: contact,
                                  onTap: (Contact contact) {
                                    showProfileSheet(
                                        ProfileSheetType.info, contact);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return EmptyPage();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
