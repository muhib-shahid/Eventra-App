import 'event.dart';

class Booking {
  final String id;
  final Event event;
  final int quantity;
  final int totalPrice;
  final DateTime bookedAt;
  final bool isCancelled;

  const Booking({
    required this.id,
    required this.event,
    required this.quantity,
    required this.totalPrice,
    required this.bookedAt,
    this.isCancelled = false,
  });

  Booking copyWith({bool? isCancelled}) {
    return Booking(
      id: id,
      event: event,
      quantity: quantity,
      totalPrice: totalPrice,
      bookedAt: bookedAt,
      isCancelled: isCancelled ?? this.isCancelled,
    );
  }
}
