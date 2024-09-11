import 'package:equatable/equatable.dart';

/// State class for the WalletBloc.
///
class WalletState extends Equatable {
  final int tabIndex;

  const WalletState({required this.tabIndex});

  /// Initial state for the WalletBloc.
  WalletState copyWith({int? tabIndex}) {
    return WalletState(tabIndex: tabIndex ?? this.tabIndex);
  }

  @override
  List<Object?> get props => [tabIndex];
}
