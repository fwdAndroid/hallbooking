import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hallbooking/screens/booking/booking_detail.dart';
import 'package:hallbooking/widgets/colors.dart';

class CategoryBookingSearch extends StatefulWidget {
  const CategoryBookingSearch({super.key});

  @override
  State<CategoryBookingSearch> createState() => _CategoryBookingSearchState();
}

class _CategoryBookingSearchState extends State<CategoryBookingSearch> {
  String dropdownValue = 'Reception'; // Default selected category
  var categories = [
    'Reception',
    'Conference',
    'Muhurtham',
    'Others',
  ]; // List of categories

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Booking Search"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              // Initial Value
              isExpanded: true,
              value: dropdownValue,
              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),
              // List of categories
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              // After selecting the desired option, change the button value to the selected value
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("booking")
                .where('purpose',
                    isEqualTo: dropdownValue) // Filter by selected category
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
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

              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final DocumentSnapshot document =
                        snapshot.data!.docs[index];
                    final Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
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
                                      secondIncome:
                                          data['secondIncome'].toString(),
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
}
