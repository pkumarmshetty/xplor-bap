import 'dart:io';

/// Typedef to define a function type for image-related callbacks
typedef GetMediaData = Future<void> Function(File?);

typedef GetDateTime = Future<void> Function(DateTime?);
