import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hallbooking/screens/main/main_dashboard.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hallbooking/widgets/button.dart';
import 'package:hallbooking/widgets/textform.dart';
import 'package:uuid/uuid.dart';

class AddBooking extends StatefulWidget {
  const AddBooking({super.key});

  @override
  State<AddBooking> createState() => _AddBookingState();
}

class _AddBookingState extends State<AddBooking> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();
  TextEditingController _attendendControllter = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _totalAmountController = TextEditingController();
  TextEditingController _payableAmountController = TextEditingController();
  TextEditingController _dateControllerStart = TextEditingController();
  TextEditingController _dateControllerEnd = TextEditingController();

  DateTime selectedDate = DateTime.now(); //Start Date
  DateTime selectedDateEnd = DateTime.now(); // End Date

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
  Future<void> _selectDateEnd(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateEnd,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDateEnd)
      setState(() {
        selectedDateEnd = picked;
        _dateControllerEnd.text = DateFormat('yyyy-MM-dd')
            .format(picked); // you can format the date as you wish
      });
  }

  String dropdownvalue = 'Reception';
  var items = [
    'Reception',
    'Conference',
    'Muhurtham',
    'Others',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Booking"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: TextFormInputField(
                  controller: _nameController,
                  hintText: "Name",
                  IconSuffix: Icons.person,
                  textInputType: TextInputType.emailAddress),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: TextFormInputField(
                  controller: _contactNumberController,
                  hintText: "Contact Number",
                  IconSuffix: Icons.contact_page,
                  textInputType: TextInputType.number),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: TextFormInputField(
                  controller: _attendendControllter,
                  hintText: "Attended Number",
                  IconSuffix: Icons.assignment_turned_in_outlined,
                  textInputType: TextInputType.number),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: TextFormInputField(
                  controller: _addressController,
                  hintText: "Address",
                  IconSuffix: Icons.home,
                  textInputType: TextInputType.text),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: TextFormInputField(
                  controller: _totalAmountController,
                  hintText: "Total Amount",
                  IconSuffix: Icons.money,
                  textInputType: TextInputType.number),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: TextFormInputField(
                  controller: _payableAmountController,
                  hintText: "Paid Amount",
                  IconSuffix: Icons.macro_off_outlined,
                  textInputType: TextInputType.number),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dateControllerStart,
                      decoration: InputDecoration(
                        labelText: 'Start Date',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                      ),
                      readOnly: true, // make the text field read-only
                      onTap: () =>
                          _selectDate(context), // also open date picker on tap
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _dateControllerEnd,
                      decoration: InputDecoration(
                        labelText: 'End Date',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                      ),
                      readOnly: true, // make the text field read-only
                      onTap: () => _selectDateEnd(
                          context), // also open date picker on tap
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Category",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
                            _attendendControllter.text.isEmpty ||
                            _addressController.text.isEmpty ||
                            _totalAmountController.text.isEmpty ||
                            _payableAmountController.text.isEmpty ||
                            _dateControllerStart.text.isEmpty ||
                            _dateControllerEnd.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("All Fields Required")));
                        } else {
                          setState(() {
                            isLoading = true;
                          });
                          await FirebaseFirestore.instance
                              .collection("booking")
                              .doc(uuid)
                              .set({
                            "uuid": uuid,
                            "name": _nameController.text,
                            "contactNumber": _contactNumberController.text,
                            "attendNumber": _attendendControllter.text,
                            "_addressController": _addressController.text,
                            "totalAmount":
                                int.parse(_totalAmountController.text),
                            "paidAmount":
                                int.parse(_payableAmountController.text),
                            "eventStartDate": _dateControllerStart.text,
                            "eventEndDate": _dateControllerEnd.text,
                            "purpose": dropdownvalue,
                            "remainingAmount":
                                int.parse(_totalAmountController.text) -
                                    int.parse(_payableAmountController.text),
                          });

                          setState(() {
                            isLoading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Booking Added Successfully")));
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
      ),
    );
  }
}
