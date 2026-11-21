import 'package:flutter/material.dart';

import '../models/booking.dart';

class MyBookingsScreen extends StatefulWidget {
  final List<Booking> bookings;
  final ValueChanged<String> onCancel;

  const MyBookingsScreen({
    super.key,
    required this.bookings,
    required this.onCancel,
  });

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  final Set<String> locallyCancelled = {};

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

  Future<void> confirmCancellation(
    BuildContext context,
    Booking booking,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel booking?'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep booking'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Cancel booking'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        locallyCancelled.add(booking.id);
      });
      widget.onCancel(booking.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My bookings')),
      body: widget.bookings.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.confirmation_number_outlined,
                      size: 65,
                      color: Colors.white38,
                    ),
                    SizedBox(height: 18),
                    Text(
                      'No bookings yet',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your confirmed bookings will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white60),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: widget.bookings.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final booking = widget.bookings[index];

                return Card(
                  color: const Color(0xFF1B1B23),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                booking.event.title,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              booking.isCancelled ||
                                      locallyCancelled.contains(booking.id)
                                  ? 'Cancelled'
                                  : 'Confirmed',
                              style: TextStyle(
                                color:
                                    booking.isCancelled ||
                                        locallyCancelled.contains(booking.id)
                                    ? Colors.redAccent
                                    : Colors.greenAccent,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          booking.event.date,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        Text('Reference: ${booking.id}'),
                        const SizedBox(height: 8),
                        Text('Tickets: ${booking.quantity}'),
                        const SizedBox(height: 8),
                        Text(
                          'Total: ${formatPrice(booking.totalPrice)}',
                          style: const TextStyle(
                            color: Color(0xFFB69CFF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (!booking.isCancelled &&
                            !locallyCancelled.contains(booking.id)) ...[
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () =>
                                  confirmCancellation(context, booking),
                              icon: const Icon(
                                Icons.cancel_outlined,
                                color: Colors.redAccent,
                              ),
                              label: const Text(
                                'Cancel booking',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
