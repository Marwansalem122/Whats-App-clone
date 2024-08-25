import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/bloc_providers.dart';
import 'package:whatsapp_clone/features/app/routing/app_router.dart';
import 'package:whatsapp_clone/features/app/routing/routes.dart';
import 'package:whatsapp_clone/features/app/theme/style.dart';
import 'features/user/data/data_sources/remote/user_remote_data_source_impl.dart';
import 'main_injection_container.dart'as di;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBlocProviders.allblocProviders,
      child: ScreenUtilInit(
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

                initialRoute: Routes.intialScreen,
              )),
    );
  }
}
