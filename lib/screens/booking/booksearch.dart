import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hallbooking/screens/booking/booking_detail.dart';
import 'package:hallbooking/widgets/colors.dart';
import 'package:intl/intl.dart';

class BookSearch extends StatefulWidget {
  const BookSearch({Key? key}) : super(key: key);

  @override
  State<BookSearch> createState() => _BookSearchState();
}

class _BookSearchState extends State<BookSearch> {
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _selectDateRange(context);
            },
            icon: Icon(Icons.filter),
          )
        ],
        centerTitle: true,
        title: Text("Bookings"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: startDateController,
                    readOnly: true,
                    onTap: () {
                      _selectStartDate(context);
                    },
                    decoration: InputDecoration(
                      hintText: "Start Date",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: endDateController,
                    readOnly: true,
                    onTap: () {
                      _selectEndDate(context);
                    },
                    decoration: InputDecoration(
                      hintText: "End Date",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection("booking").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Loading...');
              }

              if (snapshot.data!.docs.isEmpty) {
                return Expanded(
                  child: Center(
                    child: Text(
                      "No Data Found",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                );
              }

              final filteredDocs = snapshot.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final eventStartDate =
                    DateFormat('yyyy-MM-dd').parse(data['eventStartDate']);
                final eventEndDate =
                    DateFormat('yyyy-MM-dd').parse(data['eventEndDate']);
                return eventStartDate
                        .isAfter(startDate.subtract(Duration(days: 1))) &&
                    eventEndDate.isBefore(endDate.add(Duration(days: 1)));
              }).toList();

              if (filteredDocs.isEmpty) {
                return Expanded(
                  child: Center(
                    child: Text(
                      "No Data Found within the selected date range",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                );
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final data =
                        filteredDocs[index].data() as Map<String, dynamic>;
                    return Card(
                      color: Color(0xffffc525),
                      child: Column(
                        children: [
                          ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['name'],
                                  style: TextStyle(
                                      color: titleColor,
                                      fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  data['purpose'],
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "From:",
                                      style: TextStyle(
                                          color: titleColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      data['eventStartDate'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "To:",
                                      style: TextStyle(
                                          color: titleColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      data['eventEndDate'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (builder) => BookingDetail(
                                      addressController:
                                          data['_addressController'],
                                      eventEndDate: data['eventEndDate'],
                                      eventStartDate: data['eventStartDate'],
                                      attendNumber: data['attendNumber'],
                                      contactNumber: data['contactNumber'],
                                      paidAmount: data['paidAmount'].toString(),
                                      name: data['name'],
                                      purpose: data['purpose'],
                                      remainingAmount:
                                          data['remainingAmount'].toString(),
                                      totalAmount:
                                          data['totalAmount'].toString(),
                                      uuid: data['uuid'],
                                    ),
                                  ),
                                );
                              },
                              child: Text("View Details"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  "Total Paid:",
                                  style: TextStyle(
                                      color: titleColor,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  data['paidAmount'].toString(),
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  "Remaining:",
                                  style: TextStyle(
                                      color: titleColor,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  data['remainingAmount'].toString(),
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedStartDate = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedStartDate != null && pickedStartDate != startDate) {
      setState(() {
        startDate = pickedStartDate;
        startDateController.text = DateFormat('yyyy-MM-dd').format(startDate);
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? pickedEndDate = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedEndDate != null && pickedEndDate != endDate) {
      setState(() {
        endDate = pickedEndDate;
        endDateController.text = DateFormat('yyyy-MM-dd').format(endDate);
      });
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTime? pickedStartDate = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedStartDate != null && pickedStartDate != startDate) {
      setState(() {
        startDate = pickedStartDate;
        startDateController.text = DateFormat('yyyy-MM-dd').format(startDate);
      });
    }

    final DateTime? pickedEndDate = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedEndDate != null && pickedEndDate != endDate) {
      setState(() {
        endDate = pickedEndDate;
        endDateController.text = DateFormat('yyyy-MM-dd').format(endDate);
      });
    }
  }
}
