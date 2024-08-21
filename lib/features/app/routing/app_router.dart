import 'package:flutter/material.dart';
import 'package:whatsapp_clone/features/app/home/contacts_screen.dart';
import 'package:whatsapp_clone/features/app/home/home_screen.dart';
import 'package:whatsapp_clone/features/app/routing/routes.dart';
import 'package:whatsapp_clone/features/app/settings/settings_screen.dart';
import 'package:whatsapp_clone/features/app/splash/splash_screen.dart';
import 'package:whatsapp_clone/features/call/presentation/pages/call_contact_screen.dart';
import 'package:whatsapp_clone/features/chat/presentation/pages/single_chat_screen.dart';
import 'package:whatsapp_clone/features/status/presentation/pages/my_status_screen.dart';
import 'package:whatsapp_clone/features/user/presentation/pages/initial_profile_submit_screen.dart';
import 'package:whatsapp_clone/features/user/presentation/pages/login_screen.dart';
import 'package:whatsapp_clone/features/user/presentation/pages/otp_screen.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    //  this arguments to be passed in any screen  like this (arguments & className)
    final argument = settings.arguments;

    switch (settings.name) {
      case Routes.splashScreen:
        return materialPageBuilder(const SplashScreen());
      case Routes.loginScreen:
        return materialPageBuilder(const LoginScreen());
      case Routes.otpScreen:
        return materialPageBuilder(const OtpScreen());
      case Routes.intialProfileSubmitScreen:
        return materialPageBuilder(const InitialProfileSubmitScreen());
      case Routes.homeScreen:
        return materialPageBuilder(const HomeScreen());
        //contact user page
      case Routes.contactsScreen:
         return materialPageBuilder(const ContactsScreen());
      case Routes.settingsScreen:
         return materialPageBuilder(const SettingsScreen());
      case Routes.myStatusScreen:
         return materialPageBuilder(const MyStatusScreen());
      case Routes.callContactScreen:
         return materialPageBuilder(const CallContactScreen());
      case Routes.singleChatScreen:
         return materialPageBuilder(const SingleChatScreen());
      default:
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                  body: Center(
                    child: Text("N routes defined for ${settings.name}"),
                  ),
                ));
    }
  }
}

dynamic materialPageBuilder(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
