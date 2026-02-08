import 'package:equatable/equatable.dart';

class LogInEntity extends Equatable {
  final String accessToken;
  final String refreshToken;

  const LogInEntity({required this.accessToken, required this.refreshToken});

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
