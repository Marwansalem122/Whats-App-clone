import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/features/app/global/widgets/profile_widget.dart';
import 'package:whatsapp_clone/features/app/helpers/extensions.dart';
import 'package:whatsapp_clone/features/app/routing/routes.dart';
import 'package:whatsapp_clone/features/app/theme/style.dart';

import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../cubit/chat/chat_cubit.dart';

class ChatScreen extends StatefulWidget {
  final String uid;
  const ChatScreen({super.key, required this.uid});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    BlocProvider.of<ChatCubit>(context).getMyChat(chat: ChatEntity(senderUid: widget.uid));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            if(state is ChatLoaded) {
              final myChat = state.chatContacts;

              if(myChat.isEmpty) {
                return const Center(
                  child: Text("No Conversation Yet"),
                );
              }

              return ListView.builder(itemCount: myChat.length, itemBuilder: (context, index) {

                final chat = myChat[index];
                return GestureDetector(
                  onTap: () {
                    context.pushNamed( Routes.singleChatScreen,
                        arguments: MessageEntity(
                            senderUid: chat.senderUid,
                            recipientUid:chat.recipientUid,
                            senderName: chat.senderName,
                            recipientName: chat.recipientName,
                            senderProfile: chat.senderProfile,
                            recipientProfile: chat.recipientProfile,
                            uid: widget.uid
                        ));
                  },
                  child: ListTile(
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: profileWidget(imageUrl: chat.recipientProfile),
                      ),
                    ),
                    title: Text("${chat.recipientName}"),
                    subtitle: Text("${chat.recentTextMessage}", maxLines: 1, overflow: TextOverflow.ellipsis,),
                    trailing: Text(
                      DateFormat.jm().format(chat.createdAt!.toDate()),
                      style: const TextStyle(color: greyColor, fontSize: 13),
                    ),
                  ),
                );
              });

            }
            return const Center(
              child: CircularProgressIndicator(
                color: tabColor,
              ),
            );
          },
        )
    );
  }
}