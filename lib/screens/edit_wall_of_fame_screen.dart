import 'dart:io';

// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:divine_circle/providers/members.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
// import 'package:path_provider/path_provider.dart' as syspaths;
// import 'package:path/path.dart' as path;

class EditWallOfFameScreen extends StatefulWidget {
  const EditWallOfFameScreen({Key? key}) : super(key: key);

  static const routeName = '/edit-wall-of-fame';

  @override
  State<EditWallOfFameScreen> createState() => _EditWallOfFameScreenState();
}

class _EditWallOfFameScreenState extends State<EditWallOfFameScreen> {
  File? _storedImage;

  final _newMember = User(
      id: DateTime.now().toString(),
      name: '',
      phoneNumber: 0,
      image: File(''),
      designation: '');

  Future<void> _selectPicture() async {
    final imageFile =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    if (imageFile == null) {
      return;
    }

    final croppedImage = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'It\'s Cropper baby',
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    setState(() {
      // _storedImage = File(imageFile.path);
      _storedImage = croppedImage;
    });
    //print('Image stored is $_storedImage');
    _newMember.image = _storedImage!;

    Navigator.of(context).pop();
  }

  Future<void> _takePicture() async {
    final imageFile = await ImagePicker.platform.pickImage(
      source: ImageSource.camera,
      //maxWidth: 600,
    );
    if (imageFile == null) {
      return;
    } else {}
    setState(() {
      _storedImage = File(imageFile.path);
    });
    // final appDir = syspaths.getApplicationDocumentsDirectory();
    // final fileName = path.basename(imageFile.path);
    // final savedImage = await File(imageFile.path).copy('$appDir/$fileName');
    // _storedImage = savedImage;
    // print('Image stored is $_storedImage');
    _newMember.image = _storedImage!;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey();

    void _saveForm() {
      final isValid = _formKey.currentState!.validate();

      if (!isValid) {
        return;
      }
      _formKey.currentState!.save();

      Provider.of<Members>(context, listen: false).addnewMember(_newMember);
      //print(_newMember.id);

      Navigator.of(context).pop();
    }

    void _startPickingImage() {
      showModalBottomSheet(
        context: context,
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: IconButton(
                          color: Colors.white,
                          onPressed: _takePicture,
                          icon: const Icon(Icons.camera_alt_outlined),
                        ),
                      ),
                      const Text('Camera'),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: IconButton(
                          color: Colors.white,
                          onPressed: _selectPicture,
                          icon: const Icon(Icons.image_outlined),
                        ),
                      ),
                      const Text('Gallery'),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Fame List',
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
        elevation: 0,
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: SingleChildScrollView(
          child: Form(
            //autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 4),
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey,
                        foregroundImage: _storedImage != null
                            ? FileImage(_storedImage!)
                            : null,
                        child: _storedImage == null
                            ? Text(
                                'Upload Image',
                                style: GoogleFonts.inter(color: Colors.white),
                              )
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: IconButton(
                          color: Colors.white,
                          onPressed: _startPickingImage,
                          icon: const Icon(Icons.add),
                        ),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      label: Text('Enter name',
                          style:
                              GoogleFonts.inter(fontWeight: FontWeight.w400))),
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '* required';
                    }

                    return null;
                  },
                  onSaved: (name) {
                    _newMember.name = name!;
                  },
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      label: Text('Phone Number',
                          style:
                              GoogleFonts.inter(fontWeight: FontWeight.w400))),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '* required';
                    }

                    if (value.length < 10 || value.length > 10) {
                      return '* Enter a valid phone number';
                    }
                    return null;
                  },
                  onSaved: (phNo) {
                    _newMember.phoneNumber = int.parse(phNo!);
                  },
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      label: Text('Designation',
                          style:
                              GoogleFonts.inter(fontWeight: FontWeight.w400))),
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '* required';
                    }
                    return null;
                  },
                  onSaved: (designation) {
                    _newMember.designation = designation!;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
