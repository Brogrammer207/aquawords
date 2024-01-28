import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'addsize.dart';
import 'apptheme.dart';

class RegisterTextFieldWidget extends StatelessWidget {
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final Widget? suffix;
  final Widget? prefix;
  final Color? bgColor;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? hint;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final bool? readOnly;
  final dynamic value = 0;
  final dynamic minLines;
  final dynamic maxLines;
  final bool? obscureText;
  final VoidCallback? onTap;
  final length;

  const RegisterTextFieldWidget({
    Key? key,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.hint,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.bgColor,
    this.validator,
    this.suffix,
    this.autofillHints,
    this.prefix,
    this.minLines = 1,
    this.maxLines = 1,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
    this.length,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Color(0xff132137)),
      onTap: onTap,
      onChanged: onChanged,
      readOnly: readOnly!,
      controller: controller,
      obscureText: hint == hint ? obscureText! : false,
      autofillHints: autofillHints,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      minLines: minLines,
      maxLines: maxLines,
      cursorColor: AppTheme.primaryColor,
      inputFormatters: [
        LengthLimitingTextInputFormatter(length),
      ],
      decoration: InputDecoration(

          hintText: hint,
          focusColor: const Color(0xff132137),
          hintStyle: GoogleFonts.robotoSlab(
            color: const Color(0xff132137),
            textStyle: GoogleFonts.robotoSlab(
              color: const Color(0xff132137),
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
            fontSize: 14,
            // fontFamily: 'poppins',
            fontWeight: FontWeight.w300,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(.10),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          // .copyWith(top: maxLines! > 4 ? AddSize.size18 : 0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: const Color(0xff132137).withOpacity(.24)),
            borderRadius: BorderRadius.circular(6.0),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: const Color(0xff132137).withOpacity(.24)),
              borderRadius: const BorderRadius.all(Radius.circular(6.0))),
          border: OutlineInputBorder(
              borderSide:
              BorderSide(color:const Color(0xff132137).withOpacity(.24), width: 3.0),
              borderRadius: BorderRadius.circular(6.0)),
          suffixIcon: suffix,
          prefixIcon: prefix),
    );
  }
}
class CommonButtonBlue extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const CommonButtonBlue({Key? key, required this.title, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          minimumSize: MaterialStatePropertyAll(Size(AddSize.screenWidth, AddSize.size50 * 0.9)),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xff132137)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
          ),
        ),
        child: Text(title,
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: .3,
                fontSize: 16)));
  }
}