import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../seeker_home/domain/entities/get_response_entity/services_items.dart';

@immutable
sealed class CourseDescriptionEvent extends Equatable {
  const CourseDescriptionEvent();

  @override
  List<Object> get props => [];
}

class CourseSelectedEvent extends CourseDescriptionEvent {
  final SearchItemEntity course;

  const CourseSelectedEvent({
    required this.course,
  });

  @override
  List<Object> get props => [course];
}
