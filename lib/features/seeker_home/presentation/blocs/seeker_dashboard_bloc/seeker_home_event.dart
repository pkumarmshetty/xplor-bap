import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Seeker home event
@immutable
sealed class SeekerHomeEvent extends Equatable {
  const SeekerHomeEvent();

  @override
  List<Object> get props => [];
}

/// Seeker Search event
class SeekerSSEvent extends SeekerHomeEvent {
  final String search;
  final bool isFirstTime;

  const SeekerSSEvent({
    required this.search,
    this.isFirstTime = false,
  });

  @override
  List<Object> get props => [search];
}
