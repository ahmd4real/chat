import 'package:bloc/bloc.dart';
import 'package:chat/view/Screens/home_page.dart';
import 'package:flutter/material.dart';

class ImageCubit extends Cubit<ImageState> {
  ImageCubit()
      : super(ImageState(
          avatarImg: profilePic!=null?
          Image.network('https://chat-app.runasp.net/$profilePic'):
          Image.asset('assets/images/avatar.png'),
         
        ));

  void setAvatarImg(Image image) {
    emit(state.copyWith(avatarImg: image));
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