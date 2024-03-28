import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hallbooking/screens/main/main_dashboard.dart';
import 'package:hallbooking/services/auth_methods.dart';
import 'package:hallbooking/widgets/button.dart';
import 'package:hallbooking/widgets/textform.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Image.asset(
              "assets/logo.png",
              width: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormInputField(
                  controller: _emailController,
                  hintText: "Email Address",
                  IconSuffix: Icons.email,
                  textInputType: TextInputType.emailAddress),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormInputField(
                  controller: _passwordController,
                  hintText: "Password",
                  IconSuffix: Icons.visibility,
                  textInputType: TextInputType.visiblePassword),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _isLoading
                  ? CircularProgressIndicator()
                  : SaveButton(
                      title: "Login",
                      onTap: () async {
                        if (_emailController.text.isEmpty ||
                            _passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Email or Password is Required")));
                        } else {
                          setState(() {
                            _isLoading = true;
                          });

                          String res = await AuthMethods().loginUpUser(
                            email: _emailController.text,
                            pass: _passwordController.text,
                          );

                          setState(() {
                            _isLoading = false;
                          });
                          if (res != 'sucess') {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(res)));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => MainDashboard()));
                          }
                        }
                      }),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
