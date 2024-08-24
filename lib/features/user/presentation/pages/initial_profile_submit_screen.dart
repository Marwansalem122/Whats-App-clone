import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_clone/features/app/const/app_const.dart';
import 'package:whatsapp_clone/features/app/global/widgets/profile_widget.dart';
import 'package:whatsapp_clone/features/app/helpers/extensions.dart';
import 'package:whatsapp_clone/features/app/routing/routes.dart';
import 'package:whatsapp_clone/features/app/theme/style.dart';
import 'package:whatsapp_clone/features/user/presentation/widgets/btn_widget.dart';

import '../../../../storage/storage_provider.dart';
import '../../domain/entities/user_entity.dart';
import '../cubit/credential/credential_cubit.dart';

class InitialProfileSubmitScreen extends StatefulWidget {
   final String phoneNumber;
  const InitialProfileSubmitScreen({super.key,  required this.phoneNumber});

  @override
  State<InitialProfileSubmitScreen> createState() =>
      _InitialProfileSubmitScreenState();
}

class _InitialProfileSubmitScreenState
    extends State<InitialProfileSubmitScreen> {
  final TextEditingController _usernameController = TextEditingController();
  File? _image;

   bool _isProfileUpdating = false;

  Future selectImage() async {
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
      toast("some error occured $e");
    }
  }

  @override
  void dispose() {
    
    _usernameController.dispose();
    _image?.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.h),
          child: Column(children: [
            SizedBox(
              height: 30.h,
            ),
            Center(
              child: Text(
                "Profile Info",
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: tabColor),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "Please provide your name and an optional profile photo",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15.sp),
            ),
            SizedBox(
              height: 30.h,
            ),
            GestureDetector(
              onTap: selectImage,
              child: SizedBox(
                width: 50.w,
                height: 50.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.r),
                  child: profileWidget(image: _image),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              height: 40.h,
              margin: const EdgeInsets.only(top: 1.5),
              decoration: const BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: tabColor, width: 1.5))),
              child: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                    hintText: "Username", border: InputBorder.none),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            btnWidget(
                textButton: "Next",
                onTap: submitProfileInfo,
                width: 150.w,
                height: 40.h)
          ])),
    );
  }
  void submitProfileInfo() {
    if(_image != null) {
      StorageProviderRemoteDataSource.uploadProfileImage(
          file: _image!,
          onComplete: (onProfileUpdateComplete) {
            setState(() {
              _isProfileUpdating = onProfileUpdateComplete;
            });
          }
      ).then((profileImageUrl) {
        _profileInfo(
            profileUrl: profileImageUrl
        );
      });
    } else {
      _profileInfo(profileUrl: "");
    }
  }
  void _profileInfo({String? profileUrl}) {
    if (_usernameController.text.isNotEmpty) {
      BlocProvider.of<CredentialCubit>(context).submitProfileInfo(
          user: UserEntity(
            email: "",
            username: _usernameController.text,
            phoneNumber: widget.phoneNumber,
            status: "Hey There! I'm using WhatsApp Clone",
            isOnline: false,
            profileUrl: profileUrl,
          )
      );
    }
  }
}
