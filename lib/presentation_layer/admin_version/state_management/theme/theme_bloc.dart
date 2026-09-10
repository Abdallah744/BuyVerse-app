import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core_layer/admin/helpers/cache_helper.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(ThemeMode.light)) {
    on<LoadTheme>((event, emit) {
      bool isDark = CacheHelper.getData(key: 'isDark') ?? false;
      emit(ThemeState(isDark ? ThemeMode.dark : ThemeMode.light));
    });

    on<ToggleTheme>((event, emit) async {
      bool isDark = state.themeMode == ThemeMode.dark;
      await CacheHelper.saveData(key: 'isDark', value: !isDark);
      emit(ThemeState(!isDark ? ThemeMode.dark : ThemeMode.light));
    });
  }
}
