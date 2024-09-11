import 'services_items.dart';

class CourseDetailsEntity {
  final String? message;
  final bool? status;
  final CourseDetailsDataEntity? items;

  CourseDetailsEntity({
    this.message,
    this.status,
    this.items,
  });

  factory CourseDetailsEntity.fromJson(Map<String, dynamic> json) {
    return CourseDetailsEntity(
      message: json['message'] ?? "",
      status: json['transaction_id'] ?? false,
      items: CourseDetailsDataEntity.fromJson(json['data']),
    );
  }
}
