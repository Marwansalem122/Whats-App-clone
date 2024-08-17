
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/features/app/routing/routes.dart';
import 'package:whatsapp_clone/features/app/splash/splash_screen.dart';
import 'package:whatsapp_clone/features/user/presentation/pages/login_screen.dart';
import 'package:whatsapp_clone/features/user/presentation/pages/otp_screen.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    //  this arguments to be passed in any screen  like this (arguments & className)
    final argument = settings.arguments;

    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(
            builder: (context) => const SplashScreen());
      case Routes.loginScreen:
        return MaterialPageRoute(
            builder: (context) => const LoginScreen());
      case Routes.otpScreen:
        return MaterialPageRoute(
            builder: (context) => const OtpScreen());
      
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
