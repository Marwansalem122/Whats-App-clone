import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/features/app/routing/app_router.dart';
import 'package:whatsapp_clone/features/app/routing/routes.dart';
import 'package:whatsapp_clone/features/app/theme/style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              theme: ThemeData.dark().copyWith(
                  scaffoldBackgroundColor: backgroundColor,
                  dialogBackgroundColor: appBarColor,
                  appBarTheme: const AppBarTheme(
                    color: appBarColor,
                  )),
               onGenerateRoute: AppRouter().generateRoute,
              initialRoute: Routes.splashScreen,
              
            ));
  }
}
