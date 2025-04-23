import 'package:flutter/material.dart';

class HomeInputField extends StatelessWidget {
  final double? height;
  final String? label;
  final int? maxLines;
  final bool expands;
  final int? maxLength;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;

  const HomeInputField({super.key, this.height, this.label, this.maxLines, this.expands = false, this.maxLength, this.validator, this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: TextFormField(
        expands: expands,
        validator: validator,
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        maxLength: maxLength,
        maxLines: expands ? null : (maxLines ?? 1),
        textAlignVertical: expands ? TextAlignVertical.top : TextAlignVertical.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        cursorColor: Theme.of(context).colorScheme.onPrimary,
        decoration: InputDecoration(
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red.shade800,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red.shade800,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.red.shade800,
          ),
          label: label != null ? Text(
            label!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ) : null ,
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 3,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          suffixIcon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
