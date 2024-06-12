import 'package:xplor/features/mpin/domain/entities/send_mpin_otp_entity.dart';

abstract class MpinRepository {
  Future<SendResetMpinOtpEntity> sendResetMpinOtp();

  Future<String> verifyMpinOtp(SendResetMpinOtpEntity data);

  Future<bool> resetMpin(String newMpin, String key);
}
