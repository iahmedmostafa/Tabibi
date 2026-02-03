import 'package:dartz/dartz.dart';
import 'package:tabibi/core/error/failure.dart';
import 'package:tabibi/features/home/data/models/doctor_model.dart';
import 'package:tabibi/features/home/domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final List<DoctorModel> _favorites = [
    DoctorModel(
      id: '1',
      name: 'Dr. David Patel',
      department: 'Cardiologist',
      consultationFee: 0,
      yearsOfExperience: 5,
      address: 'Cardiology Center, USA',
      avatarUrl: null,
    ),
    DoctorModel(
      id: '2',
      name: 'Dr. Jessica Turner',
      department: 'Gynecologist',
      consultationFee: 0,
      yearsOfExperience: 4,
      address: 'Women\'s Clinic, Seattle, USA',
      avatarUrl: null,
    ),
    DoctorModel(
      id: '3',
      name: 'Dr. Michael Johnson',
      department: 'Orthopedic Surgery',
      consultationFee: 0,
      yearsOfExperience: 4,
      address: 'Maple Associates, NY, USA',
      avatarUrl: null,
    ),
    DoctorModel(
      id: '4',
      name: 'Dr. Emily Walker',
      department: 'Pediatrics',
      consultationFee: 0,
      yearsOfExperience: 5,
      address: 'Serenity Pediatrics Clinic',
      avatarUrl: null,
    ),
  ];

  @override
  Future<Either<Failure, List<DoctorModel>>> getFavorites() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return Right(_favorites);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(String doctorId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      _favorites.removeWhere((doc) => doc.id == doctorId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
