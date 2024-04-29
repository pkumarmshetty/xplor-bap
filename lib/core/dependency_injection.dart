import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:xplor/features/home/data/data_sources/home_api_service.dart';
import 'package:xplor/features/home/domain/usecases/home_usecases.dart';
import 'package:xplor/features/on_boarding/data/data_sources/on_boarding_remote.dart';
import 'package:xplor/features/on_boarding/data/repositories/on_boarding_repository_impl.dart';
import 'package:xplor/features/on_boarding/domain/repository/on_boarding_repository.dart';
import 'package:xplor/features/on_boarding/domain/usecase/on_boarding_usecase.dart';
import 'package:xplor/features/profile/data/repositories/home_repository_impl.dart';
import 'package:xplor/features/profile/domain/repository/profile_repository.dart';
import 'package:xplor/features/profile/domain/usecase/profile_usecase.dart';

import 'package:xplor/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:xplor/features/wallet/domain/repository/wallet_repository.dart';

import '../const/local_storage/shared_preferences_helper.dart';
import '../features/home/data/repositories/home_repository_impl.dart';
import '../features/home/domain/repository/home_repository.dart';
import '../features/profile/data/data_sources/profile_api_service.dart';
import '../features/wallet/data/data_sources/wallet_data_sources.dart';
import '../features/wallet/domain/usecase/wallet_usecase.dart';
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

  //----------------------------- ON_BOARDING MODULE -----------------------------

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

  //----------------------------- WALLET MODULE -----------------------------

  /// wallet: Register [WalletApiService] for API calls in wallet module
  sl.registerSingleton<WalletApiService>(
    WalletApiServiceImpl(
      dio: sl(), // Dio dependency
      preferencesHelper: sl(), // SharedPreferencesHelper dependency
    ),
  );

  /// wallet: Register [WalletRepository] for data management in wallet module
  sl.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(
      apiService: sl(), // OnBoardingApiService dependency
      networkInfo: sl(), // NetworkInfo dependency
    ),
  );

  /// wallet: Register [WalletUseCase] for business logic in wallet module
  sl.registerSingleton<WalletUseCase>(WalletUseCase(repository: sl()));

  //----------------------------- HOME MODULE -----------------------------
  /// home: Register [HomeApiService] for API calls in home module
  sl.registerSingleton<HomeApiService>(
    HomeApiServiceImpl(
      dio: sl(), // Dio dependency
      preferencesHelper: sl(), // SharedPreferencesHelper dependency
    ),
  );

  /// home: Register [HomeRepository] for data management in home module
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      apiService: sl(), // OnBoardingApiService dependency
      networkInfo: sl(), // NetworkInfo dependency
    ),
  );

  /// home: Register [HomeUseCase] for business logic in home module
  sl.registerSingleton<HomeUseCase>(HomeUseCase(repository: sl()));

  //----------------------------- Profile MODULE -----------------------------
  /// profile: Register [ProfileApiService] for API calls in profile module
  sl.registerSingleton<ProfileApiService>(
    ProfileApiServiceImpl(
      dio: sl(), // Dio dependency
      preferencesHelper: sl(), // SharedPreferencesHelper dependency
    ),
  );

  /// profile: Register [ProfileRepository] for data management in profile module
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      apiService: sl(), // OnBoardingApiService dependency
      networkInfo: sl(), // NetworkInfo dependency
    ),
  );

  /// profile: Register [ProfileUseCase] for business logic in profile module
  sl.registerSingleton<ProfileUseCase>(ProfileUseCase(repository: sl()));
}
