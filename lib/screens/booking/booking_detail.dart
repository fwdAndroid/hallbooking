import 'package:flutter/material.dart';
import 'package:hallbooking/screens/booking/edit_booking.dart';
import 'package:hallbooking/widgets/button.dart';

import 'package:hallbooking/widgets/colors.dart';

class BookingDetail extends StatefulWidget {
  final addressController;
  final attendNumber;
  final contactNumber;
  final eventEndDate;
  final eventStartDate;
  final name;
  final paidAmount;
  final purpose;
  final remainingAmount;
  final totalAmount;
  final uuid;
  final secondIncome;
  const BookingDetail({
    super.key,
    required this.addressController,
    required this.attendNumber,
    required this.contactNumber,
    required this.eventEndDate,
    required this.eventStartDate,
    required this.secondIncome,
    required this.name,
    required this.paidAmount,
    required this.purpose,
    required this.remainingAmount,
    required this.totalAmount,
    required this.uuid,
  });

  @override
  State<BookingDetail> createState() => _BookingDetailState();
}

class _BookingDetailState extends State<BookingDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffc525),
        centerTitle: true,
        title: Text("Show Booking Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Client Name",
                  style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                Text(
                  widget.name,
                  style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
                Divider(),
                Text(
                  "Event Category",
                  style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                Text(
                  widget.purpose,
                  style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
                Divider(),
                Text(
                  "Contact Number",
                  style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                Text(
                  widget.contactNumber,
                  style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
                Divider(),
                Text(
                  "Event Detail",
                  style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                Text(
                  widget.addressController,
                  style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
                Divider(),
                Text(
                  "Event Start Date",
                  style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                Text(
                  widget.eventStartDate,
                  style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
                Divider(),
                Text(
                  "Event End Date",
                  style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                Text(
                  widget.eventEndDate,
                  style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
                Divider(),
                Text(
                  "Total Amount",
                  style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                Text(
                  widget.totalAmount.toString(),
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
                  widget.paidAmount.toString(),
                  style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
                Divider(),
                Text(
                  "Remaining Amount",
                  style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                Text(
                  widget.remainingAmount.toString(),
                  style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
                Divider(),
                Text(
                  "Second Income",
                  style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                Text(
                  widget.secondIncome.toString(),
                  style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
                Divider(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SaveButton(
                        title: "Edit Details",
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => EditBooking(
                                        uuid: widget.uuid,
                                        paidAmount:
                                            widget.paidAmount.toString(),
                                        totalAmount:
                                            widget.totalAmount.toString(),
                                        remaingAmount:
                                            widget.remainingAmount.toString(),
                                      )));
                        }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
