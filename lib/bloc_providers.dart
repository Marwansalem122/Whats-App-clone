import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/user/presentation/cubit/auth/auth_cubit.dart';
import 'features/user/presentation/cubit/credential/credential_cubit.dart';
import 'features/user/presentation/cubit/get_device_number/get_device_number_cubit.dart';
import 'features/user/presentation/cubit/get_single_user/get_single_user_cubit.dart';
import 'features/user/presentation/cubit/user/user_cubit.dart';
import 'main_injection_container.dart'as di;
class AppBlocProviders {
  static get allblocProviders => [
    BlocProvider(
      create: (context) => di.sl<AuthCubit>()..appStarted(),
    ),
    BlocProvider(
      create: (context) => di.sl<CredentialCubit>(),
    ),
    BlocProvider(
      create: (context) => di.sl<GetSingleUserCubit>(),
    ),
    BlocProvider(
      create: (context) => di.sl<UserCubit>(),
    ),
    BlocProvider(
      create: (context) => di.sl<GetDeviceNumberCubit>(),
    ),
    // BlocProvider(
    //   create: (context) => di.sl<ChatCubit>(),
    // ),
    // BlocProvider(
    //   create: (context) => di.sl<MessageCubit>(),
    // ),
    // BlocProvider(
    //   create: (context) => di.sl<StatusCubit>(),
    // ),
    // BlocProvider(
    //   create: (context) => di.sl<GetMyStatusCubit>(),
    // ),
    // BlocProvider(
    //   create: (context) => di.sl<CallCubit>(),
    // ),
    // BlocProvider(
    //   create: (context) => di.sl<MyCallHistoryCubit>(),
    // ),
    // BlocProvider(
    //   create: (context) => di.sl<AgoraCubit>(),
    // ),
  ];
}