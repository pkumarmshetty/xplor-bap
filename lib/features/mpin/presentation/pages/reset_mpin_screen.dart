import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/enter_otp_widget.dart';
import '../blocs/reset_mpin_bloc.dart';
import '../../../../utils/widgets/app_background_widget.dart';
import '../../../../utils/widgets/loading_animation.dart';

class ResetMpinScreen extends StatefulWidget {
  const ResetMpinScreen({super.key});

  @override
  State<ResetMpinScreen> createState() => _ResetMpinScreenState();
}

class _ResetMpinScreenState extends State<ResetMpinScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackgroundDecoration(
        child: SafeArea(
          child: BlocListener<ResetMpinBloc, ResetMpinState>(
            listener: (context, state) {
              if (state is ResetMpinUpdatedState && state.mpinState == MpinState.success) {
                Navigator.pop(context);
                /* AppUtils.showSnackBar(context,
                    GenerateMpinKeys.mPinResetSuccessfully.stringToString,
                    bgColor: AppColors.primaryColor);*/
              }
            },
            child: BlocBuilder<ResetMpinBloc, ResetMpinState>(
              builder: (context, state) {
                return Form(
                  // key: state.formKey,
                  child: Stack(
                    children: [
                      const CustomScrollView(
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: EnterOtpForResetMpinWidget(),
                          ),
                        ],
                      ),
                      if (state is ResetMpinUpdatedState && state.isLoading) const LoadingAnimation(),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
