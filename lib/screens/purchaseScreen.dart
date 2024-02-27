import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PurchaseScreen extends StatefulWidget {
  String videolink;
  PurchaseScreen({required this.videolink, super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  bool fullscreen = false;
  final _razorpay = Razorpay();
  String apiKey = 'rzp_test_R3dodAqKlWEH1f';
  String apiSecret = 'lqwRZBuPsjQlKK82Fh2gWC30';
  late VideoPlayerController _videoPlayerController;

  Map<String, dynamic> paymentData = {
    'amount': 100, // amount in paise (e.g., 1000 paise = Rs. 10)
    'currency': 'INR',
    'receipt': 'order_receipt',
    'payment_capture': '1',
  };

  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
    _videoPlayerController = VideoPlayerController.asset(
        'assets/video/video.mp4')
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
      });
  }

  @override
  void dispose() {
    _razorpay.clear(); // Removes all listeners
    super.dispose();
    _videoPlayerController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plans',
          style: TextStyle(color: Colors.black),
        ),
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              height: 250,
              width: Get.width,
              child: VideoPlayer(
                  VideoPlayerController.networkUrl(
                  widget.videolink as Uri)
                ..initialize().then((_) {
                  setState(() {});
                  _videoPlayerController.play();
                })),
            ),
            GestureDetector(
              onTap: () {
                initiatePayment();
              },
              child: Container(
                width: Get.width,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(
                          0.2,
                          0.2,
                        ),
                        blurRadius: 1,
                      ),
                    ]),
                child: Column(
                  children: [
                    Text(
                      'Yearly Plan',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    Text(
                      '₹ 100',
                      style: TextStyle(fontSize: 40, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: Get.width,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(
                        0.2,
                        0.2,
                      ),
                      blurRadius: 1,
                    ),
                  ]),
              child: Column(
                children: [
                  Text(
                    'Monthly Plan',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  Text(
                    '₹ 10',
                    style: TextStyle(fontSize: 40, color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    // Here we get razorpay_payment_id razorpay_order_id razorpay_signature
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  Future<void> initiatePayment() async {
    String apiUrl = 'https://api.razorpay.com/v1/orders';
    // Make the API request to create an order
    http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}',
      },
      body: jsonEncode(paymentData),
    );

    if (response.statusCode == 200) {
      // Parse the response to get the order ID
      var responseData = jsonDecode(response.body);
      String orderId = responseData['id'];

      // Set up the payment options
      var options = {
        'key': apiKey,
        'amount': paymentData['amount'],
        'name': 'Sweet Corner',
        'order_id': orderId,
        'prefill': {'contact': '1234567890', 'email': 'test@example.com'},
        'external': {
          'wallets': ['paytm'] // optional, for adding support for wallets
        }
      };

      // Open the Razorpay payment form
      _razorpay.open(options);
    } else {
      // Handle error response
      debugPrint('Error creating order: ${response.body}');
    }
  }
}
