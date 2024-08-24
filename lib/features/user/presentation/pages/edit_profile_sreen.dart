import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../storage/storage_provider.dart';
import '../../../app/const/app_const.dart';
import '../../../app/global/widgets/profile_widget.dart';
import '../../../app/theme/style.dart';
import '../../domain/entities/user_entity.dart';
import '../cubit/user/user_cubit.dart';

class EditProfileSreen extends StatefulWidget {
  final UserEntity currentUser;
  const EditProfileSreen({super.key, required this.currentUser});

  @override
  State<EditProfileSreen> createState() => _EditProfileSreenState();
}

class _EditProfileSreenState extends State<EditProfileSreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _aboutController = TextEditingController();

  File? _image;
  bool _isProfileUpdating = false;

  Future selectImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print("no image has been selected");
        }
      });
    } catch (e) {
      toast("some error occured $e");
    }
  }

  @override
  void initState() {
    _usernameController = TextEditingController(text: widget.currentUser.username);
    _aboutController = TextEditingController(text: widget.currentUser.status);
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 150.w,
                      height: 150.h,
                      margin:  EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(75.r),
                        child: profileWidget(imageUrl: widget.currentUser.profileUrl, image: _image),
                      ),
                    ),
                    Positioned(
                      bottom: 15.h,
                      right: 15.r,
                      child: GestureDetector(
                        onTap: selectImage,
                        child: Container(
                          width: 50.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.r),
                            color: tabColor,
                          ),
                          child:  Icon(
                            Icons.camera_alt_rounded,
                            color: blackColor,
                            size: 30.sp,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
               SizedBox(
                height: 10.h,
              ),
              _profileItem(
                  controller: _usernameController,
                  title: "Name",
                  description: "Enter username",
                  icon: Icons.person,
                  onTap: () {}),
              _profileItem(
                  controller: _aboutController,
                  title: "About",
                  description: "Hey there I'm using WhatsApp",
                  icon: Icons.info_outline,
                  onTap: () {}),
              _settingsItemWidget(
                  title: "Phone", description: "${widget.currentUser.phoneNumber}", icon: Icons.phone, onTap: () {}),
               SizedBox(height: 40.h),
              GestureDetector(
                onTap: submitProfileInfo,
                child: Container(
                  margin:  EdgeInsets.only(bottom: 20.h),
                  width: 120.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: tabColor,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: _isProfileUpdating == true
                      ?  Center(
                    child: SizedBox(
                      width: 25.w,
                      height: 25.h,
                      child:const CircularProgressIndicator(
                        color: whiteColor,
                      ),
                    ),
                  )
                      :  Center(
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  _profileItem(
      {String? title, String? description, IconData? icon, VoidCallback? onTap, TextEditingController? controller}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SizedBox(
              width: 80.w,
              height: 80.h,
              child: Icon(
                icon,
                color: greyColor,
                size: 25.sp,
              )),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$title",
                  style:  TextStyle(fontSize: 14.sp, color: Colors.grey),
                ),
                Padding(
                  padding:  EdgeInsets.only(right: 15.0.w),
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                        hintText: description!,
                        suffixIcon: const Icon(
                          Icons.edit_rounded,
                          color: tabColor,
                        )),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _settingsItemWidget({String? title, String? description, IconData? icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SizedBox(
              width: 80.w,
              height: 80.h,
              child: Icon(
                icon,
                color: greyColor,
                size: 25.sp,
              )),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$title",
                  style:  TextStyle(fontSize: 14.sp, color: Colors.grey),
                ),
                 SizedBox(
                  height: 3.h,
                ),
                Text(
                  "$description",
                  style:  TextStyle(fontSize: 17.sp),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void submitProfileInfo() {
    if (_image != null) {
      StorageProviderRemoteDataSource.uploadProfileImage(
          file: _image!,
          onComplete: (onProfileUpdateComplete) {
            setState(() {
              _isProfileUpdating = onProfileUpdateComplete;
            });
          }).then((profileImageUrl) {
        _profileInfo(profileUrl: profileImageUrl);
      });
    } else {
      _profileInfo(profileUrl: widget.currentUser.profileUrl);
    }
  }

  void _profileInfo({String? profileUrl}) {
    if (_usernameController.text.isNotEmpty) {
      BlocProvider.of<UserCubit>(context)
          .updateUser(
          user: UserEntity(
            uid: widget.currentUser.uid,
            email: "",
            username: _usernameController.text,
            phoneNumber: widget.currentUser.phoneNumber,
            status: _aboutController.text,
            isOnline: false,
            profileUrl: profileUrl,
          ))
          .then((value) {
        toast("Profile updated");
      });
    }
  }
}