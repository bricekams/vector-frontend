import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  late HomeDropDownController genderController;
  late HomeDropDownController religionController;
  late HomeDropDownController regionController;
  late TextEditingController pseudosController;
  late TextEditingController locationController;
  late TextEditingController linkedinController;
  late TextEditingController twitterController;
  late TextEditingController instagramController;
  late TextEditingController youtubeController;
  late TextEditingController facebook1Controller;
  late TextEditingController facebook2Controller;
  late TextEditingController websiteController;
  late TextEditingController email1Controller;
  late TextEditingController email2Controller;
  
  String phoneNumber1 = '';
  String? number1;
  String phoneNumber2 = '';
  String? number2;
  
  DateTime? birthDate;
  bool birthFailedValidation = false;
  bool noImageError = false;
  String? initialImageUrl;

  final ImagePicker picker = ImagePicker();
  XFile? image;
  bool editing = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    categoryController = HomeDropDownController(value: null);
    genderController = HomeDropDownController(value: null);
    religionController = HomeDropDownController(value: null);
    regionController = HomeDropDownController(value: null);
    pseudosController = TextEditingController();
    locationController = TextEditingController();
    linkedinController = TextEditingController();
    twitterController = TextEditingController();
    instagramController = TextEditingController();
    youtubeController = TextEditingController();
    facebook1Controller = TextEditingController();
    facebook2Controller = TextEditingController();
    websiteController = TextEditingController();
    email1Controller = TextEditingController();
    email2Controller = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final entity = context.read<HomeProvider>().selectedEntity!;
      initialImageUrl = getImageUrl(entity.image!, "entities");

      nameController.text = entity.name;
      descriptionController.text = entity.description;
      categoryController.value = entity.type.name;
      genderController.value = entity.gender?.name;
      religionController.value = entity.religion?.name;
      regionController.value = entity.region?.name;
      phoneNumber1 = entity.phone_1?.toString() ?? '';
      phoneNumber2 = entity.phone_2?.toString() ?? '';
      pseudosController.text = entity.pseudos?.join(',') ?? '';
      birthDate = entity.birthDate;
      locationController.text = entity.lastKnownLocation ?? '';
      linkedinController.text = entity.linkedin ?? '';
      twitterController.text = entity.twitter ?? '';
      instagramController.text = entity.instagram ?? '';
      youtubeController.text = entity.youtube ?? '';
      facebook1Controller.text = entity.facebook_1 ?? '';
      facebook2Controller.text = entity.facebook_2 ?? '';
      websiteController.text = entity.website ?? '';
      email1Controller.text = entity.email_1 ?? '';
      email2Controller.text = entity.email_2 ?? '';
      setState(() {});
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    genderController.dispose();
    religionController.dispose();
    regionController.dispose();
    pseudosController.dispose();
    locationController.dispose();
    linkedinController.dispose();
    twitterController.dispose();
    instagramController.dispose();
    youtubeController.dispose();
    facebook1Controller.dispose();
    facebook2Controller.dispose();
    websiteController.dispose();
    email1Controller.dispose();
    email2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 10),
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
              controller: locationController,
              label: context.t('location'),
              prefixIcon: Icon(Icons.location_on, color: Theme.of(context).colorScheme.onPrimary, size: 20,),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: HomeInputField(
                    controller: linkedinController,
                    label: "Linkedin",
                    hintText: context.t('username'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: HomeInputField(
                    controller: twitterController,
                    label: "X (Twitter)",
                    hintText: context.t('username'),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: HomeInputField(
                    controller: instagramController,
                    label: "Instagram",
                    hintText: "@${context.t('username')}",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: HomeInputField(
                    controller: youtubeController,
                    label: "YouTube",
                    hintText: context.t('username'),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            HomeInputField(
              controller: facebook1Controller,
              label: "Facebook (1)",
              hintText: context.t('username'),
            ),
            const SizedBox(height: 10),
            HomeInputField(
              controller: facebook2Controller,
              label: "Facebook (2)",
              hintText: context.t('username'),
            ),
            const SizedBox(height: 10),
            HomeInputField(
              controller: websiteController,
              label: context.t('website'),
              hintText: 'http://example.com',
              prefixIcon: Icon(Icons.language, color: Theme.of(context).colorScheme.onPrimary, size: 20,),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: HomeInputField(
                    controller: email1Controller,
                    label: "Email (1)",
                    prefixIcon: Icon(Icons.email, color: Theme.of(context).colorScheme.onPrimary, size: 20,),
                    hintText:'email@example.com',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: HomeInputField(
                    controller: email2Controller,
                    label: "Email (2)",
                    hintText: 'email@example.com',
                    prefixIcon: Icon(Icons.email, color: Theme.of(context).colorScheme.onPrimary, size: 20,),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
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
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
              ),
              child: Center(
                child: Text(
                  context.t('cancel'),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: InkWell(
            onTap: () async {
              if (!formKey.currentState!.validate()) return;

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

              setState(() => editing = true);

              try {
                final selectedEntity = context.read<HomeProvider>().selectedEntity!;
                final Map<String, dynamic> data = {};

                // Basic information
                if (nameController.text != selectedEntity.name) {
                  data['name'] = nameController.text;
                }

                if (descriptionController.text != selectedEntity.description) {
                  data['description'] = descriptionController.text;
                }

                if (categoryController.value != selectedEntity.type.name) {
                  data['type'] = categoryController.value;
                }

                // Gender, Religion, Region
                if (genderController.value != selectedEntity.gender?.name) {
                  data['gender'] = genderController.value;
                }

                if (religionController.value != selectedEntity.religion?.name) {
                  data['religion'] = religionController.value;
                }

                if (regionController.value != selectedEntity.region?.name) {
                  data['region'] = regionController.value;
                }

                // Image
                if (image != null) {
                  data['file'] = MultipartFile.fromBytes(
                    await image!.readAsBytes(),
                    filename: image!.name,
                  );
                }

                // Pseudos
                if (pseudosController.text != selectedEntity.pseudos?.join(',')) {
                  List<String> pseudos = pseudosController.text
                      .split(",")
                      .map((e) => e.trimOut())
                      .where((e) => e.isNotEmpty)
                      .toList();
                  data['pseudos'] = pseudos.length == 1 ? [pseudos[0], " "] : pseudos;
                }

                // Phone numbers
                if (number1 != null && int.tryParse(number1!) != null) {
                  String newPhone1 = int.tryParse(phoneNumber1).toString();
                  if (newPhone1 != selectedEntity.phone_1?.toString()) {
                    data['phone_1'] = newPhone1;
                  }
                }

                if (number2 != null && int.tryParse(number2!) != null) {
                  String newPhone2 = int.tryParse(phoneNumber2).toString();
                  if (newPhone2 != selectedEntity.phone_2?.toString()) {
                    data['phone_2'] = newPhone2;
                  }
                }

                // Birth date
                if (birthDate != null && birthDate != selectedEntity.birthDate) {
                  data['birthDate'] = "${birthDate!.toIso8601String()}Z";
                }

                // Location
                if (locationController.text != (selectedEntity.lastKnownLocation ?? '')) {
                  data['lastKnownLocation'] = locationController.text;
                }

                // Social media
                if (linkedinController.text != (selectedEntity.linkedin ?? '')) {
                  data['linkedin'] = linkedinController.text;
                }

                if (twitterController.text != (selectedEntity.twitter ?? '')) {
                  data['twitter'] = twitterController.text;
                }

                if (instagramController.text != (selectedEntity.instagram ?? '')) {
                  data['instagram'] = instagramController.text;
                }

                if (youtubeController.text != (selectedEntity.youtube ?? '')) {
                  data['youtube'] = youtubeController.text;
                }

                if (facebook1Controller.text != (selectedEntity.facebook_1 ?? '')) {
                  data['facebook_1'] = facebook1Controller.text;
                }

                if (facebook2Controller.text != (selectedEntity.facebook_2 ?? '')) {
                  data['facebook_2'] = facebook2Controller.text;
                }

                // Website and emails
                if (websiteController.text != (selectedEntity.website ?? '')) {
                  data['website'] = websiteController.text;
                }

                if (email1Controller.text != (selectedEntity.email_1 ?? '')) {
                  data['email_1'] = email1Controller.text;
                }

                if (email2Controller.text != (selectedEntity.email_2 ?? '')) {
                  data['email_2'] = email2Controller.text;
                }

                final formData = FormData.fromMap(data);
                print(data.toString());

                final entity = await EntityApi.update(selectedEntity.id, formData);
                if (context.mounted) {
                  context.read<HomeProvider>().updateEntity(entity);
                  context.read<HomeProvider>().setShowSideBox(false);
                }
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
              } finally {
                if (context.mounted) {
                  setState(() => editing = false);
                }
              }
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.onSecondaryFixedVariant,
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (editing) ...[
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      context.t('edit'),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
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
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 2),
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
                            : NetworkImage(
                              initialImageUrl!,
                              headers: {'ngrok-skip-browser-warning': 'true'},
                            ),
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
                            borderRadius: BorderRadius.circular(6),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                        ),
                        icon: Icon(Icons.edit, size: 18),
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
}

