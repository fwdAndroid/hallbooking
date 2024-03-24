import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hallbooking/screens/booking/add_bookings.dart';
import 'package:hallbooking/screens/booking/booking_detail.dart';
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
        centerTitle: true,
        title: Text("Bookings"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (builder) => AddBooking()));
        },
        child: Icon(
          Icons.add,
          color: mainBtnColor,
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height / 1.2,
        child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("booking").snapshots(),
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
                          final Map<String, dynamic> data =
                              documents[index].data() as Map<String, dynamic>;
                          return Card(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Row(
                                    children: [
                                      Text(
                                        "Contact Name:",
                                        style: TextStyle(
                                            color: titleColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        data['name'],
                                        style: TextStyle(
                                            color: titleColor,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                        "Category:",
                                        style: TextStyle(
                                            color: titleColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        data['purpose'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                  trailing: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  BookingDetail(
                                                    addressController: data[
                                                        '_addressController'],
                                                    eventEndDate:
                                                        data['eventEndDate'],
                                                    eventStartDate:
                                                        data['eventStartDate'],
                                                    attendNumber:
                                                        data['attendNumber'],
                                                    contactNumber:
                                                        data['contactNumber'],
                                                    paidAmount:
                                                        data['paidAmount']
                                                            .toString(),
                                                    name: data['name'],
                                                    purpose: data['purpose'],
                                                    remainingAmount:
                                                        data['remainingAmount']
                                                            .toString(),
                                                    totalAmount:
                                                        data['totalAmount']
                                                            .toString(),
                                                    uuid: data['uuid'],
                                                  )));
                                    },
                                    child: Text("View Details"),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  });
            }),
      ),
    );
  }
}
