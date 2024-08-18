import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/features/app/global/date/date_formats.dart';
import 'package:whatsapp_clone/features/app/global/widgets/profile_widget.dart';
import 'package:whatsapp_clone/features/app/theme/style.dart';

class CallsHistoryScreen extends StatelessWidget {
  const CallsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
              child: Text(
                "Recent",
                style: TextStyle(
                    fontSize: 15.sp,
                    color: greyColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            ListView.builder(
                itemCount: 20,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Container(
                      width: 55.w,
                      height: 55.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30.r),
                        child: profileWidget(),
                      ),
                    ),
                    title: Text(
                      "UserName",
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Row(
                      children: [
                        Icon(
                          Icons.call_made,
                          color: Colors.green,
                          size: 19.sp,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          formatDateTime(DateTime.now()),
                          style: TextStyle(fontSize: 14.sp, color: greyColor),
                        )
                      ],
                    ),
                    trailing: const Icon(
                      Icons.call,
                      color: tabColor,
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
