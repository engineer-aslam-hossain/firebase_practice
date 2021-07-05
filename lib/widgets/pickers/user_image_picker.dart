import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickerFn);

  final void Function(File file) imagePickerFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  final ImagePicker _picker = ImagePicker();

  File? file;

  void _pickImage() async {
    //
    try {
      final pickedFile = await _picker.getImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 250,
      );

      setState(() {
        file = File(pickedFile!.path);
      });

      widget.imagePickerFn(File(pickedFile!.path));
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 42,
          backgroundColor: Theme.of(context).primaryColor,
          child: CircleAvatar(
            radius: 40,
            backgroundImage: file == null ? null : FileImage(file!),
            backgroundColor: Colors.grey[200],
          ),
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text('Add Image'),
        ),
      ],
    );
  }
}
