import 'package:xplor/core/connection/network_info.dart';
import 'package:xplor/core/exception_errors.dart';
import 'package:xplor/features/mpin/data/data_sources/mpin_api_service.dart';
import 'package:xplor/features/mpin/domain/entities/send_mpin_otp_entity.dart';
import 'package:xplor/features/mpin/domain/repository/mpin_repository.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';

class MpinRepositoryImplementation implements MpinRepository {
  MpinApiService apiService;
  NetworkInfo networkInfo;

  @override
  Future<SendResetMpinOtpEntity> sendResetMpinOtp() async {
    if (await networkInfo.isConnected!) {
      return apiService.sendResetMpinOtp();
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  MpinRepositoryImplementation({
    required this.apiService,
    required this.networkInfo,
  });

  @override
  Future<String> verifyMpinOtp(SendResetMpinOtpEntity data) async {
    if (await networkInfo.isConnected!) {
      return apiService.verifyMpinOtp(data);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  @override
  Future<bool> resetMpin(String newMpin, String key) async {
    if (await networkInfo.isConnected!) {
      return apiService.resetMpin(newMpin, key);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }
}
