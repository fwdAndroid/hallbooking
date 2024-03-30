import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hallbooking/screens/expenses/add_expenses.dart';
import 'package:hallbooking/screens/expenses/expense_detail.dart';
import 'package:hallbooking/screens/expenses/search_expense.dart';
import 'package:hallbooking/widgets/colors.dart';

class ShowExpenses extends StatefulWidget {
  const ShowExpenses({super.key});

  @override
  State<ShowExpenses> createState() => _ShowExpensesState();
}

class _ShowExpensesState extends State<ShowExpenses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Expenses"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainBtnColor,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (builder) => AddExpenses()));
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
                    MaterialPageRoute(builder: (builder) => SearchExpense()));
              },
              decoration: InputDecoration(
                hintText: "Search By Category",
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
                    .collection("expenses")
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
                        "No Expense Details Available yet",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return StreamBuilder<Object>(
                            stream: FirebaseFirestore.instance
                                .collection("expenses")
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
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Row(
                                        children: [
                                          Text(
                                            "Vendor Name:",
                                            style: TextStyle(
                                                color: titleColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            data['vendorName'],
                                            style: TextStyle(
                                                color: titleColor,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                      subtitle: Row(
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
                                      trailing: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (builder) =>
                                                      ExpenseDetail(
                                                        billDate:
                                                            data['billDate'],
                                                        vendorName:
                                                            data['vendorName'],
                                                        amount: data['amount']
                                                            .toString(),
                                                        vendorGST:
                                                            data['vendorGST']
                                                                .toString(),
                                                        description:
                                                            data['description'],
                                                        category:
                                                            data['category'],
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
        ],
      ),
    );
  }
}
