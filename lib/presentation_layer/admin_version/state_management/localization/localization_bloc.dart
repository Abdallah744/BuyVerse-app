import 'package:buy_verse_app/core_layer/admin/helpers/cache_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'localization_event.dart';
part 'localization_state.dart';

class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  LocalizationBloc() : super(const LocalizationState(Locale('en'))) {
    on<LoadLanguage>((event, emit) {
      String? code = CacheHelper.getData(key: 'languageCode');
      if (code != null) {
        emit(LocalizationState(Locale(code)));
      } else {
        emit(
          const LocalizationState(Locale('en')),
        ); // Default to English as requested
      }
    });

    on<ChangeLanguage>((event, emit) async {
      await CacheHelper.saveData(
        key: 'languageCode',
        value: event.locale.languageCode,
      );
      emit(LocalizationState(event.locale));
    });
  }
}
