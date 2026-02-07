import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tabibi/core/usecase/base_use_case.dart';
import 'package:tabibi/features/home/domain/entities/notification_entity.dart';
import 'package:tabibi/features/home/domain/usecases/get_notifications_use_case.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase getNotificationsUseCase;

  NotificationsCubit(this.getNotificationsUseCase)
    : super(NotificationsInitial());

  Future<void> getNotifications() async {
    emit(NotificationsLoading());
    final result = await getNotificationsUseCase(const NoParameters());
    result.fold(
      (failure) => emit(NotificationsError(failure.message)),
      (notifications) => emit(NotificationsLoaded(notifications)),
    );
  }
}
