
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/features/app/global/widgets/profile_widget.dart';

import '../../theme/style.dart';

showImagePickedBottomModalSheet(BuildContext context, {File? file, VoidCallback? onTap, String? recipientName}) {
  showModalBottomSheet(
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    context: context,
    builder: (context) {
      return Container(
        color: backgroundColor,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: profileWidget(
                image: file,
              ),
            ),

            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 15.w, vertical: 40.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(onTap: () {
                      Navigator.pop(context);
                    },child:  Icon(Icons.close_outlined, size: 30.sp, color: Colors.white,)),
                     Row(
                      children: [
                        Icon(Icons.crop, size: 30.sp, color: Colors.white,),
                        SizedBox(width: 20.w,),
                        Icon(Icons.emoji_emotions_outlined, size: 30.sp, color: Colors.white,),
                        SizedBox(width: 20.w,),
                        Icon(Icons.text_fields, size: 30.sp, color: Colors.white,),
                        SizedBox(width: 20.w,),
                        Icon(Icons.edit_outlined, size: 30.sp, color: Colors.white,),
                      ],
                    )
                  ],
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: appBarColor,
                      ),
                      child: Text("$recipientName"),
                    ),
                    GestureDetector(
                      onTap: onTap,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: tabColor),
                        child: const Center(
                          child: Icon(
                            Icons.send_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
