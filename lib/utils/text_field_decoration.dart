import 'package:flutter/material.dart';

InputDecoration inputDecoration({required String hintText}) => InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.6),
          fontSize: 16,
          fontWeight: FontWeight.w500),
      contentPadding:
          const EdgeInsets.only(right: 15, left: 12, top: 12, bottom: 12),
      disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white)),
    );
