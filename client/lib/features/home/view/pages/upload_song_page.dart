import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:dotted_border/dotted_border.dart';
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DottedBorder(
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
                      SizedBox(height: 10),
                      Text(
                        'Drag and drop your song here',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomField(
                hintText: "Pick Song",
                readOnly: true,
                controller: null,
                onTap: () {},
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
            ],
          ),
        ),
      ),
    );
  }
}
