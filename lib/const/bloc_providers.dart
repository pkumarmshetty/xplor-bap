import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xplor/features/profile/presentation/pages/profile_page_view.dart';
import '../features/home/presentation/bloc/home_bloc.dart';
import '../features/home/presentation/pages/home_page_view.dart';
import '../features/on_boarding/presentation/blocs/mpin_bloc/mpin_bloc.dart';
import '../features/on_boarding/presentation/pages/mpin/generate_mpin_screen.dart';
import '../features/on_boarding/presentation/pages/otp/otp_view.dart';
import '../features/profile/presentation/bloc/profile_bloc.dart';
import '../features/wallet/presentation/blocs/wallet_vc_bloc/wallet_vc_bloc.dart';
import '../features/wallet/presentation/pages/wallet_tab_view.dart';
import '../config/theme/theme_cubit.dart';
import '../features/wallet/presentation/blocs/update_consent_dialog_bloc/update_consent_dialog_bloc.dart';
import '../features/wallet/presentation/blocs/wallet_bloc/wallet_bloc.dart';
import '../core/dependency_injection.dart';
import '../features/wallet/presentation/blocs/enter_mpin_bloc/enter_mpin_bloc.dart';
import '../features/wallet/presentation/blocs/my_consent_bloc/my_consent_bloc.dart';
import '../features/wallet/presentation/widgets/my_consents_widgets/my_consent_widget.dart';
import '../features/wallet/presentation/widgets/add_document_dialog_widget.dart';
import '../features/on_boarding/presentation/blocs/kyc_bloc/kyc_bloc.dart';
import '../features/on_boarding/presentation/blocs/otp_bloc/otp_bloc.dart';
import '../features/on_boarding/presentation/blocs/phone_bloc/phone_bloc.dart';
import '../features/on_boarding/presentation/blocs/select_role_bloc/select_role_bloc.dart';
import '../features/on_boarding/presentation/pages/choose_role/choose_role_view.dart';
import '../features/on_boarding/presentation/pages/complete_kyc/complete_kyc_view.dart';
import '../features/on_boarding/presentation/pages/sign_in/sign_in_view.dart';
import '../features/wallet/domain/entities/wallet_vc_list_entity.dart';
import '../features/wallet/presentation/blocs/add_document_bloc/add_document_bloc.dart';
import '../features/wallet/presentation/blocs/share_doc_vc_bloc/share_doc_vc_bloc.dart';
import '../features/wallet/presentation/widgets/my_document_widget/my_document_widget.dart';
import '../features/wallet/presentation/widgets/share_dialog.dart';
import '../features/wallet/presentation/widgets/update_consent_dialog.dart';

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
    create: (BuildContext context) => PhoneBloc(useCase: sl()),
    child: const SignInView(), // Initial screen with the application theme
  );

  /// otp: Provides the application otp.
  static final _otpBloc = BlocProvider(
    create: (BuildContext context) => OtpBloc(useCase: sl()),
    child: const OtpView(),
  );

  /// home: Provides the application home.
  static final _homeBloc = BlocProvider(
    create: (BuildContext context) => HomeBloc(homeUseCase: sl()),
    child: const HomePageView(),
  );

  /// selectRole: Provides the application select role.
  static final _selectRoleBloc = BlocProvider(
    create: (BuildContext context) => SelectRoleBloc(useCase: sl()),
    child: const ChooseRoleView(),
  );

  /// kyc: Provides the application kyc.
  static final _kycBloc = BlocProvider(
    create: (BuildContext context) => KycBloc(useCase: sl()),
    child: const CompleteKYCView(),
  );

  /// kyc: Provides the application kyc.
  static final _mpinBloc = BlocProvider(
    create: (BuildContext context) => MpinBloc(useCase: sl()),
    child: const GenerateMpinScreen(),
  );

  /// Wallet: Provides the application MyConsent.
  static final _myConsentBloc = BlocProvider(
    create: (BuildContext context) => MyConsentBloc(useCase: sl()),
    child: const MyConsentWidget(),
  );

  /// Wallet: Provides the application enter MPIN.
  static final _myMPinBloc = BlocProvider(
    create: (BuildContext context) => EnterMPinBloc(useCase: sl()),
  );

  /// Wallet: Provides the application wallet.
  static final _walletBloc = BlocProvider(
    create: (BuildContext context) => WalletDataBloc(useCase: sl()),
    child: const MyWalletTab(),
  );

  /// addDocument: Provides the application add document.
  static final _addDocumentBloc = BlocProvider(
    create: (BuildContext context) => AddDocumentsBloc(walletUseCases: sl(), preferencesHelper: sl()),
    child: const AddDocumentDialogWidget(),
  );

  /// Wallet: Provides the document sharing state.
  static final _shareDialogBloc = BlocProvider(
    create: (BuildContext context) => SharedDocVcBloc(walletUseCase: sl()),
    child: ShareDialogWidget(
      onConfirmPressed: () {},
      documentVcData: DocumentVcData(id: "id", name: "name", tags: []),
    ),
  );

  /// Wallet: Provides the document sharing state.
  static final _walletVcBloc =
      BlocProvider(create: (BuildContext context) => WalletVcBloc(useCase: sl()), child: const MyDocumentWidget());

  /// Wallet: Provides the document update consent state.
  static final _consentUpdateDialogBloc = BlocProvider(
    create: (BuildContext context) => UpdateConsentDialogBloc(useCase: sl()),
    child: UpdateConsentDialogWidget(
      onConfirmPressed: () {},
    ),
  );

  /// Profile: Provides the application home.
  static final _profileBloc = BlocProvider(
    create: (BuildContext context) => ProfileBloc(profileUseCase: sl()),
    child: const ProfileTabView(),
  );

  /// appBlocs: A list containing all the BlocProviders used in the application.
  static List<BlocProvider> get appBlocs => [
        _themeCubit,
        _phoneBloc,
        _otpBloc,
        _selectRoleBloc,
        _kycBloc,
        _mpinBloc,
        _myConsentBloc,
        _myMPinBloc,
        _walletBloc,
        _walletVcBloc,
        _addDocumentBloc,
        _shareDialogBloc,
        _consentUpdateDialogBloc,
        _homeBloc,
        _profileBloc,
      ];
}
