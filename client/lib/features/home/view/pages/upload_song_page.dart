import 'dart:io';

import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/features/home/view/widgets/audio_wave.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({Key? key}) : super(key: key);

  @override
  ConsumerState<UploadSongPage> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final _songNameController = TextEditingController();
  final _artistNameController = TextEditingController();
  Color _selectedColor = Pallete.cardColor;
  File? selectedAudio;
  File? selectedImage;

  void selecteAudio() async {
    final audio = await pickAudio();
    if (audio != null) {
      setState(() {
        selectedAudio = audio;
      });
    }
  }

  void selectImage() async {
    final image = await pickImage();
    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  @override
  void dispose() {
    _songNameController.dispose();
    _artistNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Song'),
        actions: [
          IconButton(
            onPressed: () async {
              // if (
              //   formKey.currentState!.validate() &&
              //     selectedAudio != null &&
              //     selectedImage != null)
              //     {
              //   ref.read(homeViewModelProvider.notifier).uploadSong(
              //         selectedAudio: selectedAudio!,
              //         selectedThumbnail: selectedImage!,
              //         songName: songNameController.text,
              //         artist: artistController.text,
              //         selectedColor: selectedColor,
              //       );
              // } else {
              //   showSnackBar(context, 'Missing fields!');
              // }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: selectImage,
                child: selectedImage != null
                    ? SizedBox(
                        width: double.infinity,
                        height: 150,
                        child: Image.file(
                          selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : DottedBorder(
                        borderType: BorderType.RRect,
                        color: Pallete.borderColor,
                        strokeCap: StrokeCap.round,
                        dashPattern: const [10, 4],
                        child: const SizedBox(
                          width: double.infinity,
                          height: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.folder_open,
                                size: 40,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Select your thumbnail',
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              selectedAudio != null
                  ? const AudioWave(path: selectedAudio!.path)
                  : CustomField(
                      hintText: "Pick Song",
                      readOnly: true,
                      controller: null,
                      onTap: selecteAudio,
                    ),
              const SizedBox(height: 20),
              CustomField(
                hintText: "Artist",
                controller: _artistNameController,
              ),
              const SizedBox(height: 20),
              CustomField(
                hintText: "Song Name",
                controller: _songNameController,
              ),
              const SizedBox(height: 20),
              ColorPicker(
                pickersEnabled: const {
                  ColorPickerType.wheel: true,
                },
                color: _selectedColor,
                onColorChanged: (Color color) {
                  setState(() {
                    _selectedColor = color;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
