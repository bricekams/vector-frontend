import 'package:flutter/material.dart';

class HoverBorderWrapper extends StatefulWidget {
  final Widget child;
  final Color hoverBorderColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final void Function()? onTap;

  const HoverBorderWrapper({
    super.key,
    required this.child,
    required this.hoverBorderColor,
    this.borderColor = Colors.grey,
    this.borderWidth = 2.0,
    this.borderRadius = 10.0,
    this.onTap,
  });

  @override
  State<HoverBorderWrapper> createState() => _HoverBorderWrapperState();
}

class _HoverBorderWrapperState extends State<HoverBorderWrapper> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: InkWell(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            border: Border.all(
              color: _hovering ? widget.hoverBorderColor : widget.borderColor,
              width: widget.borderWidth,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
