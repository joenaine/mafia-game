import 'package:flutter/material.dart';
import 'package:mafiagame/constants/app_colors_const.dart';
import 'package:mafiagame/services/validator.dart';

class PinputTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;

  const PinputTextfield(
      {super.key,
      required this.controller,
      this.hintText,
      this.keyboardType,
      this.focusNode,
      this.onFieldSubmitted,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 30),
          cursorColor: AppColors.error,
          focusNode: focusNode,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              fillColor: Theme.of(context).colorScheme.primary,
              filled: true,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 30)),
          validator: (value) {
            var defaultValidator = Validator.of(context).notEmpty(value);
            return defaultValidator;
          }),
    );
  }
}
