import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/my_consent_bloc/my_consent_event.dart';
import '../../../../../const/app_state.dart';
import '../../../../../utils/app_utils/app_utils.dart';
import '../../../../../utils/widgets/loading_animation.dart';
import '../../blocs/my_consent_bloc/my_consent_bloc.dart';
import '../../blocs/my_consent_bloc/my_consent_state.dart';
import 'my_consent_list.dart';

/// Widget that displays a list of consents, including active consents and previous consents.
/// It listens to `MyConsentBloc` for state changes and updates the UI accordingly.
class MyConsentWidget extends StatefulWidget {
  const MyConsentWidget({super.key});

  @override
  State<MyConsentWidget> createState() => _MyConsentWidgetState();
}

class _MyConsentWidgetState extends State<MyConsentWidget> {
  @override
  void initState() {
    super.initState();
    context.read<MyConsentBloc>().add(const GetUserConsentEvent());
  }

  @override
  Widget build(BuildContext context) {
    // return ConsentNoDocVcView();
    return BlocListener<MyConsentBloc, MyConsentState>(
      listener: (context, state) {
        // Handle state changes
        if (state is MyConsentRevokeErrorState) {
          // Show error message
          AppUtils.showSnackBar(context, state.errorMessage);
        } else if (state is MyConsentRevokeSuccessState) {
          context.read<MyConsentBloc>().add(const GetUserConsentEvent());
        } else if (state is MyConsentRevokeErrorState) {
          AppUtils.showSnackBar(context, state.errorMessage);
        }
      },
      child: BlocBuilder<MyConsentBloc, MyConsentState>(
        builder: (context, state) {
          // Handle state changes
          if (state is MyConsentLoadingState && state.status == AppPageStatus.loading) {
            // Show loading animation
            return const LoadingAnimation();
          } else {
            // Show main content
            return const MyConsentList();
          }
        },
      ),
    );
  }
}
