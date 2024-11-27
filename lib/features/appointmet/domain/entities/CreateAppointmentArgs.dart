
import 'package:xplor/features/on_boarding/domain/entities/user_data_entity.dart';

class CreateAppointmentArgs {
  UserDataEntity userDataEntity;
  String doctorOsid;

  CreateAppointmentArgs(this.userDataEntity, this.doctorOsid);
}