import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabibi/features/video_call/domain/usecases/get_video_token_usecase.dart';
import 'package:tabibi/features/video_call/presentation/cubit/video_call_state.dart';

class VideoCallCubit extends Cubit<VideoCallState> {
  final GetVideoTokenUseCase getVideoTokenUseCase;

  VideoCallCubit(this.getVideoTokenUseCase) : super(VideoCallInitial());

  Future<void> getVideoToken(String bookingId) async {
    emit(VideoCallLoading());
    final result = await getVideoTokenUseCase.execute(bookingId);

    result.fold(
      (failure) => emit(VideoCallFailure(failure.message)),
      (data) => emit(VideoCallSuccess(data)),
    );
  }
}
