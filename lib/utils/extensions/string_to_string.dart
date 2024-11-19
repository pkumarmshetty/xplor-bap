import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xplor/config/services/app_services.dart';

import '../../features/multi_lang/presentation/blocs/bloc/translate_bloc.dart';

extension StringToStringExtension on String {
  String get stringToString {
    return AppServices.navState.currentContext!.read<TranslationBloc>().translationTextMap[this] ?? this;
  }

  String capitalizeFirstLetter() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}
