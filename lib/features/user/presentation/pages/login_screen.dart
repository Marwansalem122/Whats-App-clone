import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_cupertino.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/features/app/helpers/extensions.dart';
import 'package:whatsapp_clone/features/app/home/home_screen.dart';
import 'package:whatsapp_clone/features/app/routing/routes.dart';
import 'package:whatsapp_clone/features/app/theme/style.dart';
import 'package:whatsapp_clone/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:whatsapp_clone/features/user/presentation/widgets/btn_widget.dart';

import '../../../app/const/app_const.dart';
import '../cubit/auth/auth_cubit.dart';
import 'initial_profile_submit_screen.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  static Country _selectedFilteredDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode("20");
  String _countryCode = _selectedFilteredDialogCountry.phoneCode;

  String _phoneNumber = "";

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<CredentialCubit, CredentialState>(
        listener: (context, credentialListenerState) {
          if(credentialListenerState is CredentialSuccess) {
            BlocProvider.of<AuthCubit>(context).loggedIn();
          }
          if(credentialListenerState is CredentialFailure) {
            toast("Something went wrong");
          }
        },
      builder: (context, credentialBuilderState) {
        if(credentialBuilderState is CredentialLoading) {
          return const Center(child: CircularProgressIndicator(color: tabColor,),);
        }
        if(credentialBuilderState is CredentialPhoneAuthSmsCodeReceived) {
          return const OtpScreen();
        }
        if(credentialBuilderState is CredentialPhoneAuthProfileInfo) {
          return InitialProfileSubmitScreen(phoneNumber: _phoneNumber);
        }
        if(credentialBuilderState is CredentialSuccess) {
          return BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState){
              if(authState is Authenticated) {
                return HomeScreen(uid: authState.uid,);
              }
              return _bodyWidget();
            },
          );
        }
        return _bodyWidget();
      },
    );
  }
  _bodyWidget() {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 30.h),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 40.h,
                  ),
                  Center(
                    child: Text(
                      "Verify your phone number",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                          color: tabColor),
                    ),
                  ),
                  Text(
                    "WhatsApp Clone will send you SMS message (carrier charges may apply) to verify your phone number. Enter the country code and phone number",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15.sp),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
                    onTap: _openFilteredCountryPickerDialog,
                    title: _buildDialogItem(_selectedFilteredDialogCountry),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1.50,
                              color: tabColor,
                            ),
                          ),
                        ),
                        width: 80.w,
                        height: 42.h,
                        alignment: Alignment.center,
                        child: Text(
                            "+${_selectedFilteredDialogCountry.phoneCode}",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16.sp)),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Expanded(
                        child: Container(
                          height: 40.h,
                          margin: const EdgeInsets.only(top: 1.5),
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom:
                                  BorderSide(color: tabColor, width: 1.5))),
                          child: TextField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                                hintText: "Phone Number",
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            btnWidget(
                textButton: "Next",
                onTap:_submitVerifyPhoneNumber,
                width: 120.w,
                height: 40.h)
          ],
        ),
      ),
    );
  }
  _openFilteredCountryPickerDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.fromSwatch().copyWith(
                  primary: tabColor,
                ),
              ),
              child: CountryPickerDialog(
                titlePadding: const EdgeInsets.all(8.0),
                searchCursorColor: tabColor,
                searchInputDecoration: const InputDecoration(
                  hintText: "Search",
                ),
                isSearchable: true,
                onValuePicked: (Country country) {
                  setState(() {
                    _selectedFilteredDialogCountry = country;
                    _countryCode = country.phoneCode;
                  });
                },
                itemBuilder: _buildDialogItem,
              ));
        });
  }
  Widget _buildDialogItem(Country country) {
    return Container(
      height: 40.h,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: tabColor, width: 1.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          Text(" +${country.phoneCode}"),
          Expanded(
              child: Text(
                " ${country.name}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
          const Spacer(),
          const Icon(Icons.arrow_drop_down)
        ],
      ),
    );
  }

  void _submitVerifyPhoneNumber() {
    if (_phoneController.text.isNotEmpty) {
      _phoneNumber="+$_countryCode${_phoneController.text}";
      print("phoneNumber $_phoneNumber");
      BlocProvider.of<CredentialCubit>(context).submitVerifyPhoneNumber(
        phoneNumber: _phoneNumber,
      );
    } else {
      toast("Enter your phone number");
    }
  }
  }







