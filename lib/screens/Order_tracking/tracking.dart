import 'package:flutter/material.dart';

class ProductTrackingPage extends StatefulWidget {
  const ProductTrackingPage({super.key});

  @override
  _ProductTrackingPageState createState() => _ProductTrackingPageState();
}

class _ProductTrackingPageState extends State<ProductTrackingPage> {
  // Simulated tracking data
  String orderNumber = '123456789';
  String currentStatus = 'In Transit';
  List<String> trackingHistory = [
    'Order placed',
    'Order processed',
    'In transit',
    'Out for delivery',
    'Delivered'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Product Tracking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Number: $orderNumber',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Current Status: $currentStatus',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tracking History:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              itemCount: trackingHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.check),
                  title: Text(trackingHistory[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
