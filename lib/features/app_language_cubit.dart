import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class AppLanguageCubit extends Cubit<Locale> {
  AppLanguageCubit() : super(const Locale('zh'));

  void changeLanguage(Locale locale) => emit(locale);
}