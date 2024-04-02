import 'package:flutter/material.dart';

class ShowIncome extends StatefulWidget {
  final totalAmount;
  final totalRemaing;
  final paymentRecivedDate;
  ShowIncome(
      {super.key,
      required this.totalAmount,
      required this.paymentRecivedDate,
      required this.totalRemaing});

  @override
  State<ShowIncome> createState() => _ShowIncomeState();
}

class _ShowIncomeState extends State<ShowIncome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffc525),
        centerTitle: true,
        title: Text("Second Income"),
      ),
    );
  }
}
