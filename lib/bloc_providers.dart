import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/call/presentation/cubits/agora/agora_cubit.dart';
import 'features/call/presentation/cubits/call/call_cubit.dart';
import 'features/call/presentation/cubits/my_call_history/my_call_history_cubit.dart';
import 'features/chat/presentation/cubit/chat/chat_cubit.dart';
import 'features/chat/presentation/cubit/message/message_cubit.dart';
import 'features/status/presentation/cubit/get_my_status/get_my_status_cubit.dart';
import 'features/status/presentation/cubit/status/status_cubit.dart';
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
    BlocProvider(
      create: (context) => di.sl<ChatCubit>(),
    ),
    BlocProvider(
      create: (context) => di.sl<MessageCubit>(),
    ),
    BlocProvider(
      create: (context) => di.sl<StatusCubit>(),
    ),
    BlocProvider(
      create: (context) => di.sl<GetMyStatusCubit>(),
    ),
    BlocProvider(
      create: (context) => di.sl<CallCubit>(),
    ),
    BlocProvider(
      create: (context) => di.sl<MyCallHistoryCubit>(),
    ),
    BlocProvider(
      create: (context) => di.sl<AgoraCubit>(),
    ),
  ];
}