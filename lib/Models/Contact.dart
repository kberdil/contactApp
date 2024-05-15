class Contact {
  String? id;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? profileImageUrl;

  Contact(
      {this.id,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.profileImageUrl});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      profileImageUrl: json['profileImageUrl'],
    );
  }
}
