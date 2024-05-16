import 'dart:convert';
import 'dart:io';

import 'package:contactsapp/Service/APIRouter.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

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

  Future<Contact> updateUserById(String id, Contact editingContact) async {
    var URI = ServiceConstants().getURI(Endpoints.updateUser, id: id);
    var response = await http.put(URI,
        body: jsonEncode({
          "firstName": editingContact.firstName,
          "lastName": editingContact.lastName,
          "phoneNumber": editingContact.phoneNumber,
          "profileImageUrl": editingContact.profileImageUrl,
        }),
        headers: ServiceConstants().headers);
    if (response.statusCode == 200) {
      return Contact.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<bool> deleteUserById(String id) async {
    var URI = ServiceConstants().getURI(Endpoints.deleteUser, id: id);
    var response = await http.delete(URI, headers: ServiceConstants().headers);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete user');
    }
  }

  Future<String> uploadImage(File image) async {
    if (!image.existsSync()) {
      throw Exception('Image not found');
    }
    String fileName = image.path.split('/').last;
    String fileExtension = fileName.split('.').last.toLowerCase();

    if (fileExtension != 'png' &&
        fileExtension != 'jpg' &&
        fileExtension != 'jpeg') {
      throw Exception('Invalid file type');
    }

    var URI = ServiceConstants().getURI(Endpoints.getImageUrl);
    var request = http.MultipartRequest('POST', URI)
      ..headers.addAll(ServiceConstants().headers)
      ..files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
        contentType:
            MediaType('image', fileExtension == '.png' ? 'png' : 'jpeg'),
      ));
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    // ParseData
    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      return responseBody['data']['imageUrl'];
    } else {
      throw Exception('Failed to upload image');
    }
  }
}
