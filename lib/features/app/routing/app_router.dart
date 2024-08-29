import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_clone/features/app/home/contacts_screen.dart';
import 'package:whatsapp_clone/features/app/home/home_screen.dart';
import 'package:whatsapp_clone/features/app/routing/routes.dart';
import 'package:whatsapp_clone/features/app/settings/settings_screen.dart';
import 'package:whatsapp_clone/features/app/splash/splash_screen.dart';
import 'package:whatsapp_clone/features/app/welcome/welcome_screen.dart';
import 'package:whatsapp_clone/features/call/presentation/pages/call_contact_screen.dart';
import 'package:whatsapp_clone/features/chat/presentation/pages/single_chat_screen.dart';
import 'package:whatsapp_clone/features/status/presentation/pages/my_status_screen.dart';
import 'package:whatsapp_clone/features/user/domain/entities/user_entity.dart';
import 'package:whatsapp_clone/features/user/presentation/pages/edit_profile_sreen.dart';
import 'package:whatsapp_clone/features/user/presentation/pages/initial_profile_submit_screen.dart';
import 'package:whatsapp_clone/features/user/presentation/pages/login_screen.dart';
import 'package:whatsapp_clone/features/user/presentation/pages/otp_screen.dart';

import '../../chat/domain/entities/message_entity.dart';
import '../../status/domain/entities/status_entity.dart';
import '../../user/presentation/cubit/auth/auth_cubit.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    //  this arguments to be passed in any screen  like this (arguments & className)
    final argument = settings.arguments;

    switch (settings.name) {
      case Routes.intialScreen:
      case Routes.intialScreen:
        return materialPageBuilder(BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            if (authState is Authenticated) {
              return HomeScreen(uid: authState.uid);
            }
            return const SplashScreen();
          },
        ));
      case Routes.loginScreen:
        return materialPageBuilder(const LoginScreen());
      case Routes.welcomeScreen:
        return materialPageBuilder(const WelcomeScreen());
      case Routes.splashScreen:
        return materialPageBuilder(const SplashScreen());

      case Routes.otpScreen:
        return materialPageBuilder(const OtpScreen());
      case Routes.intialProfileSubmitScreen:
        if (argument is String) {
          return materialPageBuilder(InitialProfileSubmitScreen(
            phoneNumber: argument,
          ));
        } else {
          return materialPageBuilder(const ErrorPage());
        }

      case Routes.homeScreen:
        if (argument is String) {
          return materialPageBuilder(HomeScreen(uid: argument));
        } else {
          return materialPageBuilder(const ErrorPage());
        }

      //contact user page
      case Routes.contactsScreen:
        if (argument is String) {
          return materialPageBuilder( ContactsScreen(uid: argument,));
        } else {
          return materialPageBuilder(const ErrorPage());
        }

      case Routes.settingsScreen:
        if (argument is String) {
          return materialPageBuilder(SettingsScreen(
            uid: argument,
          ));
        } else {
          return materialPageBuilder(const ErrorPage());
        }
      case Routes.myStatusScreen:
        if (argument is StatusEntity) {
          return materialPageBuilder( MyStatusScreen(status: argument,));
        } else {
          return materialPageBuilder(const ErrorPage());
        }

      case Routes.callContactScreen:
        return materialPageBuilder(const CallContactScreen());
      case Routes.singleChatScreen:
        if (argument is MessageEntity) {
          return materialPageBuilder( SingleChatScreen(message: argument,));
        } else {
          return materialPageBuilder(const ErrorPage());
        }

      case Routes.editProfileScreen:
        if (argument is UserEntity) {
          return materialPageBuilder( EditProfileSreen(currentUser:argument));
        } else {
          return materialPageBuilder(const ErrorPage());
        }

      default:
        return materialPageBuilder(const ErrorPage());
    }
  }
}

dynamic materialPageBuilder(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Error"),
      ),
      body: const Center(
        child: Text("Error"),
      ),
    );
  }
}
