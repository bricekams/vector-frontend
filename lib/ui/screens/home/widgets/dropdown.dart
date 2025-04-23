import 'package:flutter/material.dart';
import 'package:frontend/utils/extensions/build_context.dart';

class HomeDropDownController extends ChangeNotifier {
  String? _value;

  String? get value => _value;

  set value(String? newValue) {
    _value = newValue;
    notifyListeners();
  }

  void clear() {
    _value = null;
    notifyListeners();
  }
}


class HomeDropDown extends StatefulWidget {
  final List<String> items;
  final String nullPlaceholder;
  final Color? borderColor;
  final bool isExpanded;
  final String? defaultValue;
  final bool showAllOption;
  final HomeDropDownController? controller;

  const HomeDropDown({
    super.key,
    required this.items,
    required this.nullPlaceholder,
    this.borderColor,
    this.isExpanded = false,
    this.defaultValue,
    this.showAllOption = true,
    this.controller,
  });

  @override
  State<HomeDropDown> createState() => _HomeDropDownState();
}


class _HomeDropDownState extends State<HomeDropDown> {
  late HomeDropDownController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? HomeDropDownController();
    _controller.addListener(_onExternalChange);

    if (_controller.value == null && widget.defaultValue != null) {
      _controller.value = widget.defaultValue;
    }
  }

  void _onExternalChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onExternalChange);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

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
        value: _controller.value,
        dropdownColor: Theme.of(context).colorScheme.primary,
        onChanged: (value) {
          _controller.value = value;
        },
        items: [
          if (widget.showAllOption)
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
                context.t(item),
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
