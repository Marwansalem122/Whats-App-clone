


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:giphy_picker/giphy_picker.dart';
import 'package:whatsapp_clone/features/app/theme/style.dart';


void toast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: tabColor,
      textColor: whiteColor,
      fontSize: 16.0);
}

Future<GiphyGif?> pickGIF(BuildContext context) async {
  GiphyGif? gif;
  try {
    gif = await GiphyPicker.pickGif(
        context: context,
        fullScreenDialog: false,
        showPreviewPage:false, // مش هتخليك تفتح الشكل المتحرك في صفحة لوحده
        apiKey:"AppOY52uutS3IReGLzQx0zlV8jh7g02g");
        // 'kLu4PIKAwS2ys47Ji7oWUIr2iZbEoj1k';


  } catch (e) {
    toast(e.toString());
  }

  return gif;
}
