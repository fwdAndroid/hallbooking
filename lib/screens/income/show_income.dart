import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hallbooking/widgets/button.dart';

class ShowIncome extends StatefulWidget {
  final String uuid;
  ShowIncome({Key? key, required this.uuid}) : super(key: key);

  @override
  State<ShowIncome> createState() => _ShowIncomeState();
}

class _ShowIncomeState extends State<ShowIncome> {
  final TextEditingController gasController = TextEditingController();
  final TextEditingController ebController = TextEditingController();
  final TextEditingController acController = TextEditingController();
  final TextEditingController gController = TextEditingController();
  final TextEditingController electricanController = TextEditingController();
  final TextEditingController cleanController = TextEditingController();

  bool isLoading = false;
  bool dataAdded = false;

  @override
  void initState() {
    super.initState();
    loadIncomeData();
  }

  Future<void> loadIncomeData() async {
    setState(() {
      isLoading = true;
    });

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot snapshot =
          await firestore.collection("booking").doc(widget.uuid).get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          setState(() {
            gasController.text = (data['gas'] ?? '').toString();
            ebController.text = (data['eb'] ?? '').toString();
            acController.text = (data['ac'] ?? '').toString();
            gController.text = (data['generator'] ?? '').toString();
            electricanController.text = (data['electrician'] ?? '').toString();
            cleanController.text = (data['cleaning'] ?? '').toString();
          });
          if (gasController.text.isNotEmpty ||
              ebController.text.isNotEmpty ||
              acController.text.isNotEmpty ||
              gController.text.isNotEmpty ||
              electricanController.text.isNotEmpty ||
              cleanController.text.isNotEmpty) {
            dataAdded =
                true; // Assumes at least one filled field means all data is added.
          }
        }
      }
    } catch (e) {
      // Handle any errors here
      print(e);
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _saveData() async {
    setState(() {
      isLoading = true;
    });
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection("booking").doc(widget.uuid).update({
        'secondIncome': int.parse(gasController.text) +
            int.parse(ebController.text) +
            int.parse(acController.text) +
            int.parse(gController.text) +
            int.parse(electricanController.text) +
            int.parse(cleanController.text),
        'gas': int.parse(gasController.text),
        'eb': int.parse(ebController.text),
        'ac': int.parse(acController.text),
        'generator': int.parse(gController.text),
        'electrician': int.parse(electricanController.text),
        'cleaning': int.parse(cleanController.text),
      });

      setState(() {
        dataAdded = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Income data saved successfully.")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to save income data: ${e.toString()}")));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Show Income'),
          centerTitle: true,
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    _buildAmountField(
                        'Gas (per Kg)', gasController, !dataAdded),
                    _buildAmountField(
                        'EB (per Unit Charge)', ebController, !dataAdded),
                    _buildAmountField(
                        'AC (per Hr Charge)', acController, !dataAdded),
                    _buildAmountField(
                        'Generator (per Hr Charge)', gController, !dataAdded),
                    _buildAmountField(
                        'Electrician', electricanController, !dataAdded),
                    _buildAmountField(
                        'Cleaning Charges', cleanController, !dataAdded),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SaveButton(
                        onTap: dataAdded ? null : _saveData,
                        title: 'Save Data',
                      ),
                    ),
                  ],
                ),
              ));
  }

  Widget _buildAmountField(
      String labelText, TextEditingController controller, bool enabled) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      keyboardType: TextInputType.number,
      enabled: enabled,
    );
  }

  @override
  void dispose() {
    super.dispose();
    // Dispose controllers to avoid memory leaks
    gasController.dispose();
    ebController.dispose();
    acController.dispose();
    electricanController.dispose();
    cleanController.dispose();
    gController.dispose();
  }
}
