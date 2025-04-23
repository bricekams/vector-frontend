import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/entity.dart';
import 'package:frontend/ui/screens/home/widgets/dropdown.dart';
import 'package:frontend/ui/screens/home/widgets/input.dart';
import 'package:frontend/utils/extensions/build_context.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../models/entity.dart';
import '../../../../providers/home.dart';

class CreateEntityWidget extends StatefulWidget {
  const CreateEntityWidget({super.key});

  @override
  State<CreateEntityWidget> createState() => _CreateEntityWidgetState();
}

class _CreateEntityWidgetState extends State<CreateEntityWidget> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool noImageError = false;

  final ImagePicker picker = ImagePicker();
  XFile? image;
  bool creating = false;

  HomeDropDownController categoryController = HomeDropDownController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
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
                        HomeInputField(
                          controller: nameController,
                          label: context.t('name'),
                          validator: (txt) {
                            if (txt?.isEmpty ?? true) {
                              return context.t('nameRequired');
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: HomeInputField(
                            controller: descriptionController,
                            maxLines: null,
                            validator: (txt) {
                              if (txt?.isEmpty ?? true) {
                                return context.t('descriptionRequired');
                              }
                              return null;
                            },
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
              controller: categoryController,
              isExpanded: true,
              showAllOption: false,
              defaultValue: EntityType.values.first.name,
              items: EntityType.values.map((e) => e.name).toList(),
              borderColor: Theme.of(context).colorScheme.secondaryContainer,
              nullPlaceholder: context.t('allCategories'),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () async {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                if (image == null) {
                  setState(() {
                    noImageError = true;
                  });
                  return;
                }

                setState(() {
                  creating = true;
                });
                Entity entity;
                print("image image image ${image!.path}");

                try {
                  final formData = FormData.fromMap({
                    "name": nameController.text,
                    "description": descriptionController.text,
                    "file": MultipartFile.fromBytes(
                      await image!.readAsBytes(),
                      filename: image!.name,
                    ),
                    "type": categoryController.value,
                  });

                  print("data $formData");

                  entity = await EntityApi.create(formData);
                } catch (e) {
                  print(e);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red.shade600,

                        content: Text(
                          context.t('wentWrong'),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }
                  setState(() {
                    creating = false;
                  });
                  return;
                }
                if (context.mounted) {
                  context.read<HomeProvider>().addEntity(entity);
                }
                _clearFields();
                if (context.mounted) {
                  context.read<HomeProvider>().setShowSideBox(false);
                }
                setState(() {
                  creating = false;
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
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.inversePrimary,
              blurRadius: 0.5,
              spreadRadius: 1,
              offset: Offset(0, 0),
            ),
          ],
          border: noImageError ? Border.all(color: Colors.red.shade800) : null,
          image:
              image != null
                  ? DecorationImage(
                    image:
                        kIsWeb
                            ? NetworkImage(image!.path)
                            : FileImage(File(image!.path)),
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
        image = pickedFile;
        noImageError = false;
      });
    }
  }

  _clearFields() {
    setState(() {
      nameController.clear();
      descriptionController.clear();
      categoryController.clear();
      image = null;
    });
  }
}
