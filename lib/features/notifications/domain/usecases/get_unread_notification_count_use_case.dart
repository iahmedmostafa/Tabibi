import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/usecase/base_use_case.dart';
import 'package:tabibi/features/notifications/domain/repositories/notifications_repository.dart';

class GetUnreadNotificationCountUseCase extends BaseUseCase<int, NoParameters> {
  final NotificationsRepository repository;

  GetUnreadNotificationCountUseCase(this.repository);

  @override
  Future<Either<Failure, int>> call(NoParameters parameters) async {
    return await repository.getUnreadCount();
  }
}
