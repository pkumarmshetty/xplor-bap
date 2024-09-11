import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Seeker search result event
@immutable
sealed class SeekerSearchResultEvent extends Equatable {
  const SeekerSearchResultEvent();

  @override
  List<Object> get props => [];
}

// class SeekerSearchEvent extends SeekerSearchResultEvent {
//   final SseServicesEntity entity;
//
//   const SeekerSearchEvent({
//     required this.entity,
//   });
//
//   @override
//   List<Object> get props => [entity];
// }

/// Seeker search result event
class SearchSSEvent extends SeekerSearchResultEvent {
  final String search;
  final bool isFromSearch;

  const SearchSSEvent({required this.search, this.isFromSearch = false});

  @override
  List<Object> get props => [search];
}

// class SearchFailureEvent extends SeekerSearchResultEvent {
//   const SearchFailureEvent();
//
//   @override
//   List<Object> get props => [];
// }
