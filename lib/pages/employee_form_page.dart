// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:employee_work/blocs/timer/timer_bloc.dart';
import 'package:employee_work/blocs/voice/voice_bloc.dart';
import 'package:employee_work/core/extensions/extension.dart';
import 'package:employee_work/core/theme/spacing.dart';
import 'package:employee_work/core/utils/util.dart';
import 'package:employee_work/l10n/l10n.dart';
import 'package:employee_work/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class EmployeeFormPage extends StatelessWidget {
  const EmployeeFormPage({super.key});

  static MaterialPage<void> page({Key? key}) => MaterialPage<void>(
        child: EmployeeFormPage(key: key),
      );

  @override
  Widget build(BuildContext context) {
    return const EmployeeFormView();
  }
}

class EmployeeFormView extends StatefulWidget {
  const EmployeeFormView({super.key});

  @override
  State<EmployeeFormView> createState() => _EmployeeFormViewState();
}

class _EmployeeFormViewState extends State<EmployeeFormView> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final rateController = TextEditingController(text: "4000");
  final nameFocus = FocusNode();
  final rateFocus = FocusNode();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  Future<void> _getImageFromGallery() async {
    await PermissionUtil.checkPhotoPermission(
      context,
      grantedCallback: () async {
        final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          final filePath = pickedFile.path;
          setState(() {
            _imageFile = File(filePath);
          });
        }
      },
    );
  }

  Future<void> _takePhoto() async {
    await PermissionUtil.checkCameraPermission(
      context,
      grantedCallback: () async {
        final pickedFile = await _picker.pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          final filePath = pickedFile.path;
          setState(() {
            _imageFile = File(filePath);
          });
        }
      },
    );
  }

  Future<File> _saveImageToPermanentStorage(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = imageFile.path.split('/').last;
    final newPath = '${directory.path}/$fileName';
    return imageFile.copy(newPath);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: context.colors.neutral98,
      appBar: AppBar(
        title: Text(l10n.new_person),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.l),
        child: Column(
          children: [
            Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: CupertinoButton(
                  minSize: 0,
                  pressedOpacity: 0.8,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    CustomModal.showRoundedModal(
                      context,
                      (modalContext) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  l10n.chose_photo,
                                  style: context.textTheme.titleLarge!.copyWith(
                                    color: context.colors.neutral0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.camera_alt,
                              color: Colors.greenAccent,
                            ),
                            onTap: () {
                              _takePhoto();
                              context.pop();
                            },
                            title: Text(
                              l10n.take_photo,
                              style: context.textTheme.titleMedium!.copyWith(
                                color: context.colors.neutral0,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.image,
                              color: Colors.deepPurpleAccent,
                            ),
                            onTap: () {
                              _getImageFromGallery();
                              context.pop();
                            },
                            title: Text(
                              l10n.choose_from_library,
                              style: context.textTheme.titleMedium!.copyWith(
                                color: context.colors.neutral0,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.viewPaddingOf(
                              context,
                            ).bottom,
                          ),
                        ],
                      ),
                    );
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      CircleAvatar(
                        backgroundColor: context.colors.neutral90,
                        radius: 50,
                        child: ClipOval(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: _imageFile != null
                                ? Image.file(
                                    _imageFile!,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.person, size: 50),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor:
                              context.colors.neutral0.withOpacity(0.5),
                          child: Icon(
                            Icons.edit,
                            color: context.colors.neutral100,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: Spacing.l),
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    focusNode: nameFocus,
                    autofocus: true,
                    decoration: InputDecoration(labelText: l10n.person_name),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.name_cannot_be_empty;
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(rateFocus),
                  ),
                  const SizedBox(height: Spacing.l),
                  TextFormField(
                    controller: rateController,
                    focusNode: rateFocus,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(labelText: l10n.horuly_rate),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      final rate = int.tryParse(text);
                      if (text.isEmpty) {
                        return l10n.rate_is_required;
                      } else if (rate == null || rate <= 0) {
                        return l10n.rate_must_be_positive_number;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(Spacing.l),
        child: ElevatedButton(
          onPressed: () async {
            final isValid = _formKey.currentState!.validate();

            if (!isValid) {
              if (nameController.text.trim().isEmpty) {
                nameFocus.requestFocus();
              } else if (int.tryParse(rateController.text.trim()) == null ||
                  int.parse(rateController.text.trim()) <= 0) {
                rateFocus.requestFocus();
              }
              return;
            }

            final id = const Uuid().v4();
            final name = nameController.text.trim();
            final rate = int.parse(rateController.text.trim());

            if (_imageFile != null) {
              try {
                final savedFile =
                    await _saveImageToPermanentStorage(_imageFile!);
                context.read<TimerBloc>().add(
                      StartTimer(
                        id: id,
                        name: name,
                        hourlyRate: rate.toDouble(),
                        image: savedFile,
                      ),
                    );
              } catch (e) {
                print("Error: $e");
              }
            } else {
              context.read<TimerBloc>().add(
                    StartTimer(
                      id: id,
                      name: name,
                      hourlyRate: rate.toDouble(),
                      image: null,
                    ),
                  );
            }

            final allowSpeak = context.read<VoiceBloc>().state.enableVoice;
            if (allowSpeak) {
              VoiceUtil.speakText(
                '$name${'ចាប់ផ្តើមធ្វើការ'}${TimeUtil.formatKhmerTime(
                  DateTime.now(),
                )}',
                grantedCallback: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(l10n.alert),
                      content: Text(l10n.sound_khmer_not_supported),
                    ),
                  );
                },
              );
            }
            context.pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(Spacing.m),
            child:
                Text(l10n.start, style: const TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
