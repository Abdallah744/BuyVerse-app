import '../remote/logout_remote_data_source.dart';
import '../../domain/repositories/logout_repository.dart';

class LogoutRepositoryImpl implements LogoutRepository {
  LogoutRepositoryImpl({required this.remoteDataSource});

  final LogoutRemoteDataSource remoteDataSource;

  @override
  Future<bool> logout({required String token}) async {
    return remoteDataSource.logout(token: token);
  }
}
