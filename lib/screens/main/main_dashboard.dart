import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hallbooking/screens/booking/show_booking.dart';
import 'package:hallbooking/screens/expenses/show_expense.dart';
import 'package:hallbooking/screens/login_auth.dart';
import 'package:hallbooking/widgets/button.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset("assets/logo.png"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) => ShowBooking()));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.book,
                          ),
                          Text("Booking")
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => ShowExpenses()));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.exposure_neg_1_sharp,
                          ),
                          Text("Expenses")
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (builder) => ShowExpenses()));
            },
            child: Container(
              height: 150,
              width: 150,
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.monetization_on,
                    ),
                    Text("Profit & Loss")
                  ],
                ),
              ),
            ),
          ),
          Flexible(child: Container()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SaveButton(
                title: "Logout",
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (builder) => LoginScreen()));
                }),
          )
        ],
      ),
    );
  }
}
