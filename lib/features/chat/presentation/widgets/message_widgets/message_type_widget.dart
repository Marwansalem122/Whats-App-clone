
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/const/message_type_const.dart';
import '../../../../app/global/widgets/profile_widget.dart';
import '../../../../app/theme/style.dart';
import 'message_audio_widget.dart';
import 'message_video_widget.dart';

class MessageTypeWidget extends StatelessWidget {
  final String? type;
  final String? message;
  const MessageTypeWidget({Key? key, this.type, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(type == MessageTypeConst.textMessage) {
      return Text(
        "$message",
        style:  TextStyle(color: Colors.white, fontSize: 16.sp,),
      );
    } else if (type == MessageTypeConst.photoMessage) {
      return Container(
        padding:  EdgeInsets.only(bottom: 20.h),
        child: profileWidget(
          imageUrl: message
        ),
      );
    } else if (type == MessageTypeConst.videoMessage) {
      return Container(
          padding:  EdgeInsets.only(bottom: 20.h),
          child: CachedVideoMessageWidget(url: message!));
    } else if (type == MessageTypeConst.gifMessage) {
      return Container(
        padding:  EdgeInsets.only(bottom: 20.h),
        child: CachedNetworkImage(imageUrl: message!,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),),
      );
    } else if (type == MessageTypeConst.audioMessage) {
      return MessageAudioWidget(audioUrl: message,);
    } else {
      return Text(
        "$message", maxLines: 2,
        style: const TextStyle(color: greyColor, fontSize: 12, overflow: TextOverflow.ellipsis),
      );
    }
  }
}
