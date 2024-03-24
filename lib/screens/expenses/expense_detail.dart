import 'package:flutter/material.dart';

import 'package:hallbooking/widgets/colors.dart';

class ExpenseDetail extends StatefulWidget {
  final billDate;
  final vendorName;
  final amount;
  final description;
  final category;
  final vendorGST;
  final uuid;
  const ExpenseDetail({
    super.key,
    required this.billDate,
    required this.vendorName,
    required this.amount,
    required this.description,
    required this.category,
    required this.vendorGST,
    required this.uuid,
  });

  @override
  State<ExpenseDetail> createState() => _ExpenseDetailState();
}

class _ExpenseDetailState extends State<ExpenseDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Show Expense Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Vendor Name",
                style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              Text(
                widget.vendorName,
                style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
              Divider(),
              Text(
                "Vendor Category",
                style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              Text(
                widget.category,
                style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
              Divider(),
              Text(
                "Bill Date",
                style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              Text(
                widget.billDate,
                style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
              Divider(),

              Text(
                "Paid Amount",
                style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              Text(
                widget.amount.toString(),
                style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
              Divider(),
              Text(
                "GST",
                style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              Text(
                widget.vendorGST.toString(),
                style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
              // Divider(),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: SaveButton(
              //       title: "Edit Details",
              //       onTap: () {
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (builder) => EditBooking()));
              //       }),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
