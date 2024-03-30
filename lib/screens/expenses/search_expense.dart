import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hallbooking/screens/expenses/expense_detail.dart';
import 'package:hallbooking/widgets/colors.dart';

class SearchExpense extends StatefulWidget {
  const SearchExpense({Key? key}) : super(key: key);

  @override
  State<SearchExpense> createState() => _SearchExpenseState();
}

class _SearchExpenseState extends State<SearchExpense> {
  String dropdownValue = 'EB'; // Default selected category
  var categories = [
    'EB',
    'Gas',
    'Maintenance',
    'Gunsel Diesel',
    "Wages",
    "Internet",
    'Others',
  ]; // List of categories

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Expense Search"),
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
                .collection("expenses")
                .where('category',
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
                                  data['vendorName'],
                                  style: TextStyle(
                                      color: titleColor,
                                      fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  data['category'],
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Amount:",
                                      style: TextStyle(
                                          color: titleColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      data['amount'].toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "GST:",
                                      style: TextStyle(
                                          color: titleColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      data['vendorGST'].toString(),
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
                                    builder: (builder) => ExpenseDetail(
                                      billDate: data['billDate'],
                                      vendorGST: data['vendorGST'],
                                      vendorName: data['vendorName'],
                                      amount: data['amount'].toString(),
                                      description: data['description'],
                                      category: data['category'].toString(),
                                      uuid: data['uuid'],
                                    ),
                                  ),
                                );
                              },
                              child: Text("View Details"),
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
