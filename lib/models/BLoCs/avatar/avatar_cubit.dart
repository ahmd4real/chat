import 'dart:io';
//import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:chat/models/BLoCs/ImageCubit/image_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
//import 'dart:io'; // For File
import 'package:flutter/material.dart'; // For Image widget


part 'avatar_state.dart';

class AvatarCubit extends Cubit<AvatarState> {
  final ImageCubit imageCubit;

  AvatarCubit(this.imageCubit) : super(AvatarInitial());

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> imagePick(ImageSource source) async {
    try {
      final pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        imageCubit.setAvatarImg(Image.file(File(pickedImage.path)));
        emit(AvatarChangedState(imgPath: pickedImage.path));
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
