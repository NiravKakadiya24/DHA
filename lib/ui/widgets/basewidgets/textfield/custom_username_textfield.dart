import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:jamii_check/global/globals.dart';

class CustomUsernameTextField extends StatelessWidget {
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
  final bool? isValidUsername;
  final bool? isChecked;

  const CustomUsernameTextField(
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
      this.capitalization = TextCapitalization.none,
      this.fillColor,
      this.isChecked=false,
      this.isValidUsername=true});

  @override
  Widget build(context) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        controller: controller,
        maxLines: maxLine ?? 1,
        textCapitalization: capitalization!,
        maxLength: 15,
        focusNode: focusNode,
        keyboardType: textInputType ?? TextInputType.text,
        initialValue: null,
        textInputAction: textInputAction ?? TextInputAction.next,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(nextNode);
        },
        //autovalidate: true,
        inputFormatters: [FilteringTextInputFormatter(RegExp("[a-zA-Z0-9]"),allow: true)],
        validator: (input){
          if(input!.isEmpty){
              return "username cannot be empty";
          }
          else if(!isValidUsername!){
            return "username already taken";
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hintText ?? '',
          suffixIcon:isChecked!? (isValidUsername!?const Icon(
              Icons.check_circle,
              color: JAMII_GREEN_COLOR,
            ):const Icon(
              Icons.close,
              color: JAMII_RED_COLOR,
            )):const SizedBox(height: 0.0,width: 0.0,),
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
