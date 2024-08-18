import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/features/app/global/widgets/profile_widget.dart';
import 'package:whatsapp_clone/features/app/theme/style.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Row(
              children: [
                SizedBox(
                  width: 60.w,
                  height: 60.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32.r),
                    child: profileWidget(),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "UserName",
                      style: TextStyle(fontSize: 15.sp),
                    ),
                    const Text(
                      "While true { code() }",
                      style: TextStyle(color: greyColor),
                    )
                  ],
                )),
                Icon(
                  Icons.qr_code_sharp,
                  color: tabColor,
                  size: 25.sp,
                )
              ],
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Container(
            width: double.infinity,
            height: 0.5.h,
            color: greyColor.withOpacity(0.4),
          ),
          SizedBox(
            height: 10.h,
          ),
          _settingsItemWidget(
              title: "Account",
              description: "Security applications, change number",
              icon: Icons.key,
              onTap: () {}),
          _settingsItemWidget(
              title: "Privacy",
              description: "Block contacts, disappearing messages",
              icon: Icons.lock,
              onTap: () {}),
          _settingsItemWidget(
              title: "Chats",
              description: "Theme, wallpapers, chat history",
              icon: Icons.message,
              onTap: () {}),
          _settingsItemWidget(
              title: "Logout",
              description: "Logout from WhatsApp Clone",
              icon: Icons.exit_to_app,
              onTap: () {
                // displayAlertDialog(
                //     context,
                //     onTap: () {
                //       BlocProvider.of<AuthCubit>(context).loggedOut();
                //       Navigator.pushNamedAndRemoveUntil(context, PageConst.welcomePage, (route) => false);
                //     },
                //     confirmTitle: "Logout",
                //     content: "Are you sure you want to logout?"
                // );
              }),
        ],
      ),
    );
  }
}

_settingsItemWidget(
    {String? title, String? description, IconData? icon, VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Row(
      children: [
        SizedBox(
            width: 80.w,
            height: 80.h,
            child: Icon(
              icon,
              color: greyColor,
              size: 25.sp,
            )),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$title",
                style: TextStyle(fontSize: 17.sp),
              ),
              SizedBox(
                height: 3.h,
              ),
              Text(
                "$description",
                style: const TextStyle(color: greyColor),
              )
            ],
          ),
        )
      ],
    ),
  );
}
