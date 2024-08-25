import 'dart:io';
import 'package:chat/services/services.dart';
import 'package:chat/view/Widgets/custom_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void snackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

bool passwordMatched(String password, String confirmPassword) {
  return password == confirmPassword;
}

Future<String?> getData(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<bool> isLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') == true;
}

String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  if (!emailRegex.hasMatch(value)) {
    return 'Enter a valid email';
  }
  return null;
}

final picker = ImagePicker();

showImagePicker(BuildContext context, Function(Image) setImage) async {
  if (Platform.isIOS) {
    const platform = MethodChannel('imagePickerOptionsChannel');
    try {
      final result = await platform.invokeMethod<int>('showImagePickerOptions');
      switch (result) {
        case 1:
          imagePick(ImageSource.camera, setImage);
          break;
        case 2:
          imagePick(ImageSource.gallery, setImage);
          break;
      }
    } on PlatformException catch (error) {
      print('Error in showImagePicker: $error');
    }
  } else {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return CustomButtomSheet_imgPick(setImage: setImage);
      },
    );
  }
}

imagePick(ImageSource source, Function(Image) setImage) async {
  await picker.pickImage(source: source, imageQuality: 50).then((value) {
    if (value != null) {
      cropImage(File(value.path), setImage);
    } else {
      print('No image selected');
    }
  });
}

cropImage(File imgFile, Function(Image) setImage) async {
  final croppedFile = await ImageCropper().cropImage(
      sourcePath: imgFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: "Edit Photo",
            toolbarColor: Colors.green,
            toolbarWidgetColor: Colors.white,
            statusBarColor: Colors.green,
            activeControlsWidgetColor: Colors.green,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: "Edit Photo",
        )
      ]);

  if (croppedFile != null) {
    imageCache.clear();
    await uploadImage(croppedFile);
    setImage(Image.file(File(croppedFile.path)));
    
  }
}


Future<void> saveProfilePicture(String profilePicUrl) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('profilePic', profilePicUrl);
}

Future<String?> loadProfilePicture() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('profilePicture');
}

String getTimeNow() {
  
  int hour = DateTime.now().hour;
  final minute = DateTime.now().minute;
  String pmOrAm = hour > 12 ? 'PM' : 'AM';
  hour = hour > 12 ? hour - 12 : hour;
  return '$hour:$minute $pmOrAm';
}

String handleTimeFromDB(String dbtime) {
  if (dbtime == null || dbtime.isEmpty) {
    return '';
  }
  String amOrPm = dbtime.substring(0, 2);
  int hour = int.parse(dbtime.substring(3, 5));
  hour++;
  hour = hour > 12 ? hour - 12 : hour;
  final minute = dbtime.substring(6, 8);
  return '$hour:$minute $amOrPm';
}
