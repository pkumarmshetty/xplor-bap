import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:xplor/features/on_boarding/data/data_sources/on_boarding_remote.dart';
import 'package:xplor/features/on_boarding/data/repositories/on_boarding_repository_impl.dart';
import 'package:xplor/features/on_boarding/domain/repository/on_boarding_repository.dart';
import 'package:xplor/features/on_boarding/domain/usecase/on_boarding_usecase.dart';

import '../const/local_storage/shared_preferences_helper.dart';
import 'connection/network_info.dart';

// Import other necessary dependencies

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  /// Register [Dio] for network requests
  sl.registerSingleton<Dio>(Dio());

  /// Register [SharedPreferencesHelper] for local storage
  sl.registerSingleton<SharedPreferencesHelper>(
    SharedPreferencesHelper()..init(),
  );

  /// Register [NetworkInfo] for checking network status
  sl.registerSingleton<NetworkInfo>(NetworkInfoImpl(Connectivity()));

  /// on_boarding: Register [OnBoardingApiService] for API calls in on-boarding module
  sl.registerSingleton<OnBoardingApiService>(
    OnBoardingApiServiceImpl(
      dio: sl(), // Dio dependency
      preferencesHelper: sl(), // SharedPreferencesHelper dependency
    ),
  );

  /// on_boarding: Register [OnBoardingRepository] for data management in on-boarding module
  sl.registerLazySingleton<OnBoardingRepository>(
    () => OnBoardingRepositoryImpl(
      apiService: sl(), // OnBoardingApiService dependency
      networkInfo: sl(), // NetworkInfo dependency
    ),
  );

  /// on_boarding: Register [OnBoardingUseCase] for business logic in on-boarding module
  sl.registerSingleton<OnBoardingUseCase>(
    OnBoardingUseCase(repository: sl()), // OnBoardingRepository dependency
  );
}
