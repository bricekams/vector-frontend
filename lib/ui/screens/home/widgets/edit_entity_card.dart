import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/entity.dart';
import 'package:frontend/ui/screens/home/widgets/dropdown.dart';
import 'package:frontend/ui/screens/home/widgets/input.dart';
import 'package:frontend/utils/extensions/build_context.dart';
import 'package:frontend/utils/helpers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../models/entity.dart';
import '../../../../providers/home.dart';

class EditEntityWidget extends StatefulWidget {
  const EditEntityWidget({super.key});

  @override
  State<EditEntityWidget> createState() => _EditEntityWidgetState();
}

class _EditEntityWidgetState extends State<EditEntityWidget> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late HomeDropDownController categoryController;

  bool noImageError = false;
  String? initialImageUrl;

  final ImagePicker picker = ImagePicker();
  XFile? image;
  bool creating = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    categoryController = HomeDropDownController(value: null);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final entity = context.read<HomeProvider>().selectedEntity!;
      initialImageUrl = getImageUrl(entity.image!, "entities");

      nameController.text = entity.name;
      descriptionController.text = entity.description;
      categoryController.value = entity.type.name;

      setState(() {});
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    super.dispose();
  }

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
                if (!formKey.currentState!.validate()) return;

                setState(() => creating = true);

                Entity entity;

                try {
                  final selectedEntity =
                      context.read<HomeProvider>().selectedEntity!;
                  final Map<String, dynamic> data = {};

                  if (nameController.text != selectedEntity.name) {
                    data['name'] = nameController.text;
                  }

                  if (descriptionController.text !=
                      selectedEntity.description) {
                    data['description'] = descriptionController.text;
                  }

                  if (categoryController.value != selectedEntity.type.name) {
                    data['type'] = categoryController.value;
                  }

                  if (image != null) {
                    data['file'] = MultipartFile.fromBytes(
                      await image!.readAsBytes(),
                      filename: image!.name,
                    );
                  }

                  final formData = FormData.fromMap(data);

                  print(data);

                  entity = await EntityApi.update(selectedEntity.id, formData);
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
                  setState(() => creating = false);
                  return;
                }

                if (context.mounted) {
                  context.read<HomeProvider>().updateEntity(entity);
                  context.read<HomeProvider>().setShowSideBox(false);
                }

                setState(() => creating = false);
              },
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        context.read<HomeProvider>().setSelectedSideState(
                          HomeSideState.view,
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.onSecondaryFixedVariant,
                        ),
                        child: Center(
                          child: Text(
                            context.t('cancel'),
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color:
                            Theme.of(
                              context,
                            ).colorScheme.onSecondaryFixedVariant,
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
                              context.t('edit'),
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
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
              image != null || initialImageUrl != null
                  ? DecorationImage(
                    image:
                        image != null
                            ? (kIsWeb
                                    ? NetworkImage(image!.path)
                                    : FileImage(File(image!.path)))
                                as ImageProvider
                            : NetworkImage(initialImageUrl!),
                    fit: BoxFit.cover,
                  )
                  : null,
        ),
        child:
            image == null && initialImageUrl == null
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
        initialImageUrl = null;
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
