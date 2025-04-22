import 'package:flutter/material.dart';

class HomeDropDown extends StatefulWidget {
  final List<String> items;
  final String nullPlaceholder;
  final Color? borderColor;
  final bool isExpanded;

  const HomeDropDown({
    super.key,
    required this.items,
    required this.nullPlaceholder,
    this.borderColor,
    this.isExpanded = false,
  });

  @override
  State<HomeDropDown> createState() => _HomeDropDownState();
}

class _HomeDropDownState extends State<HomeDropDown> {
  String? currentValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
      ),
      child: DropdownButton<String>(
        isExpanded: widget.isExpanded,
        borderRadius: BorderRadius.circular(4),
        padding: EdgeInsets.symmetric(horizontal: 10),
        underline: SizedBox.shrink(),
        icon: Icon(Icons.arrow_drop_down, color: widget.borderColor),
        value: currentValue,
        dropdownColor: Theme.of(context).colorScheme.primary,
        onChanged: (value) {
          setState(() {
            currentValue = value;
          });
        },
        items: [
          DropdownMenuItem(
            value: null,
            child: Text(
              widget.nullPlaceholder,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: widget.borderColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...widget.items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: widget.borderColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
