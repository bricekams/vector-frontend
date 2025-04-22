import 'package:flutter/material.dart';

class HomeSideContainer extends StatelessWidget {
  final void Function() onClose;
  final String title;
  final Widget? body;
  const HomeSideContainer({super.key, required this.onClose, required this.title, this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3025,
      height: MediaQuery.of(context).size.height * 0.86,
      padding: EdgeInsets.only(left: 20, right: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.width * 0.007,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              IconButton(
                onPressed: onClose,
                icon: Icon(
                  Icons.close,
                  size: 40,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: body ?? Container(),
          )
        ],
      ),
    );
  }
}
