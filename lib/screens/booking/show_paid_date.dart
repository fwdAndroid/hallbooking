import 'package:flutter/material.dart';

class ShowPaidDate extends StatefulWidget {
  var uuid;
  var paidTime;
  ShowPaidDate({super.key, required this.paidTime, required this.uuid});

  @override
  State<ShowPaidDate> createState() => _ShowPaidDateState();
}

class _ShowPaidDateState extends State<ShowPaidDate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paid Dates'),
      ),
      body: ListView.builder(
        itemCount: widget.paidTime.length,
        itemBuilder: (context, index) {
          final payment = widget.paidTime[index];
          return ListTile(
            title: Text('Payment Date: ${payment['paymentDate']}'),
            subtitle: Text('Amount: ${payment['amount']}'),
          );
        },
      ),
    );
  }
}
