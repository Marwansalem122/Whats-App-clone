import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/features/app/global/date/date_formats.dart';
import 'package:whatsapp_clone/features/app/global/widgets/profile_widget.dart';
import 'package:whatsapp_clone/features/app/theme/style.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 10.h),
                        width: 60.w,
                        height: 60.h,
                        // decoration: const BoxDecoration(
                        //     shape: BoxShape.circle, color: tabColor),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.r),
                          child: profileWidget(),
                        )),
                    Positioned(
                        right: 10.h,
                        bottom: 8.h,
                        child: Container(
                          width: 25.w,
                          height: 25.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.r),
                              border:
                                  Border.all(width: 2, color: backgroundColor),
                              color: tabColor),
                          child: const Center(
                              child: Icon(
                            Icons.add,
                            size: 20,
                          )),
                        ))
                  ],
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("My Status", style: TextStyle(fontSize: 16.sp)),
                    SizedBox(height: 2.h),
                    const Text("Tap to add status update",
                        style: TextStyle(color: greyColor))
                  ],
                ))
              ],
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Text("Recent updates",
                  style: TextStyle(
                      fontSize: 15.sp,
                      color: greyColor,
                      fontWeight: FontWeight.w500)),
            ),
            SizedBox(height: 10.h),
            ListView.builder(
                itemCount: 10,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                      leading: Container(
                    margin: const EdgeInsets.all(3),
                    width: 55.w,
                    height: 55.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25.r),
                      child: profileWidget(),
                    ),
                  ),
                title: Text("UserName",style:TextStyle(fontSize: 16.sp)),
                subtitle:  Text(formatDateTime(DateTime.now()),style:const TextStyle(color: greyColor),),
                  );
                })
          ],
        ),
      ),
    );
  }
}
