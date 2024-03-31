import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hallbooking/screens/booking/add_bookings.dart';
import 'package:hallbooking/screens/booking/booking_detail.dart';
import 'package:hallbooking/screens/booking/search_by_category_booking.dart';
import 'package:hallbooking/widgets/colors.dart';
import 'package:intl/intl.dart';

class ShowBooking extends StatefulWidget {
  const ShowBooking({Key? key}) : super(key: key);

  @override
  State<ShowBooking> createState() => _ShowBookingState();
}

class _ShowBookingState extends State<ShowBooking> {
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) => CategoryBookingSearch(),
                ),
              );
            },
            child: Text("Search By Category"),
          )
        ],
        centerTitle: true,
        title: Text("Bookings"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffffc525),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (builder) => AddBooking()),
          );
        },
        child: Icon(
          Icons.add,
          color: colorwhite,
        ),
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
                IconButton(
                  onPressed: () {
                    setState(() {
                      isSearch = true;
                    });
                  },
                  icon: Icon(Icons.search),
                )
              ],
            ),
          ),
          isSearch
              ? Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("booking")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading...');
                      }

                      if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            "No Data Found",
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }

                      final filteredDocs = _filterByDateRange(
                        snapshot.data!.docs,
                        startDate,
                        endDate,
                      );

                      if (filteredDocs.isEmpty) {
                        return Center(
                          child: Text(
                            "No Data Found within the selected date range",
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: filteredDocs.length,
                        itemBuilder: (BuildContext context, int index) {
                          final data = filteredDocs[index].data()
                              as Map<String, dynamic>;
                          return Card(
                            color: Color(0xffffc525),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['name'],
                                        style: TextStyle(
                                            color: titleColor,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      Text(
                                        data['purpose'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300),
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
                                            eventStartDate:
                                                data['eventStartDate'],
                                            attendNumber: data['attendNumber'],
                                            contactNumber:
                                                data['contactNumber'],
                                            paidAmount:
                                                data['paidAmount'].toString(),
                                            name: data['name'],
                                            purpose: data['purpose'],
                                            remainingAmount:
                                                data['remainingAmount']
                                                    .toString(),
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
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300),
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
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              : Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("booking")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            "No Booking Details Available yet",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          final data = snapshot.data!.docs[index].data()
                              as Map<String, dynamic>;
                          return Card(
                            color: Color(0xffffc525),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['name'],
                                        style: TextStyle(
                                            color: titleColor,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      Text(
                                        data['purpose'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300),
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
                                  trailing: Column(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (builder) =>
                                                  BookingDetail(
                                                addressController:
                                                    data['_addressController'],
                                                eventEndDate:
                                                    data['eventEndDate'],
                                                eventStartDate:
                                                    data['eventStartDate'],
                                                attendNumber:
                                                    data['attendNumber'],
                                                contactNumber:
                                                    data['contactNumber'],
                                                paidAmount: data['paidAmount']
                                                    .toString(),
                                                name: data['name'],
                                                purpose: data['purpose'],
                                                remainingAmount:
                                                    data['remainingAmount']
                                                        .toString(),
                                                totalAmount: data['totalAmount']
                                                    .toString(),
                                                uuid: data['uuid'],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text("View Details"),
                                      ),
                                    ],
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
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300),
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
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  //Functions
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

  DateTime _parseDate(String dateString) {
    return DateFormat('yyyy-MM-dd').parse(dateString);
  }

  bool _dateInRange(DateTime date, DateTime start, DateTime end) {
    return date.isAfter(start.subtract(Duration(days: 1))) &&
        date.isBefore(end.add(Duration(days: 1)));
  }

  List<DocumentSnapshot> _filterByDateRange(
      List<DocumentSnapshot> docs, DateTime start, DateTime end) {
    return docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final eventStartDate = _parseDate(data['eventStartDate']);
      final eventEndDate = _parseDate(data['eventEndDate']);
      return _dateInRange(eventStartDate, start, end) ||
          _dateInRange(eventEndDate, start, end);
    }).toList();
  }
}
