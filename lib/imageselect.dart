import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gdsc/dialogbox.dart';
import 'package:gdsc/imageditscreen.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelect extends StatefulWidget {
  const ImageSelect({super.key});

  @override
  State<ImageSelect> createState() => _ImageSelectState();
}

class _ImageSelectState extends State<ImageSelect> {
  ImagePicker picker = ImagePicker();
  XFile? image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "PhotoEditor",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          alignment: Alignment.center,
          child: Column(children: [
            Container(
              height: MediaQuery.of(context).size.height / 1.5,
              child: Expanded(
                child: image == null
                    ? Image.asset("assets/images/placeholder.png")
                    : Image.file(File(image!.path)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  image = await picker.pickImage(source: ImageSource.gallery);
                  setState(() {});
                },
                child: const Text("Pick Image")),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  if (image != null) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditScreen(
                              selectedImage: image!.path,
                            )));
                  } else {
                    showAlertDialog(context, result: "Please Select Image");
                  }
                },
                child: const Text("Apply Filter")),
          ]),
        ));
  }
}
