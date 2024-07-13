import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextWidget extends StatelessWidget {
  const CustomTextWidget(
      {super.key,
      this.wordSpace,
      required this.text,
      this.color = Colors.black,
      this.fontSize = 16,
      this.maxLines = 100,
      this.softWrap = true,
      this.textOverflow = TextOverflow.ellipsis,
      this.font,
      this.fontWeight = FontWeight.normal,
      this.textAlign,
      this.textDecorationStyle,
      this.textDecoration,
      this.letterSpace});
  final dynamic text;
  final Color color;
  final double fontSize;
  final bool softWrap;
  final FontWeight fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? textOverflow;
  final double? wordSpace, letterSpace;
  final TextStyle? font;
  final TextDecorationStyle? textDecorationStyle;
  final TextDecoration? textDecoration;

  @override
  Widget build(BuildContext context) {
    double size = fontSize;
    // if (context.textScaleFactor < 1) {
    //   size = fontSize * context.textScaleFactor;
    // } else {
    //   size = fontSize / context.textScaleFactor;
    // }
    return Text(
      text.toString(),
      textAlign: textAlign,
      softWrap: softWrap,
      maxLines: maxLines,
      overflow: textOverflow,
      textScaleFactor: 1.0,
      style: (font ?? GoogleFonts.itim()).copyWith(
          color: color,
          fontSize: size,
          fontWeight: fontWeight,
          decoration: textDecoration,
          decorationStyle: textDecorationStyle,
          letterSpacing: letterSpace,
          wordSpacing: wordSpace),
    );
  }
}
