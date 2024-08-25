
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/features/app/global/widgets/profile_widget.dart';
import 'package:whatsapp_clone/features/app/helpers/extensions.dart';
import 'package:whatsapp_clone/features/app/routing/routes.dart';
import 'package:whatsapp_clone/features/app/theme/style.dart';
import 'package:whatsapp_clone/features/user/domain/entities/contact_entity.dart';
import 'package:whatsapp_clone/features/user/presentation/cubit/get_device_number/get_device_number_cubit.dart';
import 'dart:typed_data';

import '../../chat/domain/entities/message_entity.dart';
import '../../user/presentation/cubit/get_single_user/get_single_user_cubit.dart';
import '../../user/presentation/cubit/user/user_cubit.dart';
import '../const/page_const.dart';
class ContactsScreen extends StatefulWidget {
  final String uid;
  const ContactsScreen({super.key, required this.uid});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid: widget.uid);
    BlocProvider.of<UserCubit>(context).getAllUsers();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Contacts"),
      ),
      body: BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
        builder: (context, state) {
          if(state is GetSingleUserLoaded) {
            final currentUser = state.singleUser;
            print("1");

            return BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                if (state is UserLoaded) {
                  final contacts = state.users.where((user) => user.uid != widget.uid).toList();


                  if (contacts.isEmpty) {
                    return const Center(
                      child: Text("No Contacts Yet"),
                    );
                  }

                  return ListView.builder(itemCount: contacts.length, itemBuilder: (context, index) {
                    final contact = contacts[index];

                    return ListTile(
                      onTap: () {
                        // context.pushNamed( Routes.singleChatScreen,
                        //     arguments: MessageEntity(
                        //         senderUid: currentUser.uid,
                        //         recipientUid: contact.uid,
                        //         senderName: currentUser.username,
                        //         recipientName: contact.username,
                        //         senderProfile: currentUser.profileUrl,
                        //         recipientProfile: contact.profileUrl,
                        //         uid: widget.uid
                        //     ));
                      },
                      leading: SizedBox(
                        width: 50.w,
                        height: 50.h,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(25.r),
                            child: profileWidget(imageUrl: contact.profileUrl)
                        ),
                      ),
                      title: Text("${contact.username}"),
                      subtitle: Text("${contact.status}"),
                    );
                  });
                }
                return const Center(
                  child: CircularProgressIndicator(
                    color: tabColor,
                  ),
                );

              },

            );

          }
          return const Center(
            child: CircularProgressIndicator(
              color: tabColor,
            ),
          );
        },
      ),
    );
  }
}