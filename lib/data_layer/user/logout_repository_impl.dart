import '../../domain_layer/user/repositories/logout_repository.dart';
import 'remote_data/auth/logout_remote_data_source.dart';

class LogoutRepositoryImpl implements LogoutRepository {
  LogoutRepositoryImpl({required this.remoteDataSource});

  final LogoutRemoteDataSource remoteDataSource;

  @override
  Future<bool> logout({required String token}) async {
    return remoteDataSource.logout(token: token);
  }
}
