import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/features/app/global/widgets/profile_widget.dart';
import 'package:whatsapp_clone/features/app/helpers/extensions.dart';
import 'package:whatsapp_clone/features/app/routing/routes.dart';
import 'package:whatsapp_clone/features/app/theme/style.dart';
import 'package:whatsapp_clone/features/user/presentation/cubit/get_single_user/get_single_user_cubit.dart';

import '../../user/presentation/cubit/auth/auth_cubit.dart';
import '../global/widgets/dialog_widget.dart';

class SettingsScreen extends StatefulWidget {
  final String uid;
  const SettingsScreen({super.key, required this.uid});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid:widget. uid);
    super.initState();
  }
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
            child: BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
                builder: (context, state) {
              if (state is GetSingleUserLoaded) {
                final singleUser = state.singleUser;
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(Routes.editProfileScreen,arguments: singleUser);
                      },
                      child: SizedBox(
                        width: 60.w,
                        height: 60.h,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32.5.r),
                          child: profileWidget(imageUrl: singleUser.profileUrl),
                        ),
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
                          singleUser.username.toString(),
                          style: TextStyle(fontSize: 15.sp),
                        ),
                        Text(
                          singleUser.status.toString(),
                          style: const TextStyle(color: greyColor),
                        )
                      ],
                    )),
                    Icon(
                      Icons.qr_code_sharp,
                      color: tabColor,
                      size: 25.sp,
                    )
                  ],
                );
              }
              return Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.pushNamed(Routes.editProfileScreen);
                    },
                    child: SizedBox(
                      width: 65.w,
                      height: 65.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32.5),
                        child: profileWidget(),
                      ),
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
                          "...",
                          style: TextStyle(fontSize: 15.sp),
                        ),
                        const Text(
                          "...",
                          style: TextStyle(color: greyColor),
                        )
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.qr_code_sharp,
                    color: tabColor,
                  )
                ],
              );
            }),
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
                displayAlertDialog(context, onTap: () {
                  BlocProvider.of<AuthCubit>(context).loggedOut();
                  context.pushNamedAndRemoveUntil(Routes.welcomeScreen);
                },
                    confirmTitle: "Logout",
                    content: "Are you sure you want to logout?");
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
