import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:xplor/const/local_storage/shared_preferences_helper.dart';
import 'package:xplor/core/connection/network_info.dart';
import 'package:xplor/features/on_boarding/data/data_sources/on_boarding_remote.dart';
import 'package:xplor/features/on_boarding/domain/repository/on_boarding_repository.dart';
import 'package:xplor/features/on_boarding/domain/usecase/on_boarding_usecase.dart';

@GenerateMocks(
  [
    OnBoardingRepository,
    OnBoardingApiService,
    OnBoardingUseCase,
    NetworkInfo,
    SharedPreferencesHelper
  ],
  customMocks: [
    MockSpec<Dio>(as: #MockDio),
  ],
)
void main() {}
