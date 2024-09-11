import 'package:xplor/features/my_orders/domain/entities/my_orders_entity.dart';

class CertificateViewArguments {
  final String certificateUrl;
  final MyOrdersEntity ordersEntity;

  CertificateViewArguments({
    required this.certificateUrl,
    required this.ordersEntity,
  });
}
