import 'package:flutter/material.dart';

class RefundPolicyPage extends StatelessWidget {
  const RefundPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Refund & Cancellation Policy"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left, size: 32),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PolicyHeader("1. Applicability"),
            PolicyText(
              "This Refund & Cancellation Policy applies to all payments made for services offered through DoctorOnQueue, including online consultations, lab tests, radiology bookings, and other medical services.",
            ),

            PolicyHeader("2. Payments"),
            PolicyText(
              "All payments are processed through third‑party payment gateways. DoctorOnQueue does not store any card or banking details. By completing a payment, you agree to the terms of the payment provider.",
            ),

            PolicyHeader("3. Cancellation & Refund Eligibility"),
            PolicyBullet(
              "Service has not yet been delivered (consultation not started, sample not collected, etc.).",
            ),
            PolicyBullet(
              "Cancellation is requested within the allowed cancellation window.",
            ),
            PolicyBullet(
              "The request is raised from the same account that made the booking.",
            ),
            SizedBox(height: 8),
            PolicyText(
              "Refunds will NOT be provided for completed consultations, completed lab/radiology services, or dissatisfaction with medical advice.",
            ),

            PolicyHeader("4. Cancellation Windows"),
            PolicyBullet(
              "Online consultations: Free cancellation up to 15 minutes before the scheduled start time.",
            ),
            PolicyBullet(
              "Physical appointments: Free cancellation up to 30 minutes before the appointment.",
            ),
            PolicyBullet(
              "Lab tests: Cancellation allowed up to 2 hours before sample collection.",
            ),

            PolicyHeader("5. Refund Processing"),
            PolicyBullet(
              "Refunds are issued to the original payment method or as wallet credit (if applicable).",
            ),
            PolicyBullet(
              "Processing may take up to 30 working days, depending on payment providers.",
            ),
            PolicyBullet(
              "Delays caused by banks/payment gateways are beyond DoctorOnQueue’s control.",
            ),

            PolicyHeader("6. Cancellation Fees"),
            PolicyText(
              "Some cancellations may incur a fee, depending on the service provider or operational costs. Fees are displayed at the time of booking.",
            ),

            PolicyHeader("7. Non‑Refundable Services"),
            PolicyBullet("Consultation fees once the consultation begins."),
            PolicyBullet("Lab tests if the sample is already collected."),
            PolicyBullet(
              "Any charges marked as non‑refundable at time of booking.",
            ),

            PolicyHeader("8. Refund Request Procedure"),
            PolicyBullet(
              "Go to My Bookings → Select the booking → Click Cancel/Request Refund.",
            ),
            PolicyBullet(
              "Only requests made through your account will be processed.",
            ),
            PolicyText(
              "For support, contact: ozazshalemprivatelimited@gmail.com or +91‑6238380204.",
            ),

            PolicyHeader("9. Modifications"),
            PolicyText(
              "DoctorOnQueue may update this policy at any time. Continued use of the service indicates acceptance of the updated policy.",
            ),

            PolicyHeader("10. Disclaimer"),
            PolicyBullet(
              "Refunds do not include compensation for time, travel, or indirect losses.",
            ),
            PolicyBullet(
              "Refunds are not provided for disputes over treatment outcomes or medical advice quality.",
            ),

            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class PolicyHeader extends StatelessWidget {
  final String text;
  const PolicyHeader(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class PolicyText extends StatelessWidget {
  final String text;
  const PolicyText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text, style: const TextStyle(fontSize: 15, height: 1.5)),
    );
  }
}

class PolicyBullet extends StatelessWidget {
  final String text;
  const PolicyBullet(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
