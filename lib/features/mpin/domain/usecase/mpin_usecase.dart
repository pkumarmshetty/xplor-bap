import '../entities/send_mpin_otp_entity.dart';
import '../repository/mpin_repository.dart';

class MpinUseCase {
  MpinRepository repository;

  MpinUseCase({required this.repository});

  Future<SendResetMpinOtpEntity> sendResetMpinOtp() async {
    return await repository.sendResetMpinOtp();
  }

  Future<String> verifyMpinOtp(SendResetMpinOtpEntity input) async {
    return await repository.verifyMpinOtp(input);
  }

  Future<bool> resetMpin(String key, String newMpin) async {
    return await repository.resetMpin(newMpin, key);
  }
}
