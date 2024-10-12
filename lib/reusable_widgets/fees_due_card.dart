import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeesDueCard extends StatelessWidget {
  final String receiptNo;
  final String month;
  final String paymentDate;
  final String amount;
  final String? paymentMode;
  final VoidCallback? onTap;
  const FeesDueCard({super.key, required this.receiptNo, required this.month, required this.paymentDate, required this.amount, this.paymentMode, this.onTap});

  @override
  Widget build(BuildContext context) {
    double borderRadius = 18.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.black26),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Receipt No.",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF777777),
                      ),
                    ),
                    Text(
                      receiptNo,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10.0),
                const Divider(height: 1.0, thickness: 1.0,),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Month",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF777777),
                      ),
                    ),
                    Text(
                      month,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Payment Date",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF777777),
                      ),
                    ),
                    Text(
                      paymentDate,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                if (paymentMode != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Payment Mode",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF777777),
                          ),
                        ),
                        Text(
                          paymentMode!,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                const SizedBox(height: 10.0),
                const Divider(thickness: 1.0, height: 1.0,),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      paymentMode != null ? "Total Amount Paid" : "Total Pending Amount",
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF777777),
                      ),
                    ),
                    Text(
                      amount,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                color: Color(0xFF6789CA),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(borderRadius), bottomRight: Radius.circular(borderRadius)),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      paymentMode != null ? "Download" : "PAY NOW",
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    Icon(paymentMode != null ? Icons.download : Icons.chevron_right, size: 30.0, color: Colors.white,),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
