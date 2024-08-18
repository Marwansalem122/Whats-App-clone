import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/features/app/global/widgets/profile_widget.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Select Contacts"),
      ),
      body: ListView.builder(
          itemCount: 20,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
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
                  "Hey there! i'm using whatsApp",
                )
            );
          }),
    );
  }
}
