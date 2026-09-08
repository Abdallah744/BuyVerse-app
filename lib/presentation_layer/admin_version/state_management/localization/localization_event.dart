part of 'localization_bloc.dart';

abstract class LocalizationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChangeLanguage extends LocalizationEvent {
  final Locale locale;
  ChangeLanguage(this.locale);

  @override
  List<Object?> get props => [locale];
}

class LoadLanguage extends LocalizationEvent {}
