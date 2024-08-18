import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/features/app/theme/style.dart';

Widget btnWidget({required String textButton,required VoidCallback onTap,required double width,required double height}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.only(bottom: 20.h),
      width: width,
      height:height,
      decoration: BoxDecoration(
        color: tabColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child:  Center(
        child: Text(
          textButton,
          style: TextStyle(
              color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w500),
        ),
      ),
    ),
  );
}
