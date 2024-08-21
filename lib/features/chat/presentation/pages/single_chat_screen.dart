import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp_clone/features/app/theme/style.dart';

class SingleChatScreen extends StatefulWidget {
  const SingleChatScreen({super.key});

  @override
  State<SingleChatScreen> createState() => _SingleChatScreenState();
}

class _SingleChatScreenState extends State<SingleChatScreen> {
  final TextEditingController _textMessageController = TextEditingController();
  bool _isDisplayButton = false;
  bool _isShowAttachWindow = false;

  @override
  void dispose() {
    _textMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text("UserName"),
            Text(
              "Online",
              style: TextStyle(
                  fontSize: 11.sp,
                  color: greyColor,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.videocam_rounded,
              size: 25.sp,
            ),
          ),
          Icon(
            Icons.call,
            size: 22.sp,
          ),
          SizedBox(
            width: 25.w,
          ),
          Icon(
            Icons.more_vert,
            size: 22.sp,
          ),
          SizedBox(
            width: 15.w,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          _isShowAttachWindow = false;
        },
        child: Stack(
          children: [
            Positioned(
              left: 0.w,
              right: 0.w,
              bottom: 0.h,
              top: 0.h,
              child: Image.asset("assets/images/whatsapp_bg_image.png",
                  fit: BoxFit.cover),
            ),
            Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      _messageLayout(
                        alignment: Alignment.centerRight,
                        createAt: Timestamp.now(),
                        onSwipe: () {},
                        message: "Hi",
                        // messageType: "text",
                        isShowTick: true,
                        isSeen: false,
                        onLongPress: () {},
                        messageBgColor: messageColor,
                      ),
                      _messageLayout(
                        alignment: Alignment.centerLeft,
                        createAt: Timestamp.now(),
                        onSwipe: () {},
                        message: "How are you?",
                        // messageType: "text",
                        isShowTick: false,
                        isSeen: false,
                        onLongPress: () {},
                        messageBgColor: senderMessageColor,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 10.w, right: 10.w, top: 5.h, bottom: 5.h),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        decoration: BoxDecoration(
                            color: appBarColor,
                            borderRadius: BorderRadius.circular(25.r)),
                        height: 50.h,
                        child: TextField(
                          controller: _textMessageController,
                          onTap: () {
                            setState(() {
                              _isShowAttachWindow = false;
                            });
                          },
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                _isDisplayButton = true;
                              });
                            } else {
                              setState(() {
                                _isDisplayButton = false;
                              });
                            }
                          },
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 15.h),
                              prefixIcon: const Icon(
                                Icons.emoji_emotions,
                                color: greyColor,
                              ),
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(top: 12.0.h),
                                child: Wrap(
                                  children: [
                                    //to make icon diagonal
                                    Transform.rotate(
                                        angle: -0.5,
                                        child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _isShowAttachWindow =
                                                    !_isShowAttachWindow;
                                              });
                                            },
                                            child:
                                                const Icon(Icons.attach_file))),
                                    SizedBox(
                                      width: 15.w,
                                    ),
                                    const Icon(
                                      Icons.camera_alt,
                                      color: greyColor,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                  ],
                                ),
                              ),
                              hintText: "Message",
                              border: InputBorder.none),
                        ),
                      )),
                      SizedBox(width: 10.w),
                      Container(
                          width: 50.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                              color: tabColor,
                              borderRadius: BorderRadius.circular(25.r)),
                          child: Center(
                            child: Icon(
                              _isDisplayButton == true
                                  ? Icons.send_outlined
                                  : Icons.mic_none_rounded,
                              color: Colors.white,
                            ),
                          ))
                    ],
                  ),
                ),
              ],
            ),
            _isShowAttachWindow
                ? Positioned(
                    top: 230.h,
                    bottom: 65.h,
                    left: 15.w,
                    right: 15.w,
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.20,
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 20.h),
                      decoration: BoxDecoration(
                          color: bottomAttachContainerColor,
                          borderRadius: BorderRadius.circular(10.r)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _attachWindowItem(
                                  icon: Icons.document_scanner,
                                  title: "Document",
                                  color: Colors.deepPurpleAccent),
                              _attachWindowItem(
                                  icon: Icons.camera_alt,
                                  title: "Camera",
                                  color: Colors.pinkAccent,
                                  onTap: () {}),
                              _attachWindowItem(
                                  icon: Icons.image,
                                  title: "Gallery",
                                  color: Colors.purpleAccent),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _attachWindowItem(
                                  icon: Icons.headphones,
                                  title: "Audio",
                                  color: Colors.deepOrange),
                              _attachWindowItem(
                                icon: Icons.location_on,
                                title: "Location",
                                color: Colors.green,
                              ),
                              _attachWindowItem(
                                  icon: Icons.account_circle,
                                  title: "Contact",
                                  color: Colors.deepPurpleAccent),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _attachWindowItem(
                                  icon: Icons.bar_chart,
                                  title: "Poll",
                                  color: tabColor),
                              _attachWindowItem(
                                  icon: Icons.gif_box_outlined,
                                  title: "Gif",
                                  color: Colors.indigoAccent,
                                  onTap: () {}),
                              _attachWindowItem(
                                  icon: Icons.videocam_rounded,
                                  title: "Video",
                                  color: Colors.lightGreen,
                                  onTap: () {}),
                            ],
                          ),
                        ],
                      ),
                    ))
                : Container()
          ],
        ),
      ),
    );
  }

  _messageLayout({
    Color? messageBgColor,
    Alignment? alignment,
    Timestamp? createAt,
    VoidCallback? onSwipe,
    String? message,
    String? messageType,
    bool? isShowTick,
    bool? isSeen,
    VoidCallback? onLongPress,
    // double? rightPadding
  }) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: SwipeTo(
            onRightSwipe: (details) {
              if (onSwipe != null) {
                onSwipe();
              }
            },
            child: GestureDetector(
                onLongPress: onLongPress,
                child: Container(
                  alignment: alignment,
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10.h),
                        padding: EdgeInsets.only(
                            left: 5.w, right: 85.w, top: 5.h, bottom: 5.h),
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.80),
                        decoration: BoxDecoration(
                          color: messageBgColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          "$message",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Positioned(
                        bottom: 4.h,
                        right: 10.w,
                        child: Row(
                          children: [
                            Text(DateFormat.jm().format(createAt!.toDate()),
                                style: TextStyle(
                                    fontSize: 12.sp, color: lightGreyColor)),
                            SizedBox(
                              width: 5.w,
                            ),
                            isShowTick == true
                                ? Icon(
                                    isSeen == true
                                        ? Icons.done_all
                                        : Icons.done,
                                    size: 16.sp,
                                    color: isSeen == true
                                        ? Colors.blue
                                        : lightGreyColor,
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ],
                  ),
                ))));
  }

  _attachWindowItem(
      {required IconData icon,
      required String title,
      required Color color,
      VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 55.w,
            height: 55.h,
            padding: EdgeInsets.all(10.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.r), color: color),
            child: Icon(icon),
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            title,
            style: TextStyle(color: greyColor, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}
