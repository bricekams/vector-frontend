import 'package:flutter/material.dart';
import 'package:frontend/config/routes.dart';
import 'package:frontend/providers/augment.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class LoaderScreen extends StatefulWidget {
  const LoaderScreen({super.key});

  @override
  State<LoaderScreen> createState() => _LoaderScreenState();
}

class _LoaderScreenState extends State<LoaderScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<AugmentProvider>().init().then((value) {
        if (mounted) context.go(AppRoutes.home);
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: LoadingAnimationWidget.hexagonDots(
          color: Theme.of(context).colorScheme.primary,
          size: 100,
        ),
      ),
    );
  }
}
