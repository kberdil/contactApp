import 'dart:convert';

import 'package:contactsapp/Constants/ServiceConstants.dart';
import 'package:http/http.dart' as http;

import '../Models/Contact.dart';

class APIService {
  Future<Contact> createUser(Contact contact) async {
    var URI = ServiceConstants().getURI(Endpoints.createUser);
    var response = await http.post(URI,
        body: jsonEncode({
          "firstName": contact.firstName,
          "lastName": contact.lastName,
          "phoneNumber": contact.phoneNumber,
          "profileImageUrl": contact.profileImageUrl,
        }),
        headers: ServiceConstants().headers);

    // ParseData
    if (response.statusCode == 200) {
      return Contact.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<List<Contact>> getUserList({String term = ''}) async {
    var URI =
        ServiceConstants().getURI(Endpoints.getUsers, term: term, take: '100');
    var response = await http.get(URI, headers: ServiceConstants().headers);
    // ParseData
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> usersJson = data['data']['users'];
      List<Contact> contacts =
          usersJson.map((dynamic item) => Contact.fromJson(item)).toList();
      return contacts;
    } else {
      throw Exception('Failed to get users');
    }
  }

  void updateUserById(String id) {}
  Future<bool> deleteUserById(String id) async {
    var URI = ServiceConstants().getURI(Endpoints.deleteUser, id: id);
    var response = await http.delete(URI, headers: ServiceConstants().headers);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete user');
    }
  }

  String uploadImage() {
    return "Nope";
  }
}
