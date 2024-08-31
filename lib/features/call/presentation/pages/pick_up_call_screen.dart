
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/features/app/helpers/extensions.dart';
import 'package:whatsapp_clone/features/app/routing/routes.dart';
import 'package:whatsapp_clone/main_injection_container.dart' as di;
import '../../../app/global/widgets/profile_widget.dart';
import '../../domain/entities/call_entity.dart';
import '../../domain/usescases/get_call_channel_id_usecase.dart';
import '../cubits/agora/agora_cubit.dart';
import '../cubits/call/call_cubit.dart';
class PickUpCallScreen extends StatefulWidget {
  final String? uid;
  final Widget child;

  const PickUpCallScreen({Key? key, required this.child, this.uid}) : super(key: key);

  @override
  State<PickUpCallScreen> createState() => _PickUpCallScreenState();
}

class _PickUpCallScreenState extends State<PickUpCallScreen> {


  @override
  void initState() {
    BlocProvider.of<CallCubit>(context).getUserCalling(widget.uid!);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CallCubit, CallState>(
      builder: (context, callState) {
        if(callState is CallDialed) {
          final call = callState.userCall;

          if(call.isCallDialed == false) {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   SizedBox(height: 40.h),
                   Text(
                    'Incoming Call',
                    style: TextStyle(
                      fontSize: 30.sp,
                      color: Colors.white,
                    ),
                  ),
                   SizedBox(height: 40.h),
                  profileWidget(imageUrl: call.receiverProfileUrl),
                   SizedBox(height: 40.h),
                  Text(
                    "${call.receiverName}",
                    style:  TextStyle(
                      fontSize: 25.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                   SizedBox(height: 50.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          BlocProvider.of<AgoraCubit>(context).leaveChannel().then((value) {
                            BlocProvider.of<CallCubit>(context).updateCallHistoryStatus(
                                CallEntity(
                                    callId: call.callId,
                                    callerId: call.callerId,
                                    receiverId: call.receiverId,
                                    isCallDialed: false,
                                    isMissed: true
                                )
                            ).then((value) {
                              BlocProvider.of<CallCubit>(context)
                                  .endCall(CallEntity(
                                callerId: call.callerId,
                                receiverId: call.receiverId,
                              ));
                            });
                          });
                        },
                        icon: const Icon(Icons.call_end,
                            color: Colors.redAccent),
                      ),
                       SizedBox(width: 25.w),
                      IconButton(
                        onPressed: () {
                          di.sl<GetCallChannelIdUseCase>().call(call.receiverId!).then((callChannelId) {

                            context.pushNamed( Routes.callScreen, arguments: CallEntity(
                                callId: callChannelId,
                                callerId: call.callerId!,
                                receiverId: call.receiverId!
                            ));



                            print("callChannelId = $callChannelId");
                          });
                        },
                        icon: const Icon(
                          Icons.call,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return widget.child;
        }
        return widget.child;
      },
    );
  }
}