// ignore_for_file: unused_import, file_names, unused_field, prefer_is_not_empty, use_build_context_synchronously

import 'package:autobuddy/auth/controller/buttonController.dart';
import 'package:autobuddy/auth/controller/styleController.dart';
import 'package:autobuddy/auth/services/loginWithGoogle.dart';
import 'package:autobuddy/auth/services/signUpWithGoogle.dart';
import 'package:autobuddy/views/home_view.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  static const String routeName = "/signupScreen";

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _fname = TextEditingController();
  final TextEditingController _lname = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _ = TextEditingController();

  String verId = "";
  String firstName = "";
  String lastName = "";
  String email = "";
  String phone = "";
  String pswd = "";

  bool isLoading1 = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(0, 10, 56, 1),
        body: Stack(
          children: [
            //LottieBuilder.asset("assets/animations/bg-1.json"),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.pink,
                                fontSize: 25,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            textAlign: TextAlign.center,
                            "Welcome! We are happy to have you here",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        const SizedBox(height: 20),
                        //Expanded(child: Container()),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: _fname,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration:
                                      Styles.textFieldStyle("First Name"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: _lname,
                                  keyboardType: TextInputType.name,
                                  decoration:
                                      Styles.textFieldStyle("Last Name"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: _phone,
                                  decoration:
                                      Styles.textFieldStyle("Mobile Number"),
                                  keyboardType: TextInputType.phone,
                                  validator: (val) {
                                    if (!(val!.isEmpty) &&
                                        !RegExp(r"^(\d+)*$").hasMatch(val)) {
                                      return "Enter a valid phone number";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.pink)),
                                onPressed: () async {
                                  setState(() {
                                    isLoading1 = !isLoading1;
                                  });
                                  await googleservice().signUpWithGoogle(
                                      _fname.text, _lname.text, _phone.text);
                                  Navigator.popAndPushNamed(
                                      context, HomePageView.routeName);
                                },
                                child: !isLoading1
                                    ? Text(
                                        "Authenticate with Google",
                                      )
                                    : const CircularProgressIndicator(
                                        color: Colors.white),
                              ),
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already a User?",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                            TextButton(
                                onPressed: () async {
                                  await googleservicelog().signInWithGoogle();
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      HomePageView.routeName, (route) => false);
                                },
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        "Login",
                                        style: TextStyle(
                                            color: Colors.pink, fontSize: 17),
                                      ))
                          ],
                        )
                      ],
                    ),
                  ),
                )),
          ],
        ));
  }
}
