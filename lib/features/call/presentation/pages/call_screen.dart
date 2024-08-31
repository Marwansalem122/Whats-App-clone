


import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_clone/features/app/helpers/extensions.dart';

import '../../../app/theme/style.dart';
import '../../domain/entities/call_entity.dart';
import '../cubits/agora/agora_cubit.dart';
import '../cubits/call/call_cubit.dart';

class CallScreen extends StatefulWidget {
  final CallEntity callEntity;
  const CallScreen({Key? key, required this.callEntity}) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {

  @override
  void initState() {

    BlocProvider.of<AgoraCubit>(context).initialize(
        channelName: widget.callEntity.callId!,
        tokenUrl: "http://172.16.1.15:3000/get_token?channelName=${widget.callEntity.callId}"
    );

    super.initState();

  }



  @override
  Widget build(BuildContext context) {

    final agoraProvider = BlocProvider.of<AgoraCubit>(context);

    return Scaffold(
      body: agoraProvider.getAgoraClient == null
          ?  const Center(child: CircularProgressIndicator(color: tabColor,),)
          : SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(client: agoraProvider.getAgoraClient!),
            AgoraVideoButtons(
              client: agoraProvider.getAgoraClient!,
              disconnectButtonChild: IconButton(
                color: Colors.red,
                onPressed: () async {
                  await agoraProvider.leaveChannel().then((value) {
                    BlocProvider.of<CallCubit>(context)
                        .endCall(CallEntity(
                      callerId: widget.callEntity.callerId,
                      receiverId: widget.callEntity.receiverId,
                    ));
                  });
                  context.pop();
                },
                icon: const Icon(Icons.call_end),
              ),
            ),
          ],
        ),
      ),
    );
  }
}