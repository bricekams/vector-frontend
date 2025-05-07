import 'package:flutter/material.dart';
import 'package:frontend/config/routes.dart';
import 'package:frontend/config/ws.dart';
import 'package:frontend/providers/augment.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

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
      double width = MediaQuery.of(context).size.width;
      if (width<1200) {
        context.go(AppRoutes.smallScreenError);
      }
      context.read<AugmentProvider>().init().then((value) {
        WSService.init();
        WSService.socket?.onConnect((event) {
         if (mounted) context.push(AppRoutes.home);
        });
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