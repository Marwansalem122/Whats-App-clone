import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/features/app/global/widgets/profile_widget.dart';
import 'package:timeago/timeago.dart' as time_ago;
import 'package:whatsapp_clone/features/app/theme/style.dart';

class MyStatusScreen extends StatefulWidget {
  const MyStatusScreen({super.key});

  @override
  State<MyStatusScreen> createState() => _MyStatusScreenState();
}

class _MyStatusScreenState extends State<MyStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Status"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
        child: Column(
          children: [
            Row(
              children: [
                Container(
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
                SizedBox(
                  width: 15.w,
                ),
                Expanded(
                    child: Text(time_ago.format(DateTime.now()
                        .subtract(Duration(seconds: DateTime.now().second))))),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: greyColor.withOpacity(.5),
                  ),
                  color: appBarColor,
                  iconSize: 28.sp,
                  onSelected: (value) {},
                  itemBuilder: (context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: "Delete",
                      child: GestureDetector(
                        onTap: () {},
                        child: const Text('Delete'),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
