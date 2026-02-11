import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/core/usecase/base_use_case.dart';
import 'package:tabibi/features/notifications/domain/repositories/notifications_repository.dart';

class MarkNotificationAsReadUseCase extends BaseUseCase<void, String> {
  final NotificationsRepository repository;

  MarkNotificationAsReadUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String parameters) async {
    return await repository.markAsRead(parameters);
  }
}
