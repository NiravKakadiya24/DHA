import 'package:flutter/material.dart';
import 'package:jamii_check/global/globals.dart';

class CustomPasswordTextField extends StatefulWidget {
  final bool? readOnly;
  final TextEditingController? controller;
  final String? hintTxt;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final TextInputAction? textInputAction;
  final Widget? suffix;

  const CustomPasswordTextField(
      {this.controller,
      this.hintTxt,
      this.focusNode,
      this.nextNode,
      this.textInputAction,this.readOnly,this.suffix});

  @override
  _CustomPasswordTextFieldState createState() =>
      _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  bool _obscureText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      /* decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 7, offset: Offset(0, 1)) // changes position of shadow
        ],
      ), */
      child: TextFormField(
        cursorColor: JAMII_PRIMARY_COLOR,
        controller: widget.controller,
        readOnly: widget.readOnly!?widget.readOnly!:false,
        obscureText: _obscureText,
        focusNode: widget.focusNode,
        textInputAction: widget.textInputAction ?? TextInputAction.next,
        onFieldSubmitted: (v) {
          setState(() {
            widget.textInputAction == TextInputAction.done
                ? FocusScope.of(context).consumeKeyboardToken()
                : FocusScope.of(context).requestFocus(widget.nextNode);
          });
        },
        validator: (value) {
          return null;
        },
        decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.lock,
              color: Colors.grey,
            ),
            suffixIcon:widget.suffix !=null ?widget.suffix: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: JAMII_PRIMARY_COLOR,
                ),
                onPressed: _toggle),
            hintText: widget.hintTxt ?? '',
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: JAMII_PRIMARY_COLOR)),
            border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey))
            //focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: JAMII_PRIMARY_COLOR)),
            //hintStyle: titilliumRegular.copyWith(color: Theme.of(context).hintColor),
            ),
      ),
    );
  }
}
