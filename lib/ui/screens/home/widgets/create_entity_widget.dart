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
  final TextEditingController locationController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();
  final TextEditingController twitterController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController youtubeController = TextEditingController();
  final TextEditingController facebook1Controller = TextEditingController();
  final TextEditingController facebook2Controller = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController email1Controller = TextEditingController();
  final TextEditingController email2Controller = TextEditingController();

  String phoneNumber1 = '';
  String? number1;
  String phoneNumber2 = '';
  String? number2;

  DateTime? birthDate;
  bool birthFailedValidation = false;

  bool noImageError = false;

  final ImagePicker picker = ImagePicker();
  XFile? image;
  bool creating = false;

  HomeDropDownController categoryController = HomeDropDownController();
  HomeDropDownController genderController = HomeDropDownController();
  HomeDropDownController religionController = HomeDropDownController();
  HomeDropDownController regionController = HomeDropDownController();

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
            HomeDropDown(
              controller: genderController,
              isExpanded: true,
              showAllOption: true,
              defaultValue: null,
              items: Gender.values.map((e) => e.name).toList(),
              borderColor: Theme.of(context).colorScheme.onPrimary,
              nullPlaceholder: context.t('selectGender'),
            ),
            const SizedBox(height: 10),
            HomeDropDown(
              controller: religionController,
              isExpanded: true,
              showAllOption: true,
              defaultValue: null,
              items: Religion.values.map((e) => e.name).toList(),
              borderColor: Theme.of(context).colorScheme.onPrimary,
              nullPlaceholder: context.t('selectReligion'),
            ),
            const SizedBox(height: 10),
            HomeDropDown(
              controller: regionController,
              isExpanded: true,
              showAllOption: true,
              defaultValue: null,
              items: Region.values.map((e) => e.name).toList(),
              borderColor: Theme.of(context).colorScheme.onPrimary,
              nullPlaceholder: context.t('selectRegion'),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: PhoneInputField(
                    defaultValue: phoneNumber1,
                    onChanged: (phone) {
                      phoneNumber1 = phone.completeNumber.substring(1);
                      number1 = phone.number;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PhoneInputField(
                    defaultValue: phoneNumber2,
                    onChanged: (phone) {
                      phoneNumber2 = phone.completeNumber.substring(1);
                      number2 = phone.number;
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
              controller: locationController,
              label: context.t('location'),
              prefixIcon: Icon(
                Icons.location_on,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 20,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: HomeInputField(
                    controller: linkedinController,
                    label: "Linkedin",
                    hintText: context.t('username'),
                    validator: (txt) {
                      if (txt?.trimOut().contains(" ") ?? false) {
                        return context.t('invalidUsername');
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: HomeInputField(
                    controller: twitterController,
                    label: "X (Twitter)",
                    hintText: context.t('username'),
                    validator: (txt) {
                      if (txt?.trimOut().contains(" ") ?? false) {
                        return context.t('invalidUsername');
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: HomeInputField(
                    controller: instagramController,
                    label: "Instagram",
                    hintText: context.t('username'),
                    validator: (txt) {
                      if (txt?.trimOut().contains(" ") ?? false) {
                        return context.t('invalidUsername');
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: HomeInputField(
                    controller: youtubeController,
                    label: "YouTube",
                    hintText: context.t('username'),
                    validator: (txt) {
                      if (txt?.contains(" ") ?? false) {
                        return context.t('invalidUsername');
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            HomeInputField(
              controller: facebook1Controller,
              label: "Facebook (1)",
              hintText: context.t('username'),
              validator: (txt) {
                if (txt?.contains(" ") ?? false) {
                  return context.t('invalidUsername');
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            HomeInputField(
              controller: facebook2Controller,
              label: "Facebook (2)",
              hintText: context.t('username'),
              validator: (txt) {
                if (txt?.contains(" ") ?? false) {
                  return context.t('invalidUsername');
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            HomeInputField(
              controller: websiteController,
              label: context.t('website'),
              hintText: 'http://example.com',
              validator: (txt) {
                if (txt?.contains(" ") ?? false) {
                  return context.t('invalidLink');
                }
                return null;
              },
              prefixIcon: Icon(
                Icons.language,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 20,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: HomeInputField(
                    controller: email1Controller,
                    label: "Email (1)",
                    prefixIcon: Icon(
                      Icons.email,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 20,
                    ),
                    hintText: 'email@example.com',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: HomeInputField(
                    controller: email2Controller,
                    label: "Email (2)",
                    hintText: 'email@example.com',
                    prefixIcon: Icon(
                      Icons.email,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            _submitButton(),
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        if (!formKey.currentState!.validate()) {
          return;
        }

        if (genderController.value == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red.shade600,
              content: Text(
                context.t('genderRequired'),
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
          return;
        }

        if (number1 != null && int.tryParse(number1!) == null) {
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

        if (number2 != null && int.tryParse(number2!) == null) {
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

        data['gender'] = genderController.value!;

        if (religionController.value != null) {
          data['religion'] = religionController.value;
        }

        if (regionController.value != null) {
          data['region'] = regionController.value;
        }

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
          data['pseudos'] = pseudos.length == 1 ? [pseudos[0], " "] : pseudos;
        }

        if (number1 != null && int.tryParse(number1!) != null) {
          data['phone_1'] = int.tryParse(phoneNumber1).toString();
        }

        if (number2 != null && int.tryParse(number2!) != null) {
          data['phone_2'] = int.tryParse(phoneNumber2).toString();
        }

        if (birthDate != null) {
          data['birthDate'] = "${birthDate!.toIso8601String()}Z";
        }

        if (locationController.text.isNotEmpty) {
          data['lastKnownLocation'] = locationController.text;
        }

        if (linkedinController.text.isNotEmpty) {
          data['linkedin'] = linkedinController.text;
        }

        if (twitterController.text.isNotEmpty) {
          data['twitter'] = twitterController.text;
        }

        if (instagramController.text.isNotEmpty) {
          data['instagram'] = instagramController.text;
        }

        if (youtubeController.text.isNotEmpty) {
          data['youtube'] = youtubeController.text;
        }

        if (facebook1Controller.text.isNotEmpty) {
          data['facebook_1'] = facebook1Controller.text;
        }

        if (facebook2Controller.text.isNotEmpty) {
          data['facebook_2'] = facebook2Controller.text;
        }

        if (websiteController.text.isNotEmpty) {
          data['website'] = websiteController.text;
        }

        if (email1Controller.text.isNotEmpty) {
          data['email_1'] = email1Controller.text;
        }

        if (email2Controller.text.isNotEmpty) {
          data['email_2'] = email2Controller.text;
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
      pseudosController.clear();
      locationController.clear();
      linkedinController.clear();
      twitterController.clear();
      instagramController.clear();
      youtubeController.clear();
      facebook1Controller.clear();
      facebook2Controller.clear();
      websiteController.clear();
      email1Controller.clear();
      email2Controller.clear();
      categoryController.clear();
      genderController.clear();
      religionController.clear();
      regionController.clear();
      phoneNumber1 = '';
      phoneNumber2 = '';
      number1 = null;
      number2 = null;
      birthDate = null;
      image = null;
      noImageError = false;
    });
  }
}
