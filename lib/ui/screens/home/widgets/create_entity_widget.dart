import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/api/entity.dart';
import 'package:frontend/ui/screens/home/widgets/dropdown.dart';
import 'package:frontend/ui/screens/home/widgets/input.dart';
import 'package:frontend/ui/screens/home/widgets/phone_input_field.dart';
import 'package:frontend/utils/extensions/build_context.dart';
import 'package:frontend/utils/extensions/string.dart';
import 'package:frontend/utils/helpers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/phone_number.dart';
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
  final TextEditingController pseudosController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String phoneNumber = '';
  String? number;

  DateTime? birthDate;
  bool birthFailedValidation = false;

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
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: 10),
            HomeInputField(
              controller: pseudosController,
              label: context.t('pseudos'),
            ),
            const SizedBox(height: 10),
            HomeDropDown(
              controller: categoryController,
              isExpanded: true,
              showAllOption: false,
              defaultValue: EntityType.values.first.name,
              items: EntityType.values.map((e) => e.name).toList(),
              borderColor: Theme.of(context).colorScheme.onPrimary,
              nullPlaceholder: context.t('allCategories'),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: PhoneInputField(
                    defaultValue: phoneNumber,
                    onChanged: (phone) {
                      phoneNumber = phone.completeNumber.substring(1);
                      number = phone.number;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PhoneInputField(
                    defaultValue: phoneNumber,
                    onChanged: (phone) {
                      phoneNumber = phone.completeNumber.substring(1);
                      number = phone.number;
                    },
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () async {
                DateTime? birthDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (birthDate == null) return;
                setState(() {
                  this.birthDate = birthDate;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                height: 47,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).colorScheme.primary,
                  border: Border.all(
                    color:
                    birthFailedValidation
                        ? Colors.red.shade800
                        : Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      birthDate == null
                          ? context.t('birthDate')
                          : toDate(birthDate!),
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(
                        color:
                        birthFailedValidation
                            ? Colors.red.shade800
                            : Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    Spacer(),
                    if (birthDate != null)
                      IconButton(
                        onPressed: () {
                          setState(() {
                            birthDate = null;
                          });
                        },
                        icon: Icon(
                          Icons.clear,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 18,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            HomeInputField(
              controller: nameController,
              label: context.t('location'),
              prefixIcon: Icon(Icons.location_on, color: Theme.of(context).colorScheme.onPrimary, size: 20,),
              validator: (txt) {
                if (txt?.isEmpty ?? true) {
                  return context.t('nameRequired');
                }
                return null;
              },
            ),
           const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: HomeInputField(
                    controller: nameController,
                    label: "Linkedin",
                    hintText: "@${context.t('username')}",
                    validator: (txt) {
                      if (txt?.isEmpty ?? true) {
                        return context.t('username');
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: HomeInputField(
                    controller: nameController,
                    label: "X (Twitter)",
                    hintText: "@${context.t('username')}",
                    validator: (txt) {
                      if (txt?.isEmpty ?? true) {
                        return context.t('username');
                      }
                      return null;
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: HomeInputField(
                    controller: nameController,
                    label: "Instagram",
                    hintText: "@${context.t('username')}",
                    validator: (txt) {
                      if (txt?.isEmpty ?? true) {
                        return context.t('username');
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: HomeInputField(
                    controller: nameController,
                    label: "YouTube",
                    hintText: "@${context.t('username')}",
                    validator: (txt) {
                      if (txt?.isEmpty ?? true) {
                        return context.t('username');
                      }
                      return null;
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            HomeInputField(
              controller: nameController,
              label: "Facebook (1)",
              hintText: "@${context.t('link')}",
              validator: (txt) {
                if (txt?.isEmpty ?? true) {
                  return context.t('nameRequired');
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
              HomeInputField(
              controller: nameController,
              label: "Facebook (2)",
              hintText: "@${context.t('link')}",
              validator: (txt) {
                if (txt?.isEmpty ?? true) {
                  return context.t('nameRequired');
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            HomeInputField(
              controller: nameController,
              label: context.t('website'),
              hintText: 'http://example.com',
              prefixIcon: Icon(Icons.language, color: Theme.of(context).colorScheme.onPrimary, size: 20,),
              validator: (txt) {
                if (txt?.isEmpty ?? true) {
                  return context.t('nameRequired');
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            HomeInputField(
              controller: nameController,
              label: "Email (1)",
              prefixIcon: Icon(Icons.email, color: Theme.of(context).colorScheme.onPrimary, size: 20,),
              hintText:'email@example.com',
              validator: (txt) {
                if (txt?.isEmpty ?? true) {
                  return context.t('nameRequired');
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            HomeInputField(
              controller: nameController,
              label: "Email (2)",
              hintText: 'email@example.com',
              prefixIcon: Icon(Icons.email, color: Theme.of(context).colorScheme.onPrimary, size: 20,),
              validator: (txt) {
                if (txt?.isEmpty ?? true) {
                  return context.t('nameRequired');
                }
                return null;
              },
            ),

            const SizedBox(height: 10),
            _submitButton(),
          ],
        ),
      ),
    );
  }


  Widget _submitButton() {
    return  InkWell(
      onTap: () async {
        if (!formKey.currentState!.validate()) {
          return;
        }

        if (number != null && int.tryParse(number!) == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red.shade600,
              content: Text(
                context.t('invalidPhone'),
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
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

        final Map<String, dynamic> data = {};

        data['name'] = nameController.text;

        data['description'] = descriptionController.text;

        data['type'] = categoryController.value;

        data['file'] = MultipartFile.fromBytes(
          await image!.readAsBytes(),
          filename: image!.name,
        );

        List<String>? pseudos =
        pseudosController.text
            .split(",")
            .map((e) => e.trimOut())
            .where((e) => e.isNotEmpty)
            .toList();

        pseudos = pseudos.isEmpty ? null : pseudos;

        if (pseudos != null) {
          data['pseudos'] =
          pseudos.length == 1 ? [pseudos[0], " "] : pseudos;
        }

        if (number != null && int.tryParse(number!) != null) {
          data['phone'] = int.tryParse(phoneNumber).toString();
        }

        if (birthDate != null) {
          data['birthDate'] = birthDate?.toIso8601String();
        }

        try {
          final formData = FormData.fromMap(data);

          entity = await EntityApi.create(formData);
        } catch (e) {
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
