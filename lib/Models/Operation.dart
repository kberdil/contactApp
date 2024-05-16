import 'Contact.dart';

enum OperationType { added, edited, deleted }

class Operation {
  final Contact contact;
  final OperationType type;
  Operation(this.contact, this.type);
}
