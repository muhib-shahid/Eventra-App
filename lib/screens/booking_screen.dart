import 'package:flutter/material.dart';

import '../models/booking.dart';
import '../models/event.dart';

const Color bookingAccent = Color(0xFFB69CFF);
const Color bookingSurface = Color(0xFF1B1B23);

class BookingScreen extends StatefulWidget {
  final Event event;

  const BookingScreen({super.key, required this.event});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int quantity = 1;
  static const int maximumTickets = 10;

  bool isConfirmed = false;
  Booking? confirmedBooking;

  int get unitPrice {
    return int.tryParse(widget.event.price.replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;
  }

  int get totalPrice => unitPrice * quantity;

  String formatPrice(int amount) {
    final digits = amount.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);

      final remaining = digits.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) {
        buffer.write(',');
      }
    }

    return 'Rs. ${buffer.toString()}';
  }

  void confirmBooking() {
    if (unitPrice <= 0 || quantity < 1 || quantity > maximumTickets) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to process this booking.')),
      );
      return;
    }

    final timestamp = DateTime.now();

    setState(() {
      confirmedBooking = Booking(
        id: 'EVT-${timestamp.microsecondsSinceEpoch}',
        event: widget.event,
        quantity: quantity,
        totalPrice: totalPrice,
        bookedAt: timestamp,
      );

      isConfirmed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isConfirmed) {
      return buildConfirmationScreen();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Book tickets')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              widget.event.imageUrl,
              height: 190,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                height: 190,
                color: bookingSurface,
                child: const Icon(Icons.event, size: 55, color: bookingAccent),
              ),
            ),
          ),
          const SizedBox(height: 22),

          Text(
            widget.event.title,
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          Text(
            '${widget.event.date} • ${widget.event.location}',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 30),

          const Text(
            'Select tickets',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bookingSurface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Standard ticket',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'General admission',
                        style: TextStyle(color: Colors.white60),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: quantity > 1
                      ? () => setState(() => quantity--)
                      : null,
                  icon: const Icon(Icons.remove_circle_outline),
                  color: bookingAccent,
                ),
                Text(
                  '$quantity',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: quantity < maximumTickets
                      ? () => setState(() => quantity++)
                      : null,
                  icon: const Icon(Icons.add_circle_outline),
                  color: bookingAccent,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          Text(
            'Maximum $maximumTickets tickets per booking.',
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 30),

          const Text(
            'Price breakdown',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),

          priceRow('Ticket price', formatPrice(unitPrice)),
          const SizedBox(height: 12),
          priceRow('Quantity', '$quantity'),
          const Divider(height: 30),
          priceRow('Total amount', formatPrice(totalPrice), bold: true),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: confirmBooking,
              style: FilledButton.styleFrom(
                backgroundColor: bookingAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 17),
              ),
              child: const Text(
                'Confirm booking',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget priceRow(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: bold ? Colors.white : Colors.white70,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: bold ? bookingAccent : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: bold ? 17 : 14,
          ),
        ),
      ],
    );
  }

  Widget buildConfirmationScreen() {
    final booking = confirmedBooking!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Booking confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.greenAccent,
              size: 85,
            ),
            const SizedBox(height: 22),
            const Text(
              'Booking confirmed!',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your booking has been recorded successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: bookingSurface,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.event.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),
                  confirmationRow('Booking reference', booking.id),
                  confirmationRow('Tickets', '${booking.quantity}'),
                  confirmationRow(
                    'Total paid',
                    formatPrice(booking.totalPrice),
                  ),
                  confirmationRow('Payment status', 'Not paid — demo booking'),
                ],
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context, booking),
                style: FilledButton.styleFrom(
                  backgroundColor: bookingAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget confirmationRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.white60)),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
