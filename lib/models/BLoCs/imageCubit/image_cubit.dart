import 'package:bloc/bloc.dart';
import 'package:chat/core/utils/constants.dart';
import 'package:chat/core/utils/utilities.dart';
import 'package:flutter/material.dart';

class ImageCubit extends Cubit<ImageState> {
  ImageCubit({String? profilePic})
      : super(ImageState(
          avatarImg: profilePic != null && profilePic.isNotEmpty
              ? Image.network('https://chat-app.runasp.net/$profilePic')
              : Image.asset(kAvatar),
        ));

  void setAvatarImg(Image image) {
    emit(state.copyWith(avatarImg: image));
  }

  void updateProfilePicture(String profilePic) async {
    await saveProfilePicture(profilePic); // Save the new profile picture URL to SharedPreferences
    emit(state.copyWith(
        avatarImg: Image.network('https://chat-app.runasp.net/$profilePic')));
  }
}


class ImageState {
  final Image avatarImg;

  ImageState({
    required this.avatarImg,
  });

  ImageState copyWith({
    Image? avatarImg,
  }) {
    return ImageState(
      avatarImg: avatarImg ?? this.avatarImg,
    );
  }
}
