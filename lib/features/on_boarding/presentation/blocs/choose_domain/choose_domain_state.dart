part of 'choose_domain_bloc.dart';

enum DomainsState { loading, loaded, saved, failure }

abstract class ChooseDomainState extends Equatable {
  const ChooseDomainState();
}

class ChooseDomainInitial extends ChooseDomainState {
  @override
  List<Object> get props => [];
}

class DomainsFetchedState extends ChooseDomainState {
  final List<DomainData> domains;
  final List<String> selectedDomains;
  final List<String>? selectedDomainsNames;
  final DomainsState domainsState;

  @override
  List<Object> get props => [domains, selectedDomains, domainsState];

  const DomainsFetchedState(
      {required this.domains, required this.selectedDomains, required this.domainsState, this.selectedDomainsNames});
}

class SaveDomainsSuccessState extends ChooseDomainState {
  @override
  List<Object?> get props => [];
}

class RegisterDeviceIdState extends ChooseDomainState {
  final bool hasRegisterId;

  const RegisterDeviceIdState({this.hasRegisterId = false});

  @override
  List<Object?> get props => [];
}

class DomainsFailureState extends ChooseDomainState {
  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];

  const DomainsFailureState({
    required this.errorMessage,
  });
}
