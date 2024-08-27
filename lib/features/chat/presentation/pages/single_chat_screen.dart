import 'dart:io';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp_clone/features/app/const/message_type_const.dart';
import 'package:whatsapp_clone/features/app/helpers/extensions.dart';
import 'package:whatsapp_clone/features/app/theme/style.dart';
import 'package:whatsapp_clone/features/chat/domain/entities/chat_entity.dart';
import 'package:whatsapp_clone/features/chat/presentation/cubit/message/message_cubit.dart';
import '../../../../storage/storage_provider.dart';
import '../../../app/const/app_const.dart';
import '../../../app/global/widgets/dialog_widget.dart';
import '../../../app/global/widgets/profile_widget.dart';
import '../../../app/global/widgets/show_image_picked_widget.dart';
import '../../../app/global/widgets/show_video_picked_widget.dart';
import '../../../user/presentation/cubit/get_single_user/get_single_user_cubit.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/message_reply_entity.dart';
import '../widgets/chat_utils.dart';
import '../widgets/message_widgets/message_replay_preview_widget.dart';
import '../widgets/message_widgets/message_replay_type_widget.dart';
import '../widgets/message_widgets/message_type_widget.dart';

class SingleChatScreen extends StatefulWidget {
  final MessageEntity message;
  const SingleChatScreen({super.key, required this.message});

  @override
  State<SingleChatScreen> createState() => _SingleChatScreenState();
}

class _SingleChatScreenState extends State<SingleChatScreen> {
  final TextEditingController _textMessageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isDisplayButton = false;
  FocusNode focusNode = FocusNode();
  bool _isShowAttachWindow = false;
  FlutterSoundRecorder? _soundRecorder;
  bool _isRecording = false;
  bool _isRecordInit = false;
  bool _isDisplaySendButton = false;
  bool isShowEmojiKeyboard = false;
  void _hideEmojiContainer() {
    setState(() {
      isShowEmojiKeyboard = false;
    });
  }

  void _showEmojiContainer() {
    setState(() {
      isShowEmojiKeyboard = true;
    });
  }

  void _showKeyboard() => focusNode.requestFocus();
  void _hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboard() {
    if (isShowEmojiKeyboard) {
      _showKeyboard();
      _hideEmojiContainer();
    } else {
      _hideKeyboard();
      _showEmojiContainer();
    }
  }

  @override
  void initState() {
    _soundRecorder = FlutterSoundRecorder();
    _openAudioRecording();
    BlocProvider.of<GetSingleUserCubit>(context)
        .getSingleUser(uid: widget.message.recipientUid!);
    BlocProvider.of<MessageCubit>(context).getMessages(
        message: MessageEntity(
            senderUid: widget.message.senderUid,
            recipientUid: widget.message.recipientUid));

    super.initState();
  }

  Future<void> _openAudioRecording() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed!');
    }
    await _soundRecorder!.openRecorder();
    _isRecordInit = true;
  }

  @override
  void dispose() {
    _textMessageController.dispose();
    super.dispose();
  }

  File? _image;

  Future selectImage() async {
    setState(() => _image = null);
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print("no image has been selected");
        }
      });
    } catch (e) {
      toast("some error occurred $e");
    }
  }

  File? _video;

  Future selectVideo() async {
    setState(() => _image = null);
    try {
      final pickedFile =
          await ImagePicker().pickVideo(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _video = File(pickedFile.path);
        } else {
          print("no image has been selected");
        }
      });
    } catch (e) {
      toast("some error occurred $e");
    }
  }

  Future<void> _scrollToBottom() async {
    if (_scrollController.hasClients) {
      await Future.delayed(const Duration(milliseconds: 100));
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void onMessageSwipe(
      {String? message, String? username, String? type, bool? isMe}) {
    BlocProvider.of<MessageCubit>(context).setMessageReplay =
        MessageReplayEntity(
            message: message,
            username: username,
            messageType: type,
            isMe: isMe);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    final provider = BlocProvider.of<MessageCubit>(context);

    bool _isReplying = provider.messageReplay.message != null;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(top: 11.0.h),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 40.w,
                        height: 40.h,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(25.r),
                            child: profileWidget(
                                imageUrl: widget.message.recipientProfile)),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        widget.message.recipientName.toString(),
                        style: TextStyle(fontSize: 15.sp),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                top: 30.h,
                left: 50.w,
                child: Text(
                  widget.message.isSeen.toString() == null ? " " : "Online",
                  style: TextStyle(
                      fontSize: 9.sp,
                      color: widget.message.isSeen.toString() == null
                          ? greyColor
                          : tabColor,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.videocam_rounded,
              size: 25.sp,
            ),
          ),
          SizedBox(
            width: 20.w,
          ),
          Icon(
            Icons.call,
            size: 22.sp,
          ),
          SizedBox(
            width: 20.w,
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
      body: BlocBuilder<MessageCubit, MessageState>(builder: (context, state) {
        if (state is MessageLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
          final messages = state.messages;
          return GestureDetector(
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
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          final message = messages[index];
                          if (message.senderUid == widget.message.senderUid) {
                            return _messageLayout(
                              messageType: message.messageType,
                              message: message.message,
                              alignment: Alignment.centerRight,
                              createAt: message.createdAt,
                              isSeen: message.isSeen,
                              isShowTick: true,
                              messageBgColor: messageColor,
                              rightPadding:
                                  message.repliedMessage == "" ? 85 : 5,
                              reply: MessageReplayEntity(
                                  message: message.repliedMessage,
                                  messageType: message.repliedMessageType,
                                  username: message.repliedTo),
                              onLongPress: () {
                                focusNode.unfocus();
                                displayAlertDialog(context, onTap: () {
                                  BlocProvider.of<MessageCubit>(context)
                                      .deleteMessage(
                                          message: MessageEntity(
                                              senderUid:
                                                  widget.message.senderUid,
                                              recipientUid:
                                                  widget.message.recipientUid,
                                              messageId: message.messageId));
                                  Navigator.pop(context);
                                },
                                    confirmTitle: "Delete",
                                    content:
                                        "Are you sure you want to delete this message?");
                              },
                              onSwipe: () {
                                onMessageSwipe(
                                    message: message.message,
                                    username: message.senderName,
                                    type: message.messageType,
                                    isMe: true);

                                setState(() {});
                              },
                            );
                          } else {
                            return _messageLayout(
                              messageType: message.messageType,
                              message: message.message,
                              alignment: Alignment.centerLeft,
                              createAt: message.createdAt,
                              isSeen: message.isSeen,
                              isShowTick: false,
                              messageBgColor: senderMessageColor,
                              rightPadding:
                                  message.repliedMessage == "" ? 85 : 5,
                              reply: MessageReplayEntity(
                                  message: message.repliedMessage,
                                  messageType: message.repliedMessageType,
                                  username: message.repliedTo),
                              onLongPress: () {
                                focusNode.unfocus();
                                displayAlertDialog(context, onTap: () {
                                  BlocProvider.of<MessageCubit>(context)
                                      .deleteMessage(
                                          message: MessageEntity(
                                              senderUid:
                                                  widget.message.senderUid,
                                              recipientUid:
                                                  widget.message.recipientUid,
                                              messageId: message.messageId));
                                  context.pop();
                                },
                                    confirmTitle: "Delete",
                                    content:
                                        "Are you sure you want to delete this message?");
                              },
                              onSwipe: () {
                                onMessageSwipe(
                                    message: message.message,
                                    username: message.senderName,
                                    type: message.messageType,
                                    isMe: false);

                                setState(() {});
                              },
                            );
                          }
                        },
                      ),
                    ),
                    _isReplying == true
                        ? SizedBox(
                            height: 5.h,
                          )
                        : SizedBox(
                            height: 0.h,
                          ),
                    _isReplying == true
                        ? Stack(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 95.h,
                                      child: MessageReplayPreviewWidget(
                                        onCancelReplayListener: () {
                                          provider.setMessageReplay =
                                              MessageReplayEntity();
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 60.w,
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Container(),
                    Container(
                      margin: EdgeInsets.only(
                          left: 10.w,
                          right: 10.w,
                          top: _isReplying == true ? 0.h : 5.h,
                          bottom: 5.h),
                      child: Row(
                        children: [
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            decoration: BoxDecoration(
                                color: appBarColor,
                                borderRadius: _isReplying == true
                                    ? const BorderRadius.only(
                                        bottomLeft: Radius.circular(25),
                                        bottomRight: Radius.circular(25))
                                    : BorderRadius.circular(25)),
                            height: 50.h,
                            child: TextField(
                              focusNode: focusNode,
                              controller: _textMessageController,
                              onTap: () {
                                setState(() {
                                  _isShowAttachWindow = false;
                                  isShowEmojiKeyboard = false;
                                });
                              },
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  setState(() {
                                    _textMessageController.text = value;
                                    _isDisplayButton = true;
                                  });
                                } else {
                                  setState(() {
                                    _textMessageController.text = value;
                                    _isDisplayButton = false;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15.h),
                                  prefixIcon: GestureDetector(
                                    onTap: toggleEmojiKeyboard,
                                    child: Icon(
                                        isShowEmojiKeyboard == false
                                            ? Icons.emoji_emotions
                                            : Icons.keyboard_outlined,
                                        color: greyColor),
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
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  Future.delayed(
                                                      const Duration(
                                                          seconds: 1), () {
                                                    setState(() {
                                                      _isShowAttachWindow =
                                                          !_isShowAttachWindow;
                                                    });
                                                  });
                                                },
                                                child: const Icon(
                                                    Icons.attach_file))),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            selectImage().then((value) {
                                              if (_image != null) {
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback(
                                                  (timeStamp) {
                                                    showImagePickedBottomModalSheet(
                                                        context,
                                                        recipientName: widget
                                                            .message
                                                            .recipientName,
                                                        file: _image,
                                                        onTap: () {
                                                      _sendImageMessage();
                                                      context.pop();
                                                    });
                                                  },
                                                );
                                              }
                                            });
                                          },
                                          child: const Icon(
                                            Icons.camera_alt,
                                            color: greyColor,
                                          ),
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
                          GestureDetector(
                            onTap: () {
                              _sendTextMessage();
                            },
                            child: Container(
                                width: 50.w,
                                height: 50.h,
                                decoration: BoxDecoration(
                                    color: tabColor,
                                    borderRadius: BorderRadius.circular(25.r)),
                                child: Center(
                                  child: Icon(
                                    _isDisplaySendButton || _textMessageController.text.isNotEmpty ? Icons.send_outlined : _isRecording ? Icons.close : Icons.mic,
                                    color: Colors.white,
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                    isShowEmojiKeyboard
                        ? SizedBox(
                      height: 310.h,
                      child: Stack(
                        children: [
                          EmojiPicker(
                            config:
                             const Config(emojiTextStyle: TextStyle(color: Colors.red)),

                            onEmojiSelected: ((category, emoji) {
                              setState(() {
                                _textMessageController.text =
                                    _textMessageController.text +
                                        emoji.emoji;
                              });
                            }),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: double.infinity,
                              height: 40.h,
                              decoration:
                              const BoxDecoration(color: appBarColor),
                              child: Padding(
                                padding:  EdgeInsets.symmetric(
                                    horizontal: 20.0.w),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    const Icon(
                                      Icons.search,
                                      size: 20,
                                      color: greyColor,
                                    ),
                                     Row(
                                      children: [
                                        Icon(
                                          Icons
                                              .emoji_emotions_outlined,
                                          size: 20.sp,
                                          color: tabColor,
                                        ),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Icon(
                                          Icons.gif_box_outlined,
                                          size: 20.sp,
                                          color: greyColor,
                                        ),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Icon(
                                          Icons.ad_units,
                                          size: 20.sp,
                                          color: greyColor,
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _textMessageController
                                                .text =
                                                _textMessageController
                                                    .text
                                                    .substring(
                                                    0,
                                                    _textMessageController
                                                        .text
                                                        .length - 2);
                                          });
                                        },
                                        child:  Icon(
                                          Icons.backspace_outlined,
                                          size: 20.sp,
                                          color: greyColor,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                        : const SizedBox(),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 20.h),
                          decoration: BoxDecoration(
                              color: bottomAttachContainerColor,
                              borderRadius: BorderRadius.circular(10.r)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _attachWindowItem(
                                      icon: Icons.bar_chart,
                                      title: "Poll",
                                      color: tabColor),
                                  _attachWindowItem(
                                      icon: Icons.gif_box_outlined,
                                      title: "Gif",
                                      color: Colors.indigoAccent,
                                      onTap: () {
                                        _sendGifMessage();
                                      }),
                                  _attachWindowItem(
                                      icon: Icons.videocam_rounded,
                                      title: "Video",
                                      color: Colors.lightGreen,
                                      onTap: () {
                                        selectVideo().then((value) {
                                          if (_video != null) {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback(
                                              (timeStamp) {
                                                showVideoPickedBottomModalSheet(
                                                    context,
                                                    recipientName: widget
                                                        .message.recipientName,
                                                    file: _video, onTap: () {
                                                  _sendVideoMessage();
                                                  Navigator.pop(context);
                                                });
                                              },
                                            );
                                          }
                                        });

                                        setState(() {
                                          _isShowAttachWindow = false;
                                        });
                                      }),
                                ],
                              ),
                            ],
                          ),
                        ))
                    : Container()
              ],
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(
            color: tabColor,
          ),
        );
      }),
    );
  }

  _messageLayout(
      {Color? messageBgColor,
      Alignment? alignment,
      Timestamp? createAt,
      VoidCallback? onSwipe,
      String? message,
      String? messageType,
      bool? isShowTick,
      bool? isSeen,
      VoidCallback? onLongPress,
      MessageReplayEntity? reply,
      double? rightPadding}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0.w),
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
                Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 10.h),
                        padding: EdgeInsets.only(
                            left: 5.w,
                            right: messageType == MessageTypeConst.textMessage
                                ? rightPadding!
                                : 5.w,
                            top: 5.h,
                            bottom: 5.h),
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.80),
                        decoration: BoxDecoration(
                            color: messageBgColor,
                            borderRadius: BorderRadius.circular(8.r)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            reply?.message == null || reply?.message == ""
                                ? const SizedBox()
                                : Container(
                                    height: reply!.messageType ==
                                            MessageTypeConst.textMessage
                                        ? 70.h
                                        : 80.h,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(.2),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: double.infinity,
                                          width: 4.5.w,
                                          decoration: BoxDecoration(
                                              color: reply.username ==
                                                      widget
                                                          .message.recipientName
                                                  ? Colors.deepPurpleAccent
                                                  : tabColor,
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(15.r),
                                                  bottomLeft:
                                                      Radius.circular(15.r))),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.0.w,
                                                vertical: 5.h),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${reply.username == widget.message.recipientName ? reply.username : "You"}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: reply.username ==
                                                              widget.message
                                                                  .recipientName
                                                          ? Colors
                                                              .deepPurpleAccent
                                                          : tabColor),
                                                ),
                                                MessageReplayTypeWidget(
                                                  message: reply.message,
                                                  type: reply.messageType,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            const SizedBox(
                              height: 3,
                            ),
                            MessageTypeWidget(
                              message: message,
                              type: messageType,
                            ),
                          ],
                        )),
                    const SizedBox(height: 3),
                  ],
                ),
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(
                    children: [
                      Text(DateFormat.jm().format(createAt!.toDate()),
                          style:
                              const TextStyle(fontSize: 12, color: greyColor)),
                      const SizedBox(
                        width: 5,
                      ),
                      isShowTick == true
                          ? Icon(
                              isSeen == true ? Icons.done_all : Icons.done,
                              size: 16,
                              color: isSeen == true ? Colors.blue : greyColor,
                            )
                          : Container()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  _sendTextMessage() async {
    final provider = BlocProvider.of<MessageCubit>(context);

    if (_isDisplaySendButton || _textMessageController.text.isNotEmpty) {
      if (provider.messageReplay.message != null) {
        _sendMessage(
            message: _textMessageController.text,
            type: MessageTypeConst.textMessage,
            repliedMessage: provider.messageReplay.message,
            repliedTo: provider.messageReplay.username,
            repliedMessageType: provider.messageReplay.messageType);
      } else {
        _sendMessage(
            message: _textMessageController.text,
            type: MessageTypeConst.textMessage);
      }

      provider.setMessageReplay = MessageReplayEntity();
      setState(() {
        _textMessageController.clear();
        _isShowAttachWindow = false;
      });
    } else {
      final temporaryDir = await getTemporaryDirectory();
      final audioPath = '${temporaryDir.path}/flutter_sound.aac';
      if (!_isRecordInit) {
        return;
      }

      if (_isRecording == true) {
        await _soundRecorder!.stopRecorder();
        StorageProviderRemoteDataSource.uploadMessageFile(
          file: File(audioPath),
          onComplete: (value) {},
          uid: widget.message.senderUid,
          otherUid: widget.message.recipientUid,
          type: MessageTypeConst.audioMessage,
        ).then((audioUrl) {
          _sendMessage(message: audioUrl, type: MessageTypeConst.audioMessage);
        });
      } else {
        await _soundRecorder!.startRecorder(
          toFile: audioPath,
        );
      }

      setState(() {
        _isRecording = !_isRecording;
      });
    }
  }

  void _sendImageMessage() {
    StorageProviderRemoteDataSource.uploadMessageFile(
      file: _image!,
      onComplete: (value) {},
      uid: widget.message.senderUid,
      otherUid: widget.message.recipientUid,
      type: MessageTypeConst.photoMessage,
    ).then((photoImageUrl) {
      _sendMessage(message: photoImageUrl, type: MessageTypeConst.photoMessage);
    });
  }

  void _sendVideoMessage() {
    StorageProviderRemoteDataSource.uploadMessageFile(
      file: _video!,
      onComplete: (value) {},
      uid: widget.message.senderUid,
      otherUid: widget.message.recipientUid,
      type: MessageTypeConst.videoMessage,
    ).then((videoUrl) {
      _sendMessage(message: videoUrl, type: MessageTypeConst.videoMessage);
    });
  }

  Future _sendGifMessage() async {
    final gif = await pickGIF(context);
    if (gif != null) {
      String fixedUrl = "https://media.giphy.com/media/${gif.id}/giphy.gif";
      _sendMessage(message: fixedUrl, type: MessageTypeConst.gifMessage);
      // context.pop();
    }
  }

  void _sendMessage(
      {required String message,
      required String type,
      String? repliedMessage,
      String? repliedTo,
      String? repliedMessageType}) {
    _scrollToBottom();

    ChatUtils.sendMessage(
      context,
      messageEntity: widget.message,
      message: message,
      type: type,
      repliedTo: repliedTo,
      repliedMessageType: repliedMessageType,
      repliedMessage: repliedMessage,
    ).then((value) {
      _scrollToBottom();
    });
    setState(() {
      _isShowAttachWindow = !_isShowAttachWindow;
    });
  }
}
