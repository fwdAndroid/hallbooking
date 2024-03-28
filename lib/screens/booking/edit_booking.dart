import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hallbooking/screens/booking/show_booking.dart';
import 'package:hallbooking/widgets/button.dart';
import 'package:hallbooking/widgets/colors.dart';
import 'package:hallbooking/widgets/textform.dart';

class EditBooking extends StatefulWidget {
  final uuid;
  final totalAmount;
  final paidAmount;
  final remaingAmount;
  EditBooking(
      {super.key,
      required this.paidAmount,
      required this.remaingAmount,
      required this.totalAmount,
      required this.uuid});

  @override
  State<EditBooking> createState() => _EditBookingState();
}

class _EditBookingState extends State<EditBooking> {
  TextEditingController _totalAmountController = TextEditingController();
  TextEditingController _payableAmountController = TextEditingController();
  TextEditingController _remainAmountController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    _totalAmountController.text = widget.totalAmount;
    _payableAmountController.text = widget.paidAmount;
    _remainAmountController.text = widget.remaingAmount;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainBtnColor,
        centerTitle: true,
        title: Text("Edit Booking Detail"),
      ),
      body: Column(
        children: [
          Image.asset("assets/logo.png"),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: TextFormInputField(
                labelText: "Total Amount",
                controller: _totalAmountController,
                hintText: "Total Rent Amount",
                IconSuffix: Icons.money,
                textInputType: TextInputType.number),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: TextFormInputField(
                labelText: "Total Paid Amount",
                controller: _payableAmountController,
                hintText: "Paid Amount",
                IconSuffix: Icons.macro_off_outlined,
                textInputType: TextInputType.number),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: TextFormInputField(
                labelText: "Total Remaining Amount",
                controller: _remainAmountController,
                hintText: "Remaining Amount",
                IconSuffix: Icons.macro_off_outlined,
                textInputType: TextInputType.number),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SaveButton(
                  title: "Edit",
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await FirebaseFirestore.instance
                        .collection("booking")
                        .doc(widget.uuid)
                        .update({
                      "remainingAmount":
                          int.parse(_remainAmountController.text),
                      "paidAmount": int.parse(_payableAmountController.text),
                      "totalAmount": int.parse(_totalAmountController.text)
                    });
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) => ShowBooking()));
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Booking Details Updated")));
                  })
        ],
      ),
    );
  }
}
