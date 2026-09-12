import 'package:buy_verse_app/data_layer/user/remote_data/profile_remote_data_source.dart';
import 'package:buy_verse_app/data_layer/user/user_models/user_models.dart';
import 'package:buy_verse_app/domain_layer/user/repo/profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  const UserProfileRepositoryImpl(this.remoteDataSource);

  final ProfileRemoteDataSource remoteDataSource;

  @override
  Future<UserModels?> getProfile({required String token}) async {
    return remoteDataSource.getProfile(token: token);
  }
}
