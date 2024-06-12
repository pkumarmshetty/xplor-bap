import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xplor/features/apply_course/presentation/blocs/apply_course_bloc.dart';
import 'package:xplor/features/apply_course/presentation/screens/apply_course_screen.dart';
import 'package:xplor/features/course_description/presentation/blocs/course_description_bloc.dart';
import 'package:xplor/features/course_description/presentation/pages/course_description_view.dart';
import 'package:xplor/features/mpin/presentation/blocs/reset_mpin_bloc.dart';
import 'package:xplor/features/mpin/presentation/pages/reset_mpin_screen.dart';
import 'package:xplor/features/multi_lang/presentation/blocs/bloc/translate_bloc.dart';
import 'package:xplor/features/my_orders/presentation/blocs/certificate_bloc/cerificate_bloc.dart';
import 'package:xplor/features/my_orders/presentation/blocs/course_rating_bloc/course_ratings_bloc.dart';
import 'package:xplor/features/my_orders/presentation/blocs/my_orders_bloc/my_orders_bloc.dart';
import 'package:xplor/features/my_orders/presentation/pages/certificate_view.dart';
import 'package:xplor/features/my_orders/presentation/pages/my_orders_view.dart';
import 'package:xplor/features/my_orders/presentation/widgets/course_rating_widget.dart';
import 'package:xplor/features/on_boarding/presentation/blocs/choose_domain/choose_domain_bloc.dart';
import 'package:xplor/features/on_boarding/presentation/blocs/kyc_bloc_belem/kyc_bloc_belem.dart';
import 'package:xplor/features/on_boarding/presentation/blocs/select_category/categories_bloc.dart';
import 'package:xplor/features/on_boarding/presentation/pages/choose_domain/choose_domain_screen.dart';
import 'package:xplor/features/on_boarding/presentation/pages/complete_kyc/complete_profile_view_for_belem.dart';
import 'package:xplor/features/on_boarding/presentation/pages/otp/verify_otp_view.dart';
import 'package:xplor/features/on_boarding/presentation/pages/select_category/select_category_screen.dart';
import 'package:xplor/features/on_boarding/presentation/pages/sign_in/phone_number_view.dart';
import 'package:xplor/features/profile/presentation/bloc/agent_profile_bloc/agent_profile_bloc.dart';
import 'package:xplor/features/profile/presentation/pages/agent_profile/agent_profile_page_view.dart';
import 'package:xplor/features/seeker_home/presentation/blocs/seeker_dashboard_bloc/seeker_home_bloc.dart';

import 'package:xplor/features/seeker_home/presentation/blocs/seeker_search_result_bloc/seeker_search_result_bloc.dart';
import 'package:xplor/features/seeker_home/presentation/pages/seeker_home_page_view.dart';
import 'package:xplor/features/seeker_home/presentation/pages/seeker_serach_result_view.dart';

import '../config/theme/theme_cubit.dart';
import '../core/dependency_injection.dart';
import '../features/home/presentation/bloc/home_bloc.dart';
import '../features/home/presentation/pages/home_page_view.dart';
import '../features/on_boarding/presentation/blocs/kyc_bloc/kyc_bloc.dart';
import '../features/on_boarding/presentation/blocs/mpin_bloc/mpin_bloc.dart';
import '../features/on_boarding/presentation/blocs/otp_bloc/otp_bloc.dart';
import '../features/on_boarding/presentation/blocs/phone_bloc/phone_bloc.dart';
import '../features/on_boarding/presentation/blocs/select_role_bloc/select_role_bloc.dart';
import '../features/on_boarding/presentation/pages/choose_role/choose_role_view.dart';
import '../features/on_boarding/presentation/pages/complete_kyc/complete_profile_view.dart';
import '../features/on_boarding/presentation/pages/mpin/generate_mpin_screen.dart';
import '../features/profile/presentation/bloc/seeker_profile_bloc/seeker_profile_bloc.dart';
import '../features/wallet/presentation/blocs/add_document_bloc/add_document_bloc.dart';
import '../features/wallet/presentation/blocs/enter_mpin_bloc/enter_mpin_bloc.dart';
import '../features/wallet/presentation/blocs/my_consent_bloc/my_consent_bloc.dart';
import '../features/wallet/presentation/blocs/share_doc_vc_bloc/share_doc_vc_bloc.dart';
import '../features/wallet/presentation/blocs/update_consent_dialog_bloc/update_consent_dialog_bloc.dart';
import '../features/wallet/presentation/blocs/wallet_bloc/wallet_bloc.dart';
import '../features/wallet/presentation/blocs/wallet_vc_bloc/wallet_vc_bloc.dart';
import '../features/wallet/presentation/pages/wallet_tab_view.dart';
import '../features/wallet/presentation/widgets/add_document_view.dart';
import '../features/wallet/presentation/widgets/my_consents_widgets/my_consent_widget.dart';
import '../features/wallet/presentation/widgets/my_document_widget/my_document_widget.dart';
import '../features/wallet/presentation/pages/share_doc_screen.dart';
import '../features/wallet/presentation/widgets/update_consent_dialog.dart';

/// AppBlocProviders: A class responsible for providing Bloc instances for different parts of the application.
class AppBlocProviders {
  const AppBlocProviders._();

  //----------------------------------------------------------------------------

  /// themeCubit: Provides the application theme Cubit.
  static final _themeCubit = BlocProvider<ThemeCubit>(
    create: (BuildContext context) => ThemeCubit(),
    child: const PhoneNumberView(
      userCheck: false,
    ), // Initial screen with the appliPcation theme
  );

  /// phone: Provides the application phone.
  static final _phoneBloc = BlocProvider<PhoneBloc>(
    create: (BuildContext context) => PhoneBloc(useCase: sl()),
    child: const PhoneNumberView(
        userCheck: false), // Initial screen with the application theme
  );

  /// otp: Provides the application otp.
  static final _otpBloc = BlocProvider(
    create: (BuildContext context) => OtpBloc(useCase: sl()),
    child: const VerifyOtpView(),
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
  static final _kycBlocBelem = BlocProvider(
    create: (BuildContext context) => KycBlocBelem(useCase: sl()),
    child: const CompleteProfileViewBelem(),
  );

  /// kyc: Provides the application kyc.
  static final _kycBloc = BlocProvider(
    create: (BuildContext context) => KycBloc(useCase: sl()),
    child: const CompleteProfileView(),
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
    create: (BuildContext context) =>
        AddDocumentsBloc(walletUseCases: sl(), preferencesHelper: sl()),
    child: const AddDocumentView(),
  );

  /// Wallet: Provides the document sharing state.
  static final _shareDialogBloc = BlocProvider(
    create: (BuildContext context) => SharedDocVcBloc(walletUseCase: sl()),
    child: const ShareDocumentScreen(),
  );

  /// Wallet: Provides the document sharing state.
  static final _walletVcBloc = BlocProvider(
      create: (BuildContext context) => WalletVcBloc(useCase: sl()),
      child: const MyDocumentWidget());

  /// Wallet: Provides the document update consent state.
  static final _consentUpdateDialogBloc = BlocProvider(
    create: (BuildContext context) => UpdateConsentDialogBloc(useCase: sl()),
    child: UpdateConsentDialogWidget(
      onConfirmPressed: () {},
    ),
  );

  /// Seeker Profile: Provides the application home.
  static final _profileBloc = BlocProvider(
    create: (BuildContext context) => SeekerProfileBloc(profileUseCase: sl()),
    child: const AgentProfilePageView(),
  );

  /// Multi Language: Provides the language bloc.
  static final _languageTranslationBloc = BlocProvider(
      create: (BuildContext context) => TranslationBloc(useCase: sl()));

  static final _resetMpinBloc = BlocProvider(
    create: (BuildContext context) => ResetMpinBloc(useCase: sl()),
    child: const ResetMpinScreen(),
  );

  static final _chooseDomainsBloc = BlocProvider(
    create: (BuildContext context) => ChooseDomainBloc(useCase: sl()),
    child: const ChooseDomainScreen(),
  );

  static final _selectCategoryBloc = BlocProvider(
    create: (BuildContext context) =>
        CategoriesBloc(useCase: sl(), preferencesHelper: sl())
          ..add(FetchCategoriesEvent()),
    child: const SelectCategoryScreen(),
  );

  static final _seekerHomeBloc = BlocProvider(
    create: (BuildContext context) => SeekerHomeBloc(
      seekerHomeUseCase: sl(),
    ),
    child: const SeekerHomePageView(),
  );

  static final _searchResuleBloc = BlocProvider(
    create: (BuildContext context) => SeekerSearchResultBloc(
      seekerHomeUseCase: sl(),
    ),
    child: const SeekerSearchResultView(),
  );

  static final _courseDescriptionBloc = BlocProvider(
    create: (BuildContext context) => CourseDescriptionBloc(sl()),
    child: const CourseDescriptionView(transactionId: ""),
  );

  static final _applyCourseBloc = BlocProvider(
    create: (BuildContext context) => ApplyCourseBloc(sl()),
    child: const ApplyCourseScreen(),
  );

  static final _myOrdersBloc = BlocProvider(
    create: (BuildContext context) => MyOrdersBloc(myOrdersUseCase: sl()),
    child: const MyOrdersView(),
  );

  /// Agent Profile: Provides the application home.
  static final _agentProfileBloc = BlocProvider(
    create: (BuildContext context) => AgentProfileBloc(profileUseCase: sl()),
    child: const AgentProfilePageView(),
  );

  /// Agent Profile: Provides the application home.
  static final _courseRatingsBloc = BlocProvider(
    create: (BuildContext context) => CourseRatingsBloc(myOrdersUseCase: sl()),
    child: const CourseRatingWidget(),
  );

  /// Agent Profile: Provides the application home.
  static final _certificateBloc = BlocProvider(
    create: (BuildContext context) => DownloadBloc(),
    child: const CertificateView(certificateUrl: ""),
  );

  /// appBlocs: A list containing all the BlocProviders used in the application.
  static List<BlocProvider> get appBlocs => [
        _themeCubit,
        _phoneBloc,
        _otpBloc,
        _selectRoleBloc,
        _kycBlocBelem,
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
        _languageTranslationBloc,
        _resetMpinBloc,
        _chooseDomainsBloc,
        _selectCategoryBloc,
        _seekerHomeBloc,
        _courseDescriptionBloc,
        _searchResuleBloc,
        _applyCourseBloc,
        _agentProfileBloc,
        _myOrdersBloc,
        _courseRatingsBloc,
        _certificateBloc,
      ];
}
