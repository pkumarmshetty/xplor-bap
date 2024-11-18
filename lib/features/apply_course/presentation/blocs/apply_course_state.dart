part of 'apply_course_bloc.dart';

abstract class ApplyCourseState extends Equatable {
  const ApplyCourseState();
}

class ApplyCourseInitial extends ApplyCourseState {
  @override
  List<Object> get props => [];
}

class FormSubmittedState extends ApplyCourseState {
  @override
  List<Object> get props => [];
}

/*class CourseSuccessState extends ApplyCourseState {
  @override
  List<Object> get props => [];
}*/

class CourseFailureState extends ApplyCourseState {
  final String errorMessage;

  @override
  List<Object> get props => [];

  const CourseFailureState({
    required this.errorMessage,
  });
}

class PaymentUrlState extends ApplyCourseState {
  final String url;

  @override
  List<Object> get props => [];

  const PaymentUrlState({
    required this.url,
  });
}

class CourseUrlDataState extends ApplyCourseState {
  final String url;

  @override
  List<Object> get props => [url];

  const CourseUrlDataState({
    required this.url,
  });
}

class CourseDocumentState extends ApplyCourseState {
  final List<DocumentVcData> docs;
  final bool linkCopied;

  @override
  List<Object> get props => [docs, linkCopied];

  const CourseDocumentState({
    required this.docs,
    required this.linkCopied,
  });
}

class NavigationSuccessState extends ApplyCourseState {
  @override
  List<Object> get props => [];

  const NavigationSuccessState();
}

class SuccessOnSelectState extends ApplyCourseState {
  @override
  List<Object> get props => [];

  const SuccessOnSelectState();
}

class ApplyFormLoaderState extends ApplyCourseState {
  @override
  List<Object> get props => [];

  const ApplyFormLoaderState();
}
