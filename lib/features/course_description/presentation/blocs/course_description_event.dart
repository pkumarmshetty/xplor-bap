import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../seeker_home/domain/entities/get_response_entity/services_items.dart';

/// Base class for all course description events.
/// This class is immutable and extends [Equatable] to enable value comparisons.
@immutable
sealed class CourseDescriptionEvent extends Equatable {
  /// Constructs a [CourseDescriptionEvent].
  const CourseDescriptionEvent();

  @override
  List<Object> get props => [];
}

/// Event that is fired when a course is selected.
///
/// This class extends [CourseDescriptionEvent] and is used to carry the
class CourseSelectedEvent extends CourseDescriptionEvent {
  /// The selected course represented by [SearchItemEntity].
  final SearchItemEntity course;

  const CourseSelectedEvent({
    required this.course,
  });

  @override
  List<Object> get props => [course];
}
