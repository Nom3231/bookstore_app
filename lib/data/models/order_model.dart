class OrderModel {
  final int? id;
  final String orderNumber;
  final String customerName;
  final String customerEmail;
  final double totalAmount;
  final double shippingFee;
  String status; // PENDING, PROCESSING, SHIPPED, DELIVERED, CANCELLED
  final String shippingAddress;
  final String contactPhone;
  final String paymentMethod;
  final String paymentStatus;
  final String? trackingNumber;
  final DateTime createdAt;

  OrderModel({
    this.id,
    required this.orderNumber,
    required this.customerName,
    required this.customerEmail,
    required this.totalAmount,
    this.shippingFee = 0.0,
    required this.status,
    required this.shippingAddress,
    required this.contactPhone,
    this.paymentMethod = 'CARD (DORMANT)',
    this.paymentStatus = 'PAID (DEMO)',
    this.trackingNumber,
    required this.createdAt,
  });

  bool get isCancelled => status.toUpperCase() == 'CANCELLED';

  /// 0 Placed, 1 Packed, 2 Shipped, 3 Delivered. -1 if cancelled.
  int get timelineStep {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 0;
      case 'PROCESSING':
        return 1;
      case 'SHIPPED':
        return 2;
      case 'DELIVERED':
        return 3;
      default:
        return -1;
    }
  }

  String get statusLabel {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Placed';
      case 'PROCESSING':
        return 'Packed';
      case 'SHIPPED':
        return 'Shipped';
      case 'DELIVERED':
        return 'Delivered';
      case 'CANCELLED':
        return 'Cancelled';
      default:
        return status;
    }
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int?,
      orderNumber:
          json['orderNumber'] as String? ??
          json['order_number'] as String? ??
          'ORD-000',
      customerName:
          json['customerName'] as String? ??
          json['customer_name'] as String? ??
          'Customer',
      customerEmail:
          json['customerEmail'] as String? ??
          json['customer_email'] as String? ??
          '',
      totalAmount:
          (json['totalAmount'] as num?)?.toDouble() ??
          (json['total_amount'] as num?)?.toDouble() ??
          0.0,
      shippingFee: (json['shippingFee'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'PENDING',
      shippingAddress:
          json['shippingAddress'] as String? ??
          json['shipping_address'] as String? ??
          '',
      contactPhone:
          json['contactPhone'] as String? ??
          json['contact_phone'] as String? ??
          '',
      paymentMethod: json['paymentMethod'] as String? ?? 'CARD (DORMANT)',
      paymentStatus: json['paymentStatus'] as String? ?? 'PAID (DEMO)',
      trackingNumber:
          json['trackingNumber'] as String? ??
          json['tracking_number'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}
