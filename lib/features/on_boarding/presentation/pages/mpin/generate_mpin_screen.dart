import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../blocs/mpin_bloc/mpin_bloc.dart';
import '../../widgets/common_pin_code_text_field_view.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_dimensions.dart';
import '../../../../../utils/app_utils/app_utils.dart';
import '../../../../../utils/circluar_button.dart';
import '../../../../../utils/common_top_header.dart';
import '../../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../../utils/extensions/padding.dart';
import '../../../../../utils/extensions/string_to_string.dart';
import '../../../../../utils/widgets/app_background_widget.dart';
import '../../../../../utils/widgets/loading_animation.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../multi_lang/domain/mappers/mpin/generate_mpin_keys.dart';

part 'generate_mpin_slivers.dart';

class GenerateMpinScreen extends StatefulWidget {
  const GenerateMpinScreen({super.key});
  @override
  State<GenerateMpinScreen> createState() => _GenerateMpinScreenState();
}

class _GenerateMpinScreenState extends State<GenerateMpinScreen> {
  TextEditingController originalPinController = TextEditingController();
  TextEditingController confirmPinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MpinBloc>().add(const PinInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AppBackgroundDecoration(
          child: BlocListener<MpinBloc, MpinState>(
            listener: (context, state) {
              if (state is PinSuccessState) {
                Navigator.pop(context);
                AppUtilsDialogMixin.askForMPINDialog(context);
              }
            },
            child: BlocBuilder<MpinBloc, MpinState>(
              builder: (context, state) {
                return Form(
                  // key: state.formKey,
                  child: Stack(
                    children: [
                      CustomScrollView(
                        slivers: <Widget>[
                          generateMPinSliverToBoxAdapter(context, state, originalPinController, confirmPinController),
                          generateMPinSliverFillRemaining(context, state, originalPinController, confirmPinController)
                        ],
                      ),
                      if (state is PinsLoadingState) const LoadingAnimation(),
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
