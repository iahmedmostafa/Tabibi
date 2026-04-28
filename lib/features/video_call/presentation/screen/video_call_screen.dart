import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/core/utils/constants/app_colors.dart';
import 'package:tabibi/core/utils/extensions/date_time_extension.dart';
import 'package:tabibi/features/video_call/presentation/cubit/video_call_cubit.dart';
import 'package:tabibi/features/video_call/presentation/cubit/video_call_state.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatefulWidget {
  const CallPage({super.key, required this.bookingId});
  final String bookingId;

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  @override
  void initState() {
    super.initState();
    context.read<VideoCallCubit>().getVideoToken(widget.bookingId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<VideoCallCubit, VideoCallState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is VideoCallLoading || state is VideoCallInitial) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Connecting to video call...',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              );
            } else if (state is VideoCallFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load video call:\n${(state.message.formatVideoCallErrorMessage(context))}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Go Back',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is VideoCallSuccess) {
              final data = state.data;
              const appSign =
                  "af428fc820e313a7a4fd61073afa43db6e47ca38389538540a391257b7e786c6";
              debugPrint(
                'Zego Config - userID: ${data.userId}, userName: ${data.userName}, callID: ${data.roomId}',
              );
              return ZegoUIKitPrebuiltCall(
                appID: 137215456,
                appSign: appSign,
                userID: data.userId,
                userName: data.userName,
                callID: data.roomId,
                config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
