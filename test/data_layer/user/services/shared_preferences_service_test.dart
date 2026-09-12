import 'package:buy_verse_app/data_layer/user/services/shared_preferences_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SharedPreferencesService', () {
    late MockSharedPreferences mockPrefs;

    setUp(() {
      mockPrefs = MockSharedPreferences();
    });

    test('setAuthToken saves token to SharedPreferences', () async {
      when(
        () => mockPrefs.setString('auth_token', 'test_token'),
      ).thenAnswer((_) async => true);

      await SharedPreferencesService.init(prefs: mockPrefs);
      await SharedPreferencesService.instance.setAuthToken('test_token');

      verify(() => mockPrefs.setString('auth_token', 'test_token')).called(1);
    });

    test('getAuthToken retrieves token from SharedPreferences', () async {
      when(() => mockPrefs.getString('auth_token')).thenReturn('test_token');

      await SharedPreferencesService.init(prefs: mockPrefs);
      final token = await SharedPreferencesService.instance.getAuthToken();

      expect(token, 'test_token');
      verify(() => mockPrefs.getString('auth_token')).called(1);
    });

    test('getAuthToken returns null when token does not exist', () async {
      when(() => mockPrefs.getString('auth_token')).thenReturn(null);

      await SharedPreferencesService.init(prefs: mockPrefs);
      final token = await SharedPreferencesService.instance.getAuthToken();

      expect(token, isNull);
      verify(() => mockPrefs.getString('auth_token')).called(1);
    });

    test('setAuthName saves name to SharedPreferences', () async {
      when(
        () => mockPrefs.setString('auth_name', 'Test User'),
      ).thenAnswer((_) async => true);

      await SharedPreferencesService.init(prefs: mockPrefs);
      await SharedPreferencesService.instance.setAuthName('Test User');

      verify(() => mockPrefs.setString('auth_name', 'Test User')).called(1);
    });

    test('getAuthName retrieves name from SharedPreferences', () async {
      when(() => mockPrefs.getString('auth_name')).thenReturn('Test User');

      await SharedPreferencesService.init(prefs: mockPrefs);
      final name = await SharedPreferencesService.instance.getAuthName();

      expect(name, 'Test User');
      verify(() => mockPrefs.getString('auth_name')).called(1);
    });

    test('getAuthName returns null when name does not exist', () async {
      when(() => mockPrefs.getString('auth_name')).thenReturn(null);

      await SharedPreferencesService.init(prefs: mockPrefs);
      final name = await SharedPreferencesService.instance.getAuthName();

      expect(name, isNull);
      verify(() => mockPrefs.getString('auth_name')).called(1);
    });

    test(
      'clearAuthData removes auth token and name from SharedPreferences',
      () async {
        when(
          () => mockPrefs.remove('auth_token'),
        ).thenAnswer((_) async => true);
        when(() => mockPrefs.remove('auth_name')).thenAnswer((_) async => true);

        await SharedPreferencesService.init(prefs: mockPrefs);
        await SharedPreferencesService.instance.clearAuthData();

        verify(() => mockPrefs.remove('auth_token')).called(1);
        verify(() => mockPrefs.remove('auth_name')).called(1);
      },
    );

    test(
      'setFavoriteProductIds saves list of IDs to SharedPreferences',
      () async {
        final ids = ['1', '2', '3'];
        when(
          () => mockPrefs.setStringList('favorite_product_ids', ids),
        ).thenAnswer((_) async => true);

        await SharedPreferencesService.init(prefs: mockPrefs);
        await SharedPreferencesService.instance.setFavoriteProductIds(ids);

        verify(
          () => mockPrefs.setStringList('favorite_product_ids', ids),
        ).called(1);
      },
    );

    test(
      'getFavoriteProductIds retrieves list of IDs from SharedPreferences',
      () async {
        final ids = ['1', '2', '3'];
        when(
          () => mockPrefs.getStringList('favorite_product_ids'),
        ).thenReturn(ids);

        await SharedPreferencesService.init(prefs: mockPrefs);
        final result = await SharedPreferencesService.instance
            .getFavoriteProductIds();

        expect(result, ids);
        verify(() => mockPrefs.getStringList('favorite_product_ids')).called(1);
      },
    );

    test(
      'getFavoriteProductIds returns empty list when no IDs exist',
      () async {
        when(
          () => mockPrefs.getStringList('favorite_product_ids'),
        ).thenReturn(null);

        await SharedPreferencesService.init(prefs: mockPrefs);
        final result = await SharedPreferencesService.instance
            .getFavoriteProductIds();

        expect(result, isEmpty);
        verify(() => mockPrefs.getStringList('favorite_product_ids')).called(1);
      },
    );

    test('addFavoriteProductId adds ID to favorites', () async {
      when(
        () => mockPrefs.getStringList('favorite_product_ids'),
      ).thenReturn(['1', '2']);
      when(
        () => mockPrefs.setStringList('favorite_product_ids', any()),
      ).thenAnswer((_) async => true);

      await SharedPreferencesService.init(prefs: mockPrefs);
      await SharedPreferencesService.instance.addFavoriteProductId(3);

      verify(() => mockPrefs.getStringList('favorite_product_ids')).called(1);
      verify(
        () => mockPrefs.setStringList('favorite_product_ids', ['1', '2', '3']),
      ).called(1);
    });

    test('removeFavoriteProductId removes ID from favorites', () async {
      when(
        () => mockPrefs.getStringList('favorite_product_ids'),
      ).thenReturn(['1', '2', '3']);
      when(
        () => mockPrefs.setStringList('favorite_product_ids', any()),
      ).thenAnswer((_) async => true);

      await SharedPreferencesService.init(prefs: mockPrefs);
      await SharedPreferencesService.instance.removeFavoriteProductId(2);

      verify(() => mockPrefs.getStringList('favorite_product_ids')).called(1);
      verify(
        () => mockPrefs.setStringList('favorite_product_ids', ['1', '3']),
      ).called(1);
    });
  });
}
