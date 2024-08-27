
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/features/app/home/contacts_screen.dart';

import '../../../../app/const/message_type_const.dart';
import '../../../../app/global/widgets/profile_widget.dart';
import '../../../../app/theme/style.dart';
import 'message_video_widget.dart';

class MessageReplayTypeWidget extends StatelessWidget {
  final String? type;
  final String? message;
  const MessageReplayTypeWidget({Key? key, this.type, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(type == MessageTypeConst.textMessage) {
      return Text(
        "$message", maxLines: 2,
        style:  TextStyle(color: greyColor, fontSize: 12.sp, overflow: TextOverflow.ellipsis),
      );
    } else if (type == MessageTypeConst.photoMessage) {
      return Row(
        children: [
           SizedBox(width: 200.w,child: const Text("Photo")),
          SizedBox(
            width: 50.w,
            height: 50.h,
            child: profileWidget(
                imageUrl: message
            ),
          ),
        ],
      );
    } else if (type == MessageTypeConst.videoMessage) {
      return Row(
        children: [
          const SizedBox(width: 200,child: Text("Video")),
          SizedBox(width: 50.w, height: 50.h,child: CachedVideoMessageWidget(url: message!)),
        ],
      );
    } else if (type == MessageTypeConst.gifMessage) {
      return Row(
        children: [
           SizedBox(width: 200.w,child:const Text("GIF")),
          SizedBox(
            width: 50,
            height: 50,
            child: CachedNetworkImage(imageUrl: message!,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),),
          ),
        ],
      );
    } else if (type == MessageTypeConst.audioMessage) {
      return  Row(
        children: [
          Icon(
            Icons.play_circle,
            size: 40.sp,
            color: greyColor,
          ),
          SizedBox(width: 10.w,),
          SizedBox(
            width: 190.w,
            height: 2.h,
            child: const LinearProgressIndicator(
              value: 0,
              backgroundColor: greyColor,
            ),
          ),
        ],
      );
    } else {
      return Text(
        "$message", maxLines: 2,
        style:  TextStyle(color: greyColor, fontSize: 12.sp, overflow: TextOverflow.ellipsis),
      );
    }
  }
}
