import 'package:contactsapp/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoundedTextField extends StatefulWidget {
  final String hintText;
  final bool numericOnly;
  const RoundedTextField(
      {Key? key, required this.hintText, this.numericOnly = false})
      : super(key: key);

  @override
  _RoundedTextFieldState createState() => _RoundedTextFieldState();
}

class _RoundedTextFieldState extends State<RoundedTextField> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 43,
      child: TextField(
        controller: _controller,
        textAlignVertical: TextAlignVertical.bottom,
        autocorrect: false,
        inputFormatters: widget.numericOnly
            ? [FilteringTextInputFormatter.digitsOnly]
            : null,
        keyboardType: widget.numericOnly ? TextInputType.phone : null,
        decoration: InputDecoration(
          hintText: widget.hintText,
          filled: true,
          fillColor: ColorConstants.pageColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
