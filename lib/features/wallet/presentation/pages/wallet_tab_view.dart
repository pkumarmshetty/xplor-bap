import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../utils/widgets/loading_animation.dart';
import '../blocs/wallet_vc_bloc/wallet_vc_bloc.dart';
import '../blocs/wallet_vc_bloc/wallet_vc_event.dart';
import '../blocs/wallet_vc_bloc/wallet_vc_state.dart';
import 'wallet_document_view.dart';
import 'wallet_no_doc_view.dart';

/// Widget that represents the My Wallet tab view.
/// It displays either a loading animation, wallet document view,
/// or wallet no document view based on the state of [WalletVcBloc].
class MyWalletTab extends StatefulWidget {
  const MyWalletTab({super.key});

  @override
  State<MyWalletTab> createState() => _MyWalletTabState();
}

class _MyWalletTabState extends State<MyWalletTab> {
  @override
  void initState() {
    super.initState();
    // Fetch initial wallet VC data when the widget is initialized
    context.read<WalletVcBloc>().add(const GetWalletVcEvent());
  }

  @override
  Widget build(BuildContext context) {
    // Set the flow type to document for WalletVcBloc
    context.read<WalletVcBloc>().flowType = FlowType.document;

    return BlocBuilder<WalletVcBloc, WalletVcState>(builder: (context, state) {
      // Build UI based on the state of WalletVcBloc
      return state is WalletVcInitial
          ? Container() // Initial state: Return an empty container
          : state is WalletVcLoadingState
              ? const LoadingAnimation() // Loading state: Show a loading animation
              : (state is WalletVcSuccessState && state.vcData.isNotEmpty) ||
                      state is WalletDocumentSelectedState ||
                      state is WalletDocumentUnSelectedState ||
                      state is WalletDocumentsSearchedState
                  ? const WalletDocumentView()
                  : const WalletNoDocumentView();
    });
  }
}
