import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hallbooking/widgets/button.dart';
import 'package:hallbooking/widgets/textform.dart';

class ShowIncome extends StatefulWidget {
  final uuid;
  ShowIncome({super.key, required this.uuid});

  @override
  State<ShowIncome> createState() => _ShowIncomeState();
}

class _ShowIncomeState extends State<ShowIncome> {
  TextEditingController gasController = TextEditingController();
  TextEditingController ebController = TextEditingController();
  TextEditingController acController = TextEditingController();
  TextEditingController gController = TextEditingController();
  TextEditingController electricanController = TextEditingController();
  TextEditingController cleanController = TextEditingController();
  bool isLoading = false;
  bool dataAdded = false;

  @override
  void initState() {
    super.initState();
    // Load data from Firebase and set the values to the controllers
    loadIncomeData();
  }

  void loadIncomeData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("bookings")
        .doc(widget.uuid)
        .get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      setState(() {
        gasController.text = (data['gas'] ?? 0).toString();
        ebController.text = (data['eb'] ?? 0).toString();
        acController.text = (data['ac'] ?? 0).toString();
        gController.text = (data['generator'] ?? 0).toString();
        electricanController.text = (data['electrician'] ?? 0).toString();
        cleanController.text = (data['cleaning'] ?? 0).toString();
        dataAdded = true; // Set dataAdded to true
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffc525),
        centerTitle: true,
        title: Text("Second Income"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildAmountField("Gas (per Kg)", gasController, enabled: !dataAdded),
          _buildAmountField("EB (per Unit Charge)", ebController,
              enabled: !dataAdded),
          _buildAmountField("AC (per Hr Charge)", acController,
              enabled: !dataAdded),
          _buildAmountField("Generator (per Hr Charge)", gController,
              enabled: !dataAdded),
          _buildAmountField("Electrician", electricanController,
              enabled: !dataAdded),
          _buildAmountField("Cleaning Charges", cleanController,
              enabled: !dataAdded),
          SaveButton(
            title: "Add",
            onTap: dataAdded ? null : _saveData, // Set onTap based on dataAdded
          ),
        ],
      ),
    );
  }

  Widget _buildAmountField(String labelText, TextEditingController controller,
      {bool enabled = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: controller.text,
        icon: Icon(Icons.money),
      ),
      keyboardType: TextInputType.number,
      enabled: enabled,
    );
  }

  void _saveData() async {
    setState(() {
      isLoading = true;
    });

    int gas = _parseTextFieldValue(gasController.text);
    int eb = _parseTextFieldValue(ebController.text);
    int ac = _parseTextFieldValue(acController.text);
    int g = _parseTextFieldValue(gController.text);
    int electrician = _parseTextFieldValue(electricanController.text);
    int cleaning = _parseTextFieldValue(cleanController.text);

    await FirebaseFirestore.instance
        .collection("booking")
        .doc(widget.uuid)
        .set({
      "secondIncome": gas + eb + ac + g + electrician + cleaning,
    });

    setState(() {
      isLoading = false;
      dataAdded = true; // Set dataAdded to true after data is added
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Second Income Added")),
    );
  }

  int _parseTextFieldValue(String value) {
    if (value.isEmpty) {
      return 0;
    }
    return int.tryParse(value) ?? 0;
  }
}
