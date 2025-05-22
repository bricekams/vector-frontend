import 'package:flutter/material.dart';
import 'package:frontend/utils/extensions/build_context.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class PhoneInputField extends StatefulWidget {
  final String? defaultValue;
  final void Function(PhoneNumber)? onChanged;

  const PhoneInputField({
    super.key,
    this.onChanged,
    this.defaultValue,
  });

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  PhoneNumber? initialValue;
  TextEditingController? controller;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.defaultValue != null && widget.defaultValue!.isNotEmpty) {
      initialValue = PhoneNumber.fromCompleteNumber(
        completeNumber: widget.defaultValue!,
      );

      controller = TextEditingController(
        text: initialValue?.number,
      );
    }


    return IntlPhoneField(
      controller: controller,
      initialCountryCode: initialValue?.countryCode ?? 'CM',
      decoration: InputDecoration(
        labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        labelText: context.t('phoneNumber'),
        prefixStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.shade800),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.shade800),
          borderRadius: BorderRadius.circular(4),
        ),
        errorStyle: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.red.shade800),
      ),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      cursorColor: Theme.of(context).colorScheme.onPrimary,
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        shape: BoxShape.rectangle,
        border: Border.all(color: Colors.transparent),
      ),
      dropdownIcon: Icon(
        Icons.arrow_drop_down,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      dropdownTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      onChanged: widget.onChanged,
    );
  }
}
