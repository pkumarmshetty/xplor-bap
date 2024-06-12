import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xplor/config/routes/path_routing.dart';
import 'package:xplor/features/on_boarding/presentation/blocs/choose_domain/choose_domain_bloc.dart';
import 'package:xplor/features/on_boarding/presentation/widgets/domain_widget.dart';
import 'package:xplor/utils/app_dimensions.dart';
import 'package:xplor/utils/circluar_button.dart';
import 'package:xplor/utils/common_top_header.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/utils.dart';
import 'package:xplor/utils/widgets/app_background_widget.dart';
import 'package:xplor/utils/widgets/loading_animation.dart';

import '../../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../../core/dependency_injection.dart';
import '../../../../multi_lang/domain/mappers/on_boarding/on_boardings_keys.dart';

class ChooseDomainScreen extends StatefulWidget {
  const ChooseDomainScreen({super.key});

  @override
  State<ChooseDomainScreen> createState() => _ChooseDomainScreenState();
}

class _ChooseDomainScreenState extends State<ChooseDomainScreen> {
  @override
  void initState() {
    context.read<ChooseDomainBloc>().add(FetchDomainsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChooseDomainBloc, ChooseDomainState>(
      listener: (context, state) async {
        if (state is DomainsFetchedState) {
          if (state.domainsState == DomainsState.saved) {
            String domainsToJson = json.encode(state.selectedDomains);
            await sl<SharedPreferencesHelper>().setString(PrefConstKeys.savedDomains, domainsToJson);
            if (state.selectedDomainsNames != null) {
              String domainsNamesToJson = json.encode(state.selectedDomainsNames);
              await sl<SharedPreferencesHelper>().setString(PrefConstKeys.savedDomainsNames, domainsNamesToJson);
            }
            _goToNext();
            await sl<SharedPreferencesHelper>().setBoolean('${PrefConstKeys.focus}Done', true);
          }
        }
      },
      child: BlocBuilder<ChooseDomainBloc, ChooseDomainState>(
        builder: (context, state) {
          return Scaffold(
              body: AppBackgroundDecoration(
            child: Stack(alignment: Alignment.center, children: [
              state is DomainsFetchedState
                  ? Column(
                      children: [
                        CommonTopHeader(
                            title: OnBoardingKeys.yourFocus.stringToString,
                            onBackButtonPressed: () {
                              Navigator.pop(context);
                            }),
                        Expanded(
                          child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimensions.medium, vertical: AppDimensions.large),
                              itemCount: state.domains.length,
                              itemBuilder: (BuildContext context, int index) {
                                return DomainWidget(
                                    domainData: state.domains[index],
                                    onSelect: (bool result) {
                                      context
                                          .read<ChooseDomainBloc>()
                                          .add(DomainSelectedEvent(position: index, isSelected: result));
                                    });
                              }),
                        )
                      ],
                    )
                  : Container(),
              state is DomainsFetchedState && state.domains.isNotEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircularButton(
                          onPressed: () {
                            context.read<ChooseDomainBloc>().add(SelectedDomainsApiEvent());
                          },
                          isValid: state.selectedDomains.isNotEmpty,
                          title: OnBoardingKeys.next.stringToString,
                        ).symmetricPadding(
                          horizontal: AppDimensions.medium,
                          vertical: AppDimensions.large.w,
                        ),
                      ],
                    )
                  : Container(),
              state is DomainsFetchedState && state.domainsState == DomainsState.loading
                  ? const LoadingAnimation()
                  : Container(),
            ]),
          ));
        },
      ),
    );
  }

  _goToNext() {
    Navigator.pushNamed(context, Routes.selectCategory);
  }
}
