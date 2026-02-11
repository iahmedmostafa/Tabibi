import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/usecase/base_use_case.dart';
import 'package:tabibi/features/notifications/domain/repositories/notifications_repository.dart';

class MarkAllNotificationsAsReadUseCase
    extends BaseUseCase<void, NoParameters> {
  final NotificationsRepository repository;

  MarkAllNotificationsAsReadUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParameters parameters) async {
    return await repository.markAllAsRead();
  }
}
