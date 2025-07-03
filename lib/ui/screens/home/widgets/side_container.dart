import 'package:flutter/material.dart';
import 'package:frontend/ui/screens/home/printer.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:frontend/providers/home.dart';
import 'package:provider/provider.dart';

class HomeSideContainer extends StatelessWidget {
  final void Function() onClose;
  final String title;
  final Widget? body;

  const HomeSideContainer({
    super.key,
    required this.onClose,
    required this.title,
    this.body,
  });

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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (context.read<HomeProvider>().selectedSideState ==
                          HomeSideState.view) ...[
                        IconButton(
                          onPressed: () async {
                            final doc = await printEntity(
                              context.read<HomeProvider>().selectedEntity!,
                            );
                            if (!context.mounted) return;
                            await Printing.layoutPdf(
                              onLayout:
                                  (PdfPageFormat format) async => doc.save(),
                            );
                          },
                          style: IconButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                          icon: Icon(Icons.print, size: 30),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Text(
                        title,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
