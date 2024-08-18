import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/features/app/helpers/extensions.dart';
import 'package:whatsapp_clone/features/app/routing/routes.dart';
import 'package:whatsapp_clone/features/app/theme/style.dart';
import 'package:whatsapp_clone/features/user/presentation/widgets/btn_widget.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  // @override
  // void dispose() {
  //   _otpController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 40.h),
          child: Column(children: [
            Expanded(
                child: Column(children: [
              SizedBox(
                height: 40.h,
              ),
              Center(
                  child: Text(
                "Verify your  Otp",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                    color: tabColor),
              )),
              SizedBox(
                height: 20.h,
              ),
              Text(
                "Enter your OTP for the WhatsApp Clone Verification (so that you will be moved for the further steps to complete)",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.sp),
              ),
              SizedBox(
                height: 30.h,
              ),
              _pinCodeWidget(),
              SizedBox(
                height: 30.h,
              ),
            ])),
            btnWidget(
              textButton: "Next",
              onTap: () {
                print(_otpController.text);
                context.pushReplacementNamed(Routes.intialProfileSubmitScreen);
              },
              width: 120.w,
              height: 40.h,
            )
          ])),
    );
  }

  Widget _pinCodeWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50.w),
      child: Column(
        children: <Widget>[
          PinCodeFields(
            controller: _otpController,
            length: 6,
            activeBorderColor: tabColor,
            onComplete: (String pinCode) {},
          ),
          const Text("Enter your 6 digit code")
        ],
      ),
    );
  }
}
