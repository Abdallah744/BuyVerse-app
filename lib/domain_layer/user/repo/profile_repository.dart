import 'package:buy_verse_app/data_layer/user/user_models/user_models.dart';

abstract class UserProfileRepository {
  Future<UserModels?> getProfile({required String token});
}
