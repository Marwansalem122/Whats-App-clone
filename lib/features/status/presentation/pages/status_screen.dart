import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_story_view/flutter_story_view.dart';
import 'package:flutter_story_view/models/story_item.dart';
import 'package:whatsapp_clone/features/app/global/date/date_formats.dart';
import 'package:whatsapp_clone/features/app/global/widgets/profile_widget.dart';
import 'package:whatsapp_clone/features/app/helpers/extensions.dart';
import 'package:whatsapp_clone/features/app/home/home_screen.dart';
import 'package:whatsapp_clone/features/app/routing/routes.dart';
import 'package:whatsapp_clone/features/app/theme/style.dart';
import 'package:path/path.dart' as path;
import '../../../../storage/storage_provider.dart';
import '../../../app/global/widgets/show_image_and_video_widget.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../../domain/entities/status_entity.dart';
import '../../domain/entities/status_image_entity.dart';
import '../../domain/usecases/get_my_status_future_usecase.dart';
import 'package:whatsapp_clone/main_injection_container.dart' as di;
import '../cubit/get_my_status/get_my_status_cubit.dart';
import '../cubit/status/status_cubit.dart';
import '../widgets/status_dotted_borders_widget.dart';

class StatusScreen extends StatefulWidget {
  final UserEntity currentUser;
  const StatusScreen({super.key, required this.currentUser});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  List<StatusImageEntity> _stories = [];

  List<StoryItem> myStories = [];

  List<File>? _selectedMedia;
  List<String>? _mediaTypes; // To store the type of each selected file
  Future<void> selectMedia() async {
    setState(() {
      _selectedMedia = null;
      _mediaTypes = null;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: true,
      );
      if (result != null) {
        _selectedMedia = result.files.map((file) => File(file.path!)).toList();

        // Initialize the media types list
        _mediaTypes = List<String>.filled(_selectedMedia!.length, '');

        // Determine the type of each selected file
        for (int i = 0; i < _selectedMedia!.length; i++) {
          String extension =
              path.extension(_selectedMedia![i].path).toLowerCase();
          if (extension == '.jpg' ||
              extension == '.jpeg' ||
              extension == '.png') {
            _mediaTypes![i] = 'image';
          } else if (extension == '.mp4' ||
              extension == '.mov' ||
              extension == '.avi') {
            _mediaTypes![i] = 'video';
          }
        }

        setState(() {});
        print("mediaTypes = $_mediaTypes");
      } else {
        print("No file is selected.");
      }
    } catch (e) {
      print("Error while picking file: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    BlocProvider.of<StatusCubit>(context).getStatuses(status: StatusEntity());

    BlocProvider.of<GetMyStatusCubit>(context)
        .getMyStatus(uid: widget.currentUser.uid!);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      di
          .sl<GetMyStatusFutureUseCase>()
          .call(widget.currentUser.uid!)
          .then((myStatus) {
        if (myStatus.isNotEmpty && myStatus.first.stories != null) {
          _fillMyStoriesList(myStatus.first);
        }
      });
    });
  }

  Future _fillMyStoriesList(StatusEntity status) async {
    if (status.stories != null) {
      _stories = status.stories!;
      for (StatusImageEntity story in status.stories!) {
        myStories.add(StoryItem(
            url: story.url!,
            type: StoryItemTypeExtension.fromString(story.type!),
            viewers: story.viewers!));
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return BlocBuilder<StatusCubit, StatusState>(
      builder: (context, state) {
        if (state is StatusLoaded) {
          final statuses = state.statuses
              .where((element) => element.uid != widget.currentUser.uid)
              .toList();
          print("statuses loaded $statuses");

          return BlocBuilder<GetMyStatusCubit, GetMyStatusState>(
            builder: (context, state) {
              if (state is GetMyStatusLoaded) {
                print("loaded my status ${state.myStatus}");
                return _bodyWidget(statuses, widget.currentUser,
                    myStatus: state.myStatus);
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
    );
  }

  _bodyWidget(List<StatusEntity> statuses, UserEntity currentUser,
      {StatusEntity? myStatus}) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    myStatus != null
                        ? GestureDetector(
                            onTap: () {
                              _eitherShowOrUploadSheet(myStatus, currentUser);
                            },
                            child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 10.h),
                                width: 60.w,
                                height: 60.h,
                                // decoration: const BoxDecoration(
                                //     shape: BoxShape.circle, color: tabColor),
                                child: CustomPaint(
                                  painter: StatusDottedBordersWidget(
                                      isMe: true,
                                      numberOfStories: myStatus.stories!.length,
                                      spaceLength: 4,
                                      images: myStatus.stories!,
                                      uid: widget.currentUser.uid),
                                  child: Container(
                                    margin: const EdgeInsets.all(3),
                                    width: 55.w,
                                    height: 55.h,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30.r),
                                      child: profileWidget(
                                          imageUrl: myStatus?.imageUrl),
                                    ),
                                  ),
                                )),
                          )
                        : Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 10.h),
                            width: 60.w,
                            height: 60.h,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30).r,
                              child: profileWidget(
                                  imageUrl: currentUser.profileUrl),
                            ),
                          ),
                    myStatus != null
                        ? Container()
                        :  Positioned(
                        right: 10.h,
                        bottom: 8.h,
                        child: GestureDetector(
                          onTap: (){
                            _eitherShowOrUploadSheet(myStatus, currentUser);
                          },
                          child: Container(
                            width: 25.w,
                            height: 25.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.r),
                                border:
                                    Border.all(width: 2, color: backgroundColor),
                                color: tabColor),
                            child: const Center(
                                child: Icon(
                              Icons.add,
                              size: 20,
                            )),
                          ),
                        ))
                  ],
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("My Status", style: TextStyle(fontSize: 16.sp)),
                    SizedBox(height: 2.h),
                    GestureDetector(onTap: (){
                      _eitherShowOrUploadSheet(myStatus, currentUser);
                    },
                      child: const Text("Tap to add status update",
                          style: TextStyle(color: greyColor)),
                    )
                  ],
                )),
                GestureDetector(
                    onTap: () {
                      context.pushNamed(Routes.myStatusScreen,arguments:myStatus );
                    },
                    child:myStatus!=null? Icon(Icons.more_horiz,
                        color: greyColor.withOpacity(0.5)):Container()),
                SizedBox(width: 10.w)
              ],
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Text("Recent updates",
                  style: TextStyle(
                      fontSize: 15.sp,
                      color: greyColor,
                      fontWeight: FontWeight.w500)),
            ),
            SizedBox(height: 10.h),
            ListView.builder(
                itemCount: statuses.length,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) {
                  final status = statuses[index];

                  List<StoryItem> stories = [];

                  for (StatusImageEntity storyItem in status.stories!) {
                    stories.add(StoryItem(url: storyItem.url!,
                        viewers: storyItem.viewers,
                        type: StoryItemTypeExtension.fromString(storyItem.type!)));
                  }

                  return ListTile(

                    onTap: () {
                      _showStatusImageViewBottomModalSheet(status: status, stories: stories);
                    },
                    leading: SizedBox(
                      width: 55.w,
                      height: 55.h,
                      child: CustomPaint(
                        painter: StatusDottedBordersWidget(
                            isMe: false,
                            numberOfStories: status.stories!.length,
                            spaceLength: 4,
                            images: status.stories,
                            uid: widget.currentUser.uid
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(3),
                          width: 45.w,
                          height: 55.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25.r),
                            child: profileWidget(imageUrl: status.imageUrl),
                          ),
                        ),
                      ),
                    ),
                    title: Text( "${status.username}", style: TextStyle(fontSize: 16.sp)),
                    subtitle: Text(formatDateTime(status.createdAt!.toDate()),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  Future _showStatusImageViewBottomModalSheet(
      {StatusEntity? status, required List<StoryItem> stories}) async {
    print("storieas $stories");
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) {
        return FlutterStoryView(
          onComplete: () {
            Navigator.pop(context);
          },
          storyItems: stories,
          enableOnHoldHide: false,
          caption: "This is very beautiful photo",
          onPageChanged: (index) {
            BlocProvider.of<StatusCubit>(context).seenStatusUpdate(
                imageIndex: index,
                userId: widget.currentUser.uid!,
                statusId: status.statusId!);
          },
          createdAt: status!.createdAt!.toDate(),
        );
      },
    );
  }

  _uploadImageStatus(UserEntity currentUser) {
    StorageProviderRemoteDataSource.uploadStatuses(
            files: _selectedMedia!, onComplete: (onCompleteStatusUpload) {})
        .then((statusImageUrls) {
      for (var i = 0; i < statusImageUrls.length; i++) {
        _stories.add(StatusImageEntity(
          url: statusImageUrls[i],
          type: _mediaTypes![i],
          viewers: const [],
        ));
      }

      di
          .sl<GetMyStatusFutureUseCase>()
          .call(widget.currentUser.uid!)
          .then((myStatus) {
        if (myStatus.isNotEmpty) {
          BlocProvider.of<StatusCubit>(context)
              .updateOnlyImageStatus(
                  status: StatusEntity(
                      statusId: myStatus.first.statusId, stories: _stories))
              .then((value) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => HomeScreen(
                      uid: widget.currentUser.uid!,
                      index: 1,
                    )));
          });
        } else {
          BlocProvider.of<StatusCubit>(context)
              .createStatus(
            status: StatusEntity(
                caption: "",
                createdAt: Timestamp.now(),
                stories: _stories,
                username: currentUser.username,
                uid: currentUser.uid,
                profileUrl: currentUser.profileUrl,
                imageUrl: statusImageUrls[0],
                phoneNumber: currentUser.phoneNumber),
          )
              .then((value) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => HomeScreen(
                      uid: widget.currentUser.uid!,
                      index: 1,
                    )));
          });
        }
      });
    });
  }
  void _eitherShowOrUploadSheet(StatusEntity? myStatus, UserEntity currentUser) {
    if (myStatus != null) {
      _showStatusImageViewBottomModalSheet(status: myStatus, stories: myStories);
    } else {
      selectMedia().then(
            (value) {
          if (_selectedMedia != null && _selectedMedia!.isNotEmpty) {
            showModalBottomSheet(
              isScrollControlled: true,
              isDismissible: false,
              enableDrag: false,
              context: context,
              builder: (context) {
                return ShowMultiImageAndVideoPickedWidget(
                  selectedFiles: _selectedMedia!,
                  onTap: () {
                    _uploadImageStatus(currentUser);
                    Navigator.pop(context);
                  },
                );
              },
            );
          }
        },
      );
    }
  }
}
