import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:school_erp/constants/colors.dart';

import '../model/user_model.dart';
import '../reusable_widgets/fees_due_card.dart';

class FeesDueScreen extends StatefulWidget {
  const FeesDueScreen({super.key});

  @override
  State<FeesDueScreen> createState() => _FeesDueScreenState();
}

class _FeesDueScreenState extends State<FeesDueScreen> {
  Box<UserModel> userBox = Hive.box<UserModel>('users');
  late Razorpay _razorpay;

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    debugPrint("PaymentId: ${response.paymentId} \n OrderId: ${response.orderId}");

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Payment Successful"),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(
              10.0)),
    ));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("Payment Error Response: ${response.message}");

    // Do something when payment fails
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Payment Failed"),
      showCloseIcon: true,
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(
              10.0)),
    ));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.walletName!),
      backgroundColor: Colors.green,
      showCloseIcon: true,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(
              10.0)),
    ));
  }

  void openCheckout() {
    debugPrint("Checkout initiated");
    var options = {
      "key": "rzp_test_wFEIWe7sxtp71p",
      "amount": 999 * 100,
      "name": "test payment",
      "description": "this is the test payment",
      // "timeout": "180",
      // "currency": "INR",
      "prefill": {
        "contact": userBox.get("user")?.contactNumber?.split(" ")[1] ?? "0000000000",
        "email": "tanish.pradhan4@gmail.com",
      }
    };
    _razorpay.open(options);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7292CF),
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              "assets/Star_Background.png",
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(top: 20.0, left: 20.0, bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.chevron_left,
                          size: 30,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          "Fees Due",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(top: 30.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            topLeft: Radius.circular(20.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            FeesDueCard(
                              receiptNo: "#98671",
                              month: "March",
                              paymentDate: "17 March 24",
                              amount: "₹999",
                              onTap: () {
                                openCheckout();
                              },
                            ),
                            FeesDueCard(
                              receiptNo: "#98671",
                              month: "February",
                              paymentDate: "12 Feb 24",
                              paymentMode: "Online",
                              amount: "₹999",
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: const Text("Feature coming soon..."),
                                  showCloseIcon: true,
                                  backgroundColor: primaryColor.withOpacity(0.9),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                          10.0)),
                                ));
                              },
                            ),
                            FeesDueCard(
                              receiptNo: "#98671",
                              month: "January",
                              paymentDate: "2 January 24",
                              paymentMode: "Card",
                              amount: "₹999",
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: const Text("Feature coming soon..."),
                                  showCloseIcon: true,
                                  backgroundColor: primaryColor.withOpacity(0.9),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                          10.0)),
                                ));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
