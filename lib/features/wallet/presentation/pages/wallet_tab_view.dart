import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xplor/features/wallet/presentation/pages/wallet_document_view.dart';
import 'package:xplor/features/wallet/presentation/pages/wallet_no_doc_view.dart';

import '../../../../utils/widgets/loading_animation.dart';
import '../blocs/wallet_vc_bloc/wallet_vc_bloc.dart';
import '../blocs/wallet_vc_bloc/wallet_vc_event.dart';
import '../blocs/wallet_vc_bloc/wallet_vc_state.dart';

class MyWalletTab extends StatefulWidget {
  const MyWalletTab({super.key});

  @override
  State<MyWalletTab> createState() => _MyWalletTabState();
}

class _MyWalletTabState extends State<MyWalletTab> {
  @override
  void initState() {
    super.initState();
    context.read<WalletVcBloc>().add(const GetWalletVcEvent());
  }

  @override
  Widget build(BuildContext context) {
    context.read<WalletVcBloc>().flowType = FlowType.document;
    return BlocBuilder<WalletVcBloc, WalletVcState>(builder: (context, state) {
      return state is WalletVcInitial
          ? Container()
          : state is WalletVcLoadingState
              ? const LoadingAnimation()
              : ((state is WalletVcSuccessState && state.vcData.isNotEmpty) ||
                      state is WalletDocumentSelectedState ||
                      state is WalletDocumentUnSelectedState ||
                      state is WalletDocumentsSearchedState)
                  ? const WalletDocumentView()
                  : const WalletNoDocumentView();
    });
  }
}
