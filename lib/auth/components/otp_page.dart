import 'package:cloud_firestore_crud_todo/chat/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpPage extends StatelessWidget {
  final String verificationId;
  final String phoneNumber;

  OtpPage({super.key, required this.verificationId, required this.phoneNumber});

  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify OTP"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter the OTP sent to +91$phoneNumber",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter OTP",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String otp = otpController.text.trim();
                if (otp.isNotEmpty) {
                  try {
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: otp,
                    );
                    await FirebaseAuth.instance
                        .signInWithCredential(credential);
                    Get.snackbar("Success", "OTP Verified Successfully!");
                    Get.offAll(() => ChatPage()); // Navigate to ChatPage
                  } catch (e) {
                    debugPrint("Error verifying OTP: $e");
                    Get.snackbar("Error", "Invalid OTP. Try again.");
                  }
                } else {
                  Get.snackbar("Error", "Please enter the OTP");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Verify"),
            )
          ],
        ),
      ),
    );
  }
}
