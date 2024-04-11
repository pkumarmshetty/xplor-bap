import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/on_boarding/presentation/blocs/kyc_bloc/kyc_bloc.dart';
import '../features/on_boarding/presentation/blocs/otp_bloc/otp_bloc.dart';
import '../features/on_boarding/presentation/pages/complete_kyc/complete_kyc_view.dart';
import '../features/on_boarding/presentation/blocs/select_role_bloc/select_role_bloc.dart';
import '../features/on_boarding/presentation/pages/choose_role/choose_role_view.dart';
import '../features/on_boarding/presentation/pages/sign_in/sign_in_view.dart';
import '../config/theme/theme_cubit.dart';
import '../features/on_boarding/presentation/blocs/phone_bloc/phone_bloc.dart';

/// AppBlocProviders: A class responsible for providing Bloc instances for different parts of the application.
class AppBlocProviders {
  const AppBlocProviders._();

  //----------------------------------------------------------------------------

  /// themeCubit: Provides the application theme Cubit.
  static final _themeCubit = BlocProvider<ThemeCubit>(
    create: (BuildContext context) => ThemeCubit(),
    child: const SignInView(), // Initial screen with the application theme
  );

  /// phone: Provides the application phone.
  static final _phoneBloc = BlocProvider<PhoneBloc>(
    create: (BuildContext context) => PhoneBloc(),
    child: const SignInView(), // Initial screen with the application theme
  );

  /// otp: Provides the application otp.
  static final _otpBloc = BlocProvider(
    create: (BuildContext context) => OtpBloc(),
    child: const SignInView(),
  );

  /// selectRole: Provides the application select role.
  static final _selectRoleBloc = BlocProvider(
    create: (BuildContext context) => SelectRoleBloc(),
    child: const ChooseRoleView(),
  );

  /// kyc: Provides the application kyc.
  static final _kycBloc = BlocProvider(
    create: (BuildContext context) => KycBloc(),
    child: const CompleteKYCView(),
  );

  /// appBlocs: A list containing all the BlocProviders used in the application.
  static List<BlocProvider> get appBlocs => [
        _themeCubit,
        _phoneBloc,
        _otpBloc,
        _selectRoleBloc,
        _kycBloc,
      ];
}
