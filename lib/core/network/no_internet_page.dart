import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoInternetPage extends StatefulWidget {
  final VoidCallback onRetry;

  const NoInternetPage({super.key, required this.onRetry});

  @override
  NoInternetPageState createState() => NoInternetPageState();
}

class NoInternetPageState extends State<NoInternetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 100, color: Colors.grey[600]),
              const SizedBox(height: 20),
              const Text(
                'No Internet Connection',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Please check your internet settings and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: widget.onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CheckInternet extends GetxController {
  var noInternet = false.obs;
  Future<bool> hasConnection() async {
    try {
      noInternet(false);
      final result = await InternetAddress.lookup('example.com');
      print("Checking Internet");
      print(result.isNotEmpty && result[0].rawAddress.isNotEmpty);
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      print("False");
      noInternet(true);
      return false;
    }
  }
}
