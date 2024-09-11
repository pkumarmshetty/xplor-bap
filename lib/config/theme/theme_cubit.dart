import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/app_services.dart';
import 'theme_data.dart';
import 'theme_light.dart';

class ThemeCubit extends Cubit<AppTheme> {
  ThemeCubit() : super(themeLight);

  void toggleTheme() {
    emit(themeLight);
  }
}

AppTheme appTheme() {
  return (AppServices.navState.currentContext)!.read<ThemeCubit>().state;
}
