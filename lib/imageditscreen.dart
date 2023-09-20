import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:gdsc/dialogbox.dart';
import 'package:gdsc/filters.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class EditScreen extends StatefulWidget {
  String selectedImage;
  EditScreen({super.key, required this.selectedImage});

  @override
  State<EditScreen> createState() => _EdState();
}

class _EdState extends State<EditScreen> {
  List<double> filtername = origin;
  ScreenshotController screenshotController = ScreenshotController();
  String? em;
  Future<void> captureAndSaveScreenshot(context) async {
    try {
      final Uint8List? imageFile = await screenshotController.capture();
      await [Permission.storage].request();
      final time = DateTime.now()
          .toIso8601String()
          .replaceAll(":", "-")
          .replaceAll(".", "-");

      if (imageFile != null) {
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/EditedImage$time.png');
        await tempFile.writeAsBytes(imageFile);

        final result =
            await GallerySaver.saveImage(tempFile.path, toDcim: true);

        if (result != null) {
          em = "Image saved successfully";
        } else {
          em = "Failed to save Editted Image";
        }
      }
    } catch (e) {
      em = "Error capturing and saving Editted Image";
    }
    showAlertDialog(context, result: em);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          title: const Text(
            "Select Filter",
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  final image = await screenshotController.capture();
                  if (image == null) return;

                  await captureAndSaveScreenshot(context);
                },
                icon: const Icon(Icons.save_alt_rounded))
          ]),
      body: Container(
        constraints:
            BoxConstraints(maxWidth: size.width, maxHeight: size.height),
        child: Column(children: [
          Expanded(
            flex: 1,
            child: Screenshot(
              controller: screenshotController,
              child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(filtername),
                  child: Image.file(File(widget.selectedImage))),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RawMaterialButton(
                    onPressed: () {
                      filtername = origin;
                      setState(() {});
                    },
                    child: const Text(
                      "Original",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      filtername = SEPIA_MATRIX;
                      setState(() {});
                    },
                    child: const Text(
                      "Sepia",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      filtername = VINTAGE_MATRIX;
                      setState(() {});
                    },
                    child: const Text(
                      "Vintage",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      filtername = GREYSCALE_MATRIX;
                      setState(() {});
                    },
                    child: const Text(
                      "GreyScale",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      filtername = FILTER_1;
                      setState(() {});
                    },
                    child: const Text(
                      "Misc",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
