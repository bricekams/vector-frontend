import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/ui/screens/home/widgets/dropdown.dart';
import 'package:frontend/ui/screens/home/widgets/input.dart';
import 'package:frontend/utils/extensions/build_context.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../models/entity.dart';

class CreateEntityWidget extends StatefulWidget {
  const CreateEntityWidget({super.key});

  @override
  State<CreateEntityWidget> createState() => _CreateEntityWidgetState();
}

class _CreateEntityWidgetState extends State<CreateEntityWidget> {
  final ImagePicker picker = ImagePicker();
  File? image;
  bool creating = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _imagePicker(),
              Expanded(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.20709,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      HomeInputField(label: context.t('name')),
                      const SizedBox(height: 10),
                      Expanded(
                        child: HomeInputField(
                          maxLines: null,
                          // maxLength: 120,
                          label: context.t('description'),
                          expands: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          HomeDropDown(
            isExpanded: true,
            items: EntityType.values.map((e) => context.t(e.name)).toList(),
            borderColor: Theme.of(context).colorScheme.secondaryContainer,
            nullPlaceholder: context.t('allCategories'),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              setState(() {
                creating = true;
              });
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Theme.of(context).colorScheme.onSecondaryFixedVariant,
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (creating) ...[
                      SizedBox(
                        width: 13,
                        height: 13,
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Text(
                      context.t('create'),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _imagePicker() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.10416,
        height: MediaQuery.of(context).size.height * 0.20709,
        decoration: BoxDecoration(
          color: Colors.grey,
          image:
              image != null
                  ? DecorationImage(
                    image:
                        kIsWeb ? NetworkImage(image!.path) : FileImage(image!),
                    fit: BoxFit.cover,
                  )
                  : null,
        ),
        child:
            image == null
                ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (image != null) return;
                          _pickImage();
                        },
                        icon: Icon(
                          Icons.file_upload_outlined,
                          size: MediaQuery.of(context).size.width * 0.03,
                          color:
                              Theme.of(context).colorScheme.secondaryFixedDim,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Upload image",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.secondaryFixedDim,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
                : Stack(
                  children: [
                    Positioned(
                      top: 4,
                      right: 4,
                      child: IconButton(
                        onPressed: _pickImage,
                        style: IconButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                        ),
                        icon: Icon(Icons.edit),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }
}
