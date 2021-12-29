import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jamii_check/global/globals.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

class CustomEmailTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? textInputType;
  final int? maxLine;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final TextInputAction? textInputAction;
  final bool? isPhoneNumber;
  final bool? isValidator;
  final String? validatorMessage;
  final Color? fillColor;
  final TextCapitalization? capitalization;
  final bool? readOnly;
  final Widget? suffix;

  CustomEmailTextField(
      {this.controller,
      this.hintText,
      this.textInputType,
      this.maxLine,
      this.focusNode,
      this.nextNode,
      this.textInputAction,
      this.isPhoneNumber = false,
      this.isValidator=false,
      this.validatorMessage,
      this.readOnly=false,
      this.capitalization = TextCapitalization.none,
      this.fillColor,
      this.suffix});

  @override
  Widget build(context) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        controller: controller,
        maxLines: maxLine ?? 1,
        textCapitalization: capitalization!,
        maxLength: isPhoneNumber! ? 15 : null,
        focusNode: focusNode,
        keyboardType: textInputType ?? TextInputType.text,
        //keyboardType: TextInputType.number,
        initialValue: null,
        textInputAction: textInputAction ?? TextInputAction.next,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(nextNode);
        },
        //autovalidate: true,
        inputFormatters: [isPhoneNumber! ? FilteringTextInputFormatter.digitsOnly : FilteringTextInputFormatter.singleLineFormatter],
        validator: (input){
          if(input!.isEmpty){
            if(isValidator!){
              return validatorMessage??"";
            }
          }
          return null;

        },
        readOnly: readOnly!,
        decoration: InputDecoration(
          prefixIcon: const Icon(
              Icons.email,
              color: Colors.grey,
            ),
            suffix: suffix!=null?suffix:const SizedBox.shrink(),
          hintText: hintText ?? '',
          filled: fillColor != null,
          fillColor: fillColor,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
          isDense: true,
          counterText: '',
          errorStyle: const TextStyle(height: 1.5),
            focusedBorder:  const UnderlineInputBorder(
                borderSide: BorderSide(color: JAMII_PRIMARY_COLOR)),
            border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey))
        ),
      ),
    );
  }
}
