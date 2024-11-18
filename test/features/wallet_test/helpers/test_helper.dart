import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:xplor/const/local_storage/shared_preferences_helper.dart';
import 'package:xplor/core/connection/network_info.dart';
import 'package:xplor/features/wallet/data/data_sources/wallet_data_sources.dart';
import 'package:xplor/features/wallet/domain/repository/wallet_repository.dart';
import 'package:xplor/features/wallet/domain/usecase/wallet_usecase.dart';

@GenerateMocks(
  [
    WalletUseCase,
    SharedPreferencesHelper,
    WalletRepository,
    WalletApiService,
    NetworkInfo,
  ],
  customMocks: [
    MockSpec<Dio>(as: #MockDio),
  ],
)
void main() {}
