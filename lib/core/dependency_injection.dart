import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:xplor/features/on_boarding/data/data_sources/on_boarding_remote.dart';
import 'package:xplor/features/on_boarding/data/repositories/on_boarding_repository_impl.dart';
import 'package:xplor/features/on_boarding/domain/repository/on_boarding_repository.dart';
import 'package:xplor/features/on_boarding/domain/usecase/on_boarding_usecase.dart';

import '../const/local_storage/shared_preferences_helper.dart';
import 'connection/network_info.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  //Dio
  sl.registerSingleton<Dio>(Dio());
  //Add more dependencies as needed
  sl.registerSingleton<SharedPreferencesHelper>(SharedPreferencesHelper()..init());

  // Data sources
  sl.registerSingleton<NetworkInfo>(NetworkInfoImpl(Connectivity()));

  // Api Services
  sl.registerSingleton<OnBoardingApiService>(OnBoardingApiService());

  // Repository
  sl.registerLazySingleton<OnBoardingRepository>(() => OnBoardingRepositoryImpl());

  // Use cases
  sl.registerSingleton<OnBoardingUseCase>(OnBoardingUseCase());
}
