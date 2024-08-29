import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:whatsapp_clone/features/app/global/widgets/profile_widget.dart';

import 'package:whatsapp_clone/features/app/home/home_screen.dart';
import 'package:whatsapp_clone/features/app/theme/style.dart';

import '../../domain/entities/status_entity.dart';
import '../cubit/status/status_cubit.dart';
import '../widgets/delete_status_update_alert.dart';

class MyStatusScreen extends StatefulWidget {
  final StatusEntity status;
  const MyStatusScreen({super.key, required this.status});

  @override
  State<MyStatusScreen> createState() => _MyStatusScreenState();
}

class _MyStatusScreenState extends State<MyStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Status"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 55.w,
                  height: 55.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.r),
                    child: profileWidget( imageUrl: widget.status.imageUrl),
                  ),
                ),
                SizedBox(
                  width: 15.w,
                ),
                Expanded(
                  child: Text(
                    GetTimeAgo.parse(widget.status.createdAt!.toDate().subtract(Duration(seconds: DateTime.now().second))),
                    style:  TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: greyColor.withOpacity(.5),
                  ),
                  color: appBarColor,
                  iconSize: 28.sp,
                  onSelected: (value) {},
                  itemBuilder: (context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: "Delete",
                      child: GestureDetector(
                        onTap: () {
                          deleteStatusUpdate(context, onTap: () {
                            Navigator.pop(context);
                            BlocProvider.of<StatusCubit>(context).deleteStatus(
                                status: StatusEntity(
                                    statusId: widget.status.statusId
                                )
                            );


                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen(uid: widget.status.uid!, index: 1,)));
                          });
                        },
                        child: const Text('Delete'),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
