import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hallbooking/screens/booking/add_bookings.dart';
import 'package:hallbooking/screens/booking/booking_detail.dart';
import 'package:hallbooking/screens/booking/booksearch.dart';
import 'package:hallbooking/widgets/colors.dart';

class ShowBooking extends StatefulWidget {
  const ShowBooking({super.key});

  @override
  State<ShowBooking> createState() => _ShowBookingState();
}

class _ShowBookingState extends State<ShowBooking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.filter))],
        centerTitle: true,
        title: Text("Bookings"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffffc525),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (builder) => AddBooking()));
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
            child: TextFormField(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => BookSearch()));
              },
              decoration: InputDecoration(
                hintText: "Search",
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
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.3,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("booking")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Booking Details Available yet",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return StreamBuilder<Object>(
                            stream: FirebaseFirestore.instance
                                .collection("booking")
                                .snapshots(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              final List<DocumentSnapshot> documents =
                                  snapshot.data!.docs;
                              final Map<String, dynamic> data = documents[index]
                                  .data() as Map<String, dynamic>;
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
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                data['eventStartDate'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "To:",
                                                style: TextStyle(
                                                    color: titleColor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                data['eventEndDate'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w300),
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
                                                            addressController: data[
                                                                '_addressController'],
                                                            eventEndDate: data[
                                                                'eventEndDate'],
                                                            eventStartDate: data[
                                                                'eventStartDate'],
                                                            attendNumber: data[
                                                                'attendNumber'],
                                                            contactNumber: data[
                                                                'contactNumber'],
                                                            paidAmount: data[
                                                                    'paidAmount']
                                                                .toString(),
                                                            name: data['name'],
                                                            purpose:
                                                                data['purpose'],
                                                            remainingAmount:
                                                                data['remainingAmount']
                                                                    .toString(),
                                                            totalAmount: data[
                                                                    'totalAmount']
                                                                .toString(),
                                                            uuid: data['uuid'],
                                                          )));
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
                            });
                      });
                }),
          ),
        ],
      ),
    );
  }

  //Functions
}
