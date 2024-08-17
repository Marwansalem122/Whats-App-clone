import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_cupertino.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/features/app/helpers/extensions.dart';
import 'package:whatsapp_clone/features/app/routing/routes.dart';
import 'package:whatsapp_clone/features/app/theme/style.dart';

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
            GestureDetector(
              onTap: () {
                context.pushNamed(Routes.otpScreen);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                width: 120,
                height: 40,
                decoration: BoxDecoration(
                  color: tabColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Center(
                  child: Text(
                    "Next",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
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
}
