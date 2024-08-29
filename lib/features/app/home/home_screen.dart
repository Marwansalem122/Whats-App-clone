import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/features/app/helpers/extensions.dart';
import 'package:whatsapp_clone/features/app/routing/routes.dart';
import 'package:whatsapp_clone/features/app/theme/style.dart';
import 'package:whatsapp_clone/features/call/presentation/pages/calls_history_screen.dart';
import 'package:whatsapp_clone/features/chat/presentation/pages/chat_screen.dart';
import 'package:whatsapp_clone/features/status/presentation/pages/status_screen.dart';

import '../../../storage/storage_provider.dart';
import '../../status/domain/entities/status_entity.dart';
import '../../status/domain/entities/status_image_entity.dart';
import '../../status/domain/usecases/get_my_status_future_usecase.dart';
import '../../status/presentation/cubit/status/status_cubit.dart';
import '../../user/domain/entities/user_entity.dart';
import '../../user/presentation/cubit/get_single_user/get_single_user_cubit.dart';
import '../../user/presentation/cubit/user/user_cubit.dart';
import 'package:path/path.dart' as path;
import 'package:whatsapp_clone/main_injection_container.dart' as di;

import '../global/widgets/show_image_and_video_widget.dart';
class HomeScreen extends StatefulWidget {
  final String uid;
  final int? index;
  const HomeScreen({super.key, required this.uid,  this.index});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController? _tabController;
  int _currentTabIndex = 0;
  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid: widget.uid);
    // BlocProvider.of<MyCallHistoryCubit>(context).getMyCallHistory(uid: widget.uid);

    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(() {
      setState(() {
        _currentTabIndex = _tabController!.index;
      });
    });
    if (widget.index != null) {
      setState(() {
        _currentTabIndex = widget.index!;
        _tabController!.animateTo(1);
      });
    }
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _tabController!.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        BlocProvider.of<UserCubit>(context).updateUser(
            user: UserEntity(
                uid: widget.uid,
                isOnline: true
            )
        );
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        BlocProvider.of<UserCubit>(context).updateUser(
            user: UserEntity(
                uid: widget.uid,
                isOnline: false
            )
        );
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
        break;
    }
  }
  List<StatusImageEntity> _stories = [];


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
          String extension = path.extension(_selectedMedia![i].path)
              .toLowerCase();
          if (extension == '.jpg' || extension == '.jpeg' ||
              extension == '.png') {
            _mediaTypes![i] = 'image';
          } else if (extension == '.mp4' || extension == '.mov' ||
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
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context,state) {
       if(state is GetSingleUserLoaded){
         final currentUser = state.singleUser;
         return Scaffold(
           appBar: AppBar(
             title: Text("Whatspp",
                 style: TextStyle(
                     fontWeight: FontWeight.w600,
                     fontSize: 20.sp,
                     color: greyColor)),
             automaticallyImplyLeading: false,
             actions: [
               Row(
                 children: [
                   Icon(
                     Icons.camera_alt_outlined,
                     color: greyColor,
                     size: 28.sp,
                   ),
                   SizedBox(
                     width: 25.w,
                   ),
                   Icon(Icons.search, color: greyColor, size: 28.sp),
                   SizedBox(
                     width: 10.w,
                   ),
                   PopupMenuButton<String>(
                     icon: Icon(
                       Icons.more_vert,
                       color: greyColor,
                       size: 28.sp,
                     ),
                     color: appBarColor,
                     iconSize: 28.sp,
                     onSelected: (value) {},
                     itemBuilder: (context) => <PopupMenuEntry<String>>[
                       PopupMenuItem<String>(
                         value: "Settings",
                         child: GestureDetector(
                             onTap: () {
                               context.pushNamed(Routes.settingsScreen,arguments:  widget.uid);
                             },
                             child: const Text('Settings')),
                       ),
                     ],
                   ),
                 ],
               ),
             ],
             bottom: TabBar(
               labelColor: tabColor,
               unselectedLabelColor: greyColor,
               indicatorColor: tabColor,
               controller: _tabController,
               tabs: const [
                 Tab(
                   child: Text(
                     "Chats",
                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                   ),
                 ),
                 Tab(
                   child: Text(
                     "Status",
                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                   ),
                 ),
                 Tab(
                   child: Text(
                     "Calls",
                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                   ),
                 ),
               ],
             ),
           ),
           floatingActionButton:
           switchFloatingActionButtonOnTabIndex(_currentTabIndex,currentUser),
           body: TabBarView(
               controller: _tabController,
               children:  [ChatScreen(uid: widget.uid,),  StatusScreen(currentUser: currentUser,), const CallsHistoryScreen()]),
         );
       }
       return const Center(
         child: CircularProgressIndicator(
           color: tabColor,
         ),
       );
      }
    );
  }

  switchFloatingActionButtonOnTabIndex(int index, UserEntity currentUser) {
    switch (index) {
      case 0:
        return FloatingActionButton(
          backgroundColor: tabColor,
          onPressed: () {
            // Navigator.pushNamed(context, PageConst.contactUsersPage, arguments: widget.uid);
            context.pushNamed(Routes.contactsScreen,arguments: widget.uid);
          },
          child: const Icon(
            Icons.message,
            color: Colors.white,
          ),
        );
      case 1:
        return FloatingActionButton(
          backgroundColor: tabColor,
          onPressed: () {
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
                          context.pop();
                        },
                      );
                    },
                  );
                }
              },
            );
          },
          child: const Icon(
            Icons.camera_alt,
            color: Colors.white,
          ),
        );
      case 2:
        return FloatingActionButton(
          backgroundColor: tabColor,
          onPressed: () {
            Navigator.pushNamed(context, Routes.callContactScreen);
          },
          child: const Icon(
            Icons.add_call,
            color: Colors.white,
          ),
        );
      default:
        return FloatingActionButton(
          backgroundColor: tabColor,
          onPressed: () {},
          child: const Icon(
            Icons.message,
            color: Colors.white,
          ),
        );
    }
  }
  _uploadImageStatus(UserEntity currentUser) {
    StorageProviderRemoteDataSource.uploadStatuses(
        files: _selectedMedia!,
        onComplete: (onCompleteStatusUpload) {}
    ).then((statusImageUrls) {
      for (var i = 0; i < statusImageUrls.length; i++) {
        _stories.add(StatusImageEntity(
          url: statusImageUrls[i],
          type: _mediaTypes![i],
          viewers: const [],
        ));
      }

      di.sl<GetMyStatusFutureUseCase>().call(widget.uid).then((myStatus) {
        if (myStatus.isNotEmpty) {
          BlocProvider.of<StatusCubit>(context).updateOnlyImageStatus(
              status: StatusEntity(
                  statusId: myStatus.first.statusId,
                  stories: _stories
              )
          ).then((value) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>
                HomeScreen(uid: widget.uid, index: 1,)));
          });
        } else {
          BlocProvider.of<StatusCubit>(context).createStatus(
            status: StatusEntity(
                caption: "",
                createdAt: Timestamp.now(),
                stories: _stories,
                username: currentUser.username,
                uid: currentUser.uid,
                profileUrl: currentUser.profileUrl,
                imageUrl: statusImageUrls[0],
                phoneNumber: currentUser.phoneNumber
            ),
          ).then((value) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>
                HomeScreen(uid: widget.uid, index: 1,)));
          });
        }
      });
    });
  }
}
