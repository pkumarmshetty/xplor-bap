part of 'choose_domain_bloc.dart';

abstract class ChooseDomainEvent extends Equatable {
  const ChooseDomainEvent();
}

class FetchDomainsEvent extends ChooseDomainEvent {
  @override
  List<Object?> get props => [];
}

class DomainSelectedEvent extends ChooseDomainEvent {
  final int position;
  final bool isSelected;

  @override
  List<Object?> get props => [position, isSelected];

  const DomainSelectedEvent({
    required this.position,
    required this.isSelected,
  });
}

class SelectedDomainsApiEvent extends ChooseDomainEvent {
  @override
  List<Object?> get props => [];
}

class GetDeviceApiEvent extends ChooseDomainEvent {
  @override
  List<Object?> get props => [];
}
