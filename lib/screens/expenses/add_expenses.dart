import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hallbooking/screens/main/main_dashboard.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hallbooking/widgets/button.dart';
import 'package:hallbooking/widgets/textform.dart';
import 'package:uuid/uuid.dart';

class AddExpenses extends StatefulWidget {
  const AddExpenses({super.key});

  @override
  State<AddExpenses> createState() => _AddExpensesState();
}

class _AddExpensesState extends State<AddExpenses> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();
  TextEditingController _totalAmountController = TextEditingController();
  TextEditingController _dateControllerStart = TextEditingController();
  TextEditingController d = TextEditingController();

  DateTime selectedDate = DateTime.now(); //Start Date

  bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width <
        600; // Adjust the width breakpoint for mobile
  }

  bool isLoading = false;
  var uuid = Uuid().v4();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dateControllerStart.text = DateFormat('yyyy-MM-dd')
            .format(picked); // you can format the date as you wish
      });
  }

  //End Dat

  String dropdownvalue = 'EB';
  var items = [
    'EB',
    'Gas',
    'Maintenance',
    'Gunsel Diesel',
    "Wages",
    "Internet",
    'Others',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Expenses"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: LayoutBuilder(builder: (context, constraints) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: TextFormInputField(
                        controller: _nameController,
                        hintText: "Vendor Name",
                        IconSuffix: Icons.person,
                        textInputType: TextInputType.emailAddress),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: TextFormInputField(
                        controller: _contactNumberController,
                        hintText: "Vendor GST",
                        IconSuffix: Icons.attach_money,
                        textInputType: TextInputType.number),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: TextFormInputField(
                        controller: _totalAmountController,
                        hintText: "Amount",
                        IconSuffix: Icons.money,
                        textInputType: TextInputType.number),
                  ),
                  TextFormField(
                    controller: _dateControllerStart,
                    decoration: InputDecoration(
                      labelText: 'Bill Date',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                    ),
                    readOnly: true, // make the text field read-only
                    onTap: () =>
                        _selectDate(context), // also open date picker on tap
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: TextFormInputField(
                        controller: d,
                        hintText: "Description",
                        IconSuffix: Icons.telegram,
                        textInputType: TextInputType.text),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton(
                      // Initial Value
                      isExpanded: true,
                      value: dropdownvalue,

                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),

                      // Array list of items
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                        });
                      },
                    ),
                  ),
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Center(
                          child: SaveButton(
                            onTap: () async {
                              if (_nameController.text.isEmpty ||
                                  _contactNumberController.text.isEmpty ||
                                  _totalAmountController.text.isEmpty ||
                                  _dateControllerStart.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("All Fields Required")));
                              } else {
                                setState(() {
                                  isLoading = true;
                                });
                                await FirebaseFirestore.instance
                                    .collection("expenses")
                                    .doc(uuid)
                                    .set({
                                  "uuid": uuid,
                                  "vendorName": _nameController.text,
                                  "vendorGST": int.parse(
                                      _contactNumberController.text), //GST

                                  "amount":
                                      int.parse(_totalAmountController.text),

                                  "billDate": _dateControllerStart.text,
                                  "description": d.text,

                                  "category": dropdownvalue,
                                });

                                setState(() {
                                  isLoading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Expense Successfully Added")));
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => MainDashboard()));
                              }
                            },
                            title: "Save",
                          ),
                        ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
