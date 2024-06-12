import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:xplor/features/apply_course/data/data_sources/apply_form_service.dart';
import 'package:xplor/features/apply_course/data/repositories/apply_form_repositories_impl.dart';
import 'package:xplor/features/apply_course/domain/repository/apply_form_repository.dart';
import 'package:xplor/features/apply_course/domain/usecases/apply_form_usecases.dart';
import 'package:xplor/features/course_description/data/data_sources/course_detail_service.dart';
import 'package:xplor/features/course_description/domain/repository/course_details_repository.dart';
import 'package:xplor/features/course_description/domain/usecases/course_description_usecase.dart';
import 'package:xplor/features/home/data/data_sources/home_api_service.dart';
import 'package:xplor/features/home/domain/usecases/home_usecases.dart';
import 'package:xplor/features/multi_lang/data/datasources/language_translate_remote.dart';
import 'package:xplor/features/multi_lang/data/repositories/lang_translation_repository_impl.dart';
import 'package:xplor/features/multi_lang/domain/repositories/language_translation_repository.dart';
import 'package:xplor/features/multi_lang/domain/usecases/lang_translation_use_case.dart';
import 'package:xplor/features/mpin/data/data_sources/mpin_api_service.dart';
import 'package:xplor/features/mpin/data/repository/mpin_repository_impl.dart';
import 'package:xplor/features/mpin/domain/repository/mpin_repository.dart';
import 'package:xplor/features/mpin/domain/usecase/mpin_usecase.dart';
import 'package:xplor/features/my_orders/data/data_sources/my_orders_api_service.dart';
import 'package:xplor/features/my_orders/domain/usecase/my_order_usecase.dart';
import 'package:xplor/features/on_boarding/data/data_sources/on_boarding_remote.dart';
import 'package:xplor/features/on_boarding/data/repositories/on_boarding_repository_impl.dart';
import 'package:xplor/features/on_boarding/domain/repository/on_boarding_repository.dart';
import 'package:xplor/features/on_boarding/domain/usecase/on_boarding_usecase.dart';
import 'package:xplor/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:xplor/features/profile/domain/repository/profile_repository.dart';
import 'package:xplor/features/profile/domain/usecase/profile_usecase.dart';
import 'package:xplor/features/seeker_home/data/data_sources/seeker_home_api_service.dart';
import 'package:xplor/features/seeker_home/data/repositories/seeker_home_repositories_impl.dart';
import 'package:xplor/features/seeker_home/domain/repository/seeker_home_repository.dart';
import 'package:xplor/features/seeker_home/domain/usecases/seeker_home_usecases.dart';
import 'package:xplor/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:xplor/features/wallet/domain/repository/wallet_repository.dart';

import '../const/local_storage/shared_preferences_helper.dart';
import '../features/course_description/data/repositories/course_details_repositories_impl.dart';
import '../features/home/data/repositories/home_repository_impl.dart';
import '../features/home/domain/repository/home_repository.dart';
import '../features/my_orders/data/repositories/my_orders_repository_impl.dart';
import '../features/my_orders/domain/repository/my_order_repository.dart';
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

  //----------------------------- MULTI-LANG MODULE -----------------------------

  /// multi_lang: Register [LanguageTranslationRemote] for API calls in multi_lang module
  sl.registerSingleton<LanguageTranslationRemote>(
    LanguageTranslationRemoteImpl(
        dio: sl(),

        // Dio dependency//,
        preferencesHelper: sl()),
  );

  /// on_boarding: Register [OnBoardingRepository] for data management in on-boarding module
  sl.registerLazySingleton<LanguageTranslationRepository>(
    () => LanguageTranslationRepositoryImpl(
      languageTranslationRemote: sl(), // OnBoardingApiService dependency
      networkInfo: sl(), // NetworkInfo dependency
    ),
  );

  /// on_boarding: Register [OnBoardingUseCase] for business logic in on-boarding module
  sl.registerSingleton<LangTranslationUseCase>(
    LangTranslationUseCase(repository: sl()), // OnBoardingRepository dependency
  );

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

  //----------------------------- MPin MODULE -----------------------------

  sl.registerSingleton<MpinApiService>(
    MpinApiService(
      dio: sl(), // Dio dependency
      preferencesHelper: sl(), // SharedPreferencesHelper dependency
    ),
  );

  sl.registerLazySingleton<MpinRepository>(
    () => MpinRepositoryImplementation(
      apiService: sl(), // mPinApiService dependency
      networkInfo: sl(), // NetworkInfo dependency
    ),
  );

  sl.registerSingleton<MpinUseCase>(MpinUseCase(repository: sl()));

  //--------------Seeker Home Module---------

  /// Seeker: Register [SeekerHomeApiService] for API calls in seeker module
  sl.registerSingleton<SeekerHomeApiService>(
    SeekerHomeApiServiceImpl(
        dio: sl(), // Dio dependency
        preferencesHelper: sl() // SharedPreferencesHelper dependency
        ),
  );

  /// Seeker: Register [SeekerHomeRepository] for data management in seeker module
  sl.registerLazySingleton<SeekerHomeRepository>(
    () => SeekerHomeRepositoryImpl(
      apiService: sl(), // OnBoardingApiService dependency
      networkInfo: sl(), // NetworkInfo dependency
    ),
  );

  /// Seeker: Register [SeekerUseCase] for business logic in seeker module
  sl.registerSingleton<SeekerHomeUseCase>(SeekerHomeUseCase(repository: sl()));

  //--------------Apply Form Module---------

  /// Seeker: Register [SeekerHomeApiService] for API calls in seeker module
  sl.registerSingleton<ApplyFormsApiService>(
    ApplyFormsApiServiceImpl(
        dio: sl(), // Dio dependency
        preferencesHelper: sl() // SharedPreferencesHelper dependency
        ),
  );

  /// Seeker: Register [SeekerHomeRepository] for data management in seeker module
  sl.registerLazySingleton<ApplyFormRepository>(
    () => ApplyFormRepositoryImpl(
      apiService: sl(), // OnBoardingApiService dependency
      networkInfo: sl(), // NetworkInfo dependency
    ),
  );

  /// Seeker: Register [SeekerUseCase] for business logic in seeker module
  sl.registerSingleton<ApplyFormUseCase>(ApplyFormUseCase(repository: sl()));

  //--------------My Orders Module---------

  /// My Orders: Register [MyOrdersApiService] for API calls in my orders module
  sl.registerSingleton<MyOrdersApiService>(
    MyOrdersApiServiceImpl(
        dio: sl(), // Dio dependency
        preferencesHelper: sl() // SharedPreferencesHelper dependency
        ),
  );

  /// My Orders: Register [MyOrdersRepository] for data management in my orders module
  sl.registerLazySingleton<MyOrdersRepository>(
    () => MyOrdersRepositoryImpl(
      apiService: sl(), // OnBoardingApiService dependency
      networkInfo: sl(), // NetworkInfo dependency
    ),
  );

  /// Course Details: Register [CourseDetailsApiService] for API calls in my orders module
  sl.registerSingleton<CourseDetailsApiService>(
    CourseDetailsApiServiceImpl(
        dio: sl(), // Dio dependency
        preferencesHelper: sl() // SharedPreferencesHelper dependency
        ),
  );

  /// Course Details: Register [CourseDetailsRepository] for data management in my orders module

  sl.registerLazySingleton<CourseDetailsRepository>(
    () => CourseDetailsRepositoryImpl(
      apiService: sl(), // OnBoardingApiService dependency
      networkInfo: sl(), // NetworkInfo dependency
    ),
  );

  /// Course Details: Register [CourseDescriptionUseCase] for business logic in my orders module
  sl.registerSingleton<CourseDescriptionUsecase>(CourseDescriptionUsecase(repository: sl()));

  /// My Orders: Register [MyOrdersUseCase] for business logic in my orders module
  sl.registerSingleton<MyOrdersUseCase>(MyOrdersUseCase(repository: sl()));
}
