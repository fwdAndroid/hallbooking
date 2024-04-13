import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hallbooking/screens/main/main_dashboard.dart';
import 'package:hallbooking/widgets/button.dart';
import 'package:hallbooking/widgets/colors.dart';
import 'package:hallbooking/widgets/textform.dart';
import 'package:intl/intl.dart';

class EditBooking extends StatefulWidget {
  final String uuid;
  final String totalAmount;
  final String paidAmount;
  final String remainingAmount;
  final String eventStartDate;

  EditBooking({
    required this.uuid,
    required this.paidAmount,
    required this.remainingAmount,
    required this.totalAmount,
    required this.eventStartDate,
  });

  @override
  State<EditBooking> createState() => _EditBookingState();
}

class _EditBookingState extends State<EditBooking> {
  TextEditingController _newAmountController = TextEditingController();
  TextEditingController _remainingAmountController = TextEditingController();
  TextEditingController _paidAmountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  String updatedRemainingAmount = '';
  String? updatedPaidAmount;
  DateTime selectedDate = DateTime.now(); //Start Date

  Future<void> _updateBooking() async {
    await FirebaseFirestore.instance
        .collection("booking")
        .doc(widget.uuid)
        .update({
      "remainingAmount": int.parse(_remainingAmountController.text),
      "paidAmount": int.parse(_paidAmountController.text),
      "totalAmount": int.parse(widget.totalAmount),
      "paidTime": FieldValue.arrayUnion([
        {
          "paymentDate": dateController.text,
          "amount": int.parse(_newAmountController.text)
        }
      ])
    });
  }

  @override
  void initState() {
    super.initState();
    _remainingAmountController.text = widget.remainingAmount;
    _paidAmountController.text = widget.paidAmount;
    updatedRemainingAmount = widget.remainingAmount;
    updatedPaidAmount = widget.paidAmount;
  }

  void _updateRemainingAndPaidAmount() {
    final newAmount = int.tryParse(_newAmountController.text) ?? 0;
    final remainingAmount = int.tryParse(updatedRemainingAmount) ?? 0;
    var paidAmount = int.tryParse(updatedPaidAmount!) ?? 0;

    // If remaining amount is already 0, display message and return
    if (remainingAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Remaining amount is already paid.")),
      );
      return;
    }

    // Initialize updatedPaidAmount if not already initialized
    if (updatedPaidAmount == null) {
      updatedPaidAmount = widget.paidAmount;
    }

    // Calculate new remaining and paid amounts
    final updatedRemainingAmountValue = remainingAmount - newAmount;
    paidAmount += newAmount;

    // Ensure paid amount is not negative
    if (paidAmount < 0) {
      paidAmount = 0;
    }

    // Update state and controllers
    setState(() {
      updatedRemainingAmount = updatedRemainingAmountValue.toString();
      updatedPaidAmount = paidAmount.toString();
      _remainingAmountController.text = updatedRemainingAmount;
      _paidAmountController.text = updatedPaidAmount!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainBtnColor,
        centerTitle: true,
        title: Text("Edit Booking Detail"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 500,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/logo.png"),
                _buildAmountField("Total Amount", widget.totalAmount),
                _buildAmountField("Paid Date", widget.eventStartDate),
                _buildAmountField("Paid Amount", widget.paidAmount),
                _buildRemainingAmountField(),
                _buildNewAmountField(),
                TextFormInputField(
                  tap: () => _selectDate(context),
                  labelText: "Date",
                  controller: dateController,
                  hintText: "Date",
                  IconSuffix: Icons.date_range,
                  textInputType: TextInputType.number,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder<void>(
                    future: _updateBooking(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Show loading indicator
                      } else if (snapshot.hasError) {
                        return Text('Please Select Paid Date and Amount');
                      } else {
                        return SaveButton(
                          title: "Add New Amount",
                          onTap: () async {
                            setState(() {
                              final newAmount =
                                  int.tryParse(_newAmountController.text) ?? 0;
                              _updateRemainingAndPaidAmount();
                            });
                            // Firestore update happens inside _updateBooking() function
                            await _updateBooking();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (builder) => MainDashboard(),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountField(String labelText, String value) {
    return TextFormInputField(
      readOnly: true,
      labelText: labelText,
      controller: TextEditingController(text: value),
      hintText: value,
      IconSuffix: Icons.money,
      textInputType: TextInputType.number,
    );
  }

  Widget _buildRemainingAmountField() {
    return TextFormInputField(
      readOnly: true,
      labelText: "Total Remaining Amount",
      controller: _remainingAmountController,
      hintText: "Remaining Amount",
      IconSuffix: Icons.money_off,
      textInputType: TextInputType.number,
    );
  }

  Widget _buildNewAmountField() {
    return TextFormInputField(
      labelText: "New Amount",
      controller: _newAmountController,
      hintText: "Enter new amount",
      IconSuffix: Icons.money,
      textInputType: TextInputType.number,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(), // Set firstDate to today's date
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
  }
}
