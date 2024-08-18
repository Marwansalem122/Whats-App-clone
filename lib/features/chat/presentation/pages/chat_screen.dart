import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/features/app/global/widgets/profile_widget.dart';
import 'package:whatsapp_clone/features/app/theme/style.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ListView.builder(
      itemCount:20 ,
      itemBuilder: (context, index) {
      return ListTile(
        leading: SizedBox(
          width: 50.w,
          height: 50.h,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: profileWidget(),
          ),
        ),
        title: const Text("UserName"),
        subtitle:const Text(
          "Last message Hi",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          DateFormat.jm().format(DateTime.now()),
          style:  TextStyle(color: greyColor, fontSize: 13.sp),
        ),
      );
    }));
  }
}
