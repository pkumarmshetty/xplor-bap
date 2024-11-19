import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../../core/dependency_injection.dart';
import '../../../domain/entities/domains_entity.dart';
import '../../../domain/usecase/on_boarding_usecase.dart';
import '../../../../../utils/app_utils/app_utils.dart';

part 'choose_domain_event.dart';

part 'choose_domain_state.dart';

class ChooseDomainBloc extends Bloc<ChooseDomainEvent, ChooseDomainState> {
  List<DomainData> domains = [];
  List<String> selectedDomains = [];
  List<String> selectedDomainNames = [];
  bool isRegisterDeviceId = false;

  OnBoardingUseCase useCase;

  ChooseDomainBloc({required this.useCase}) : super(ChooseDomainInitial()) {
    on<DomainSelectedEvent>(_onDomainSelectedEvent);
    on<FetchDomainsEvent>(_onDomainFetchEvent);
    on<SelectedDomainsApiEvent>(_onSelectedDomainsApiEvent);
    on<GetDeviceApiEvent>(_onGetDeviceIdApiEvent);
  }

  FutureOr<void> _onDomainSelectedEvent(DomainSelectedEvent event, Emitter<ChooseDomainState> emit) {
    domains[event.position] = domains[event.position].copyWith(isSelected: event.isSelected);
    if (event.isSelected) {
      if (!selectedDomains.contains(domains[event.position].id)) {
        selectedDomains.add(domains[event.position].id);
        selectedDomainNames.add(domains[event.position].domain);
      }
    } else if (selectedDomains.contains(domains[event.position].id)) {
      selectedDomains.remove(domains[event.position].id);
      selectedDomainNames.remove(domains[event.position].domain);
    }
    emit(
      DomainsFetchedState(
          domains: List.from(domains), selectedDomains: List.from(selectedDomains), domainsState: DomainsState.loaded),
    );
  }

  FutureOr<void> _onDomainFetchEvent(FetchDomainsEvent event, Emitter<ChooseDomainState> emit) async {
    domains.clear();
    emit(
      DomainsFetchedState(
          domains: List.from(domains), selectedDomains: List.from(selectedDomains), domainsState: DomainsState.loading),
    );
    try {
      domains = await useCase.getDomains();
      emit(
        DomainsFetchedState(domains: List.from(domains), selectedDomains: const [], domainsState: DomainsState.loaded),
      );
    } catch (e) {
      emit(DomainsFailureState(errorMessage: AppUtils.getErrorMessage(e.toString())));
    }
  }

  FutureOr<void> _onSelectedDomainsApiEvent(SelectedDomainsApiEvent event, Emitter<ChooseDomainState> emit) async {
    emit(
      DomainsFetchedState(
          domains: List.from(domains), selectedDomains: List.from(selectedDomains), domainsState: DomainsState.loading),
    );
    try {
      Map<String, dynamic> dataMap = <String, dynamic>{};
      dataMap['deviceId'] = sl<SharedPreferencesHelper>().getString(PrefConstKeys.deviceId);
      dataMap['domains'] = selectedDomains;
      await useCase.updateDevicePreference(dataMap);
      emit(
        DomainsFetchedState(
            domains: List.from(domains),
            selectedDomains: List.from(selectedDomains),
            selectedDomainsNames: List.from(selectedDomainNames),
            domainsState: DomainsState.saved),
      );
    } catch (e) {
      emit(DomainsFailureState(errorMessage: AppUtils.getErrorMessage(e.toString())));
    }
  }

  FutureOr<void> _onGetDeviceIdApiEvent(GetDeviceApiEvent event, Emitter<ChooseDomainState> emit) async {
    try {
      var res = await useCase.getDeviceIdEvent(
        sl<SharedPreferencesHelper>().getString(PrefConstKeys.deviceId),
      );

      emit(RegisterDeviceIdState(hasRegisterId: res));
      isRegisterDeviceId = res;
    } catch (e) {
      emit(const RegisterDeviceIdState(hasRegisterId: false));
      isRegisterDeviceId = false;
      /*emit(DomainsFailureState(
          errorMessage: AppUtils.getErrorMessage(e.toString())));*/
    }
  }
}
