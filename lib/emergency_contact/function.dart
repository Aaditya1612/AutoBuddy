import 'package:autobuddy/emergency_contact/GlobalAppBar.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class emergency_cnt extends StatefulWidget {
  const emergency_cnt({super.key});

  @override
  State<emergency_cnt> createState() => _emergency_cntState();
}

class _emergency_cntState extends State<emergency_cnt> {
  PhoneContact? _phoneContact;
  String number1 = "";
  String name1 = "";
  String email1 = "";
  String number2 = "";
  String name2 = "";
  String email2 = "";
  String number3 = "";
  String name3 = "";
  String email3 = "";
  String number = "";
  String name = "";
  String email = "";
  EmailContact? _emailContact;
  TextEditingController editname = TextEditingController();
  TextEditingController editnumber = TextEditingController();
  TextEditingController editemail = TextEditingController();
  late SharedPreferences prefs;
  bool contactpckd = false;
  bool emailpckd = false;
  bool isloading = false;
  final _formKey = GlobalKey<FormState>();

  getcontact(int id) async {
    prefs = await SharedPreferences.getInstance();
    bool granted = await FlutterContactPicker.hasPermission();

    if (!granted) {
      granted = await FlutterContactPicker.requestPermission();
      // showDialog(
      //     context: context,
      //     builder: (context) => AlertDialog(
      //         title: const Text('Granted: '), content: Text('$granted')));
    }

    if (granted) {
      final PhoneContact contact =
          await FlutterContactPicker.pickPhoneContact();
      print(contact);
      setState(() {
        _phoneContact = contact;
        contactpckd = true;
        prefs.setBool('contactpckd', true);
        editname.text = _phoneContact!.fullName.toString();
        editnumber.text = _phoneContact!.phoneNumber!.number!.toString();
        editcontact(id);
        prefs.setBool('emailpckd', true);
      });
    }
  }

  String? validateName(String? value) {
    if (value!.isNotEmpty)
      return 'Name must be more than 2 charater';
    else
      return null;
  }

  String? validateMobile(String? value) {
    if (value!.length != 10)
      return 'Mobile Number must be of 10 digit';
    else
      return null;
  }

  String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!))
      return 'Enter Valid Email';
    else
      return null;
  }

  editcontact(int id) async {
    String uid = id.toString();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          // title: Text(AppLocalizations.of(context).contact),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: editname,
                    validator: (name) {
                      if (name == null || name.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Name",
                      icon: Icon(Icons.account_box),
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    // validator: validateMobile,
                    controller: editnumber,

                    validator: (number) {
                      String num = number.toString().trim();
                      if (number!.length != 10)
                        return 'Mobile Number must be of 10 digit';
                      else
                        return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Number",
                      icon: Icon(Icons.numbers_outlined),
                    ),
                  ),
                  TextFormField(
                    controller: editemail,
                    // validator: validateEmail,
                    validator: (email) {
                      String pattern =
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regex = RegExp(pattern);
                      if (!regex.hasMatch(email!))
                        return 'Enter Valid Email';
                      else
                        return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "email",
                      icon: Icon(Icons.email),
                    ),
                    // initialValue: email + id.toString(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Builder(builder: (context) {
              return ElevatedButton(
                child: Text("Submit"),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    name = await editname.text;
                    number = await editnumber.text.trim();
                    email = await editemail.text;

                    assigndata(id);
                    Navigator.pop(context);
                  }
                },
              );
            }),
          ],
        );
      },
    );
  }

  assigndata(int id) {
    if (id == 1) {
      setState(() {
        name1 = name;
        email1 = email;
        number1 = number.trim();
      });
      prefs.setString('name1', name1);
      prefs.setString('number1', number1);
      prefs.setString('email1', email1);
    }
    if (id == 2) {
      setState(() {
        name2 = name;
        email2 = email;
        number2 = number.trim();
      });
      prefs.setString('name2', name2);
      prefs.setString('number2', number2);
      prefs.setString('email2', email2);
    }
    if (id == 3) {
      setState(() {
        name3 = name;
        email3 = email;
        number3 = number.trim();
      });
      prefs.setString('name3', name3);
      prefs.setString('number3', number3);
      prefs.setString('email3', email3);
    }
  }

  getid() async {
    prefs = await SharedPreferences.getInstance();
    contactpckd = await prefs.getBool('contactpckd') ?? false;
    emailpckd = await prefs.getBool('emailpckd') ?? false;

    if (emailpckd) {
      email1 = await prefs.getString('email1').toString();
      email2 = await prefs.getString('email2').toString();
      email3 = await prefs.getString('email3').toString();
    }

    if (contactpckd) {
      name1 = await prefs.getString('name1').toString();
      name2 = await prefs.getString('name2').toString();
      name3 = await prefs.getString('name3').toString();
      number1 = await prefs.getString('number1').toString();
      number2 = await prefs.getString('number2').toString();
      number3 = await prefs.getString('number3').toString();
    }
    isloading = true;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(children: [
        if (name1 != "" && name1 != 'null') ...[
          Container(
            child: emergencyContactTile(name1, number1, email1, 1),
          ),
        ] else ...[
          MaterialButton(
            onPressed: () async {
              await getcontact(1);
              name1 = name;
              number1 = number.trim();
              email1 = email;
              prefs.setString('name1', name1);
              prefs.setString('number1', number1);
              prefs.setString('email1', email1);
            },
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: const Icon(
              Icons.add_circle_outline,
              color: Colors.black45,
            ),
          )
        ],
        const SizedBox(
          height: 10,
        ),
        if (name2 != "" && name2 != 'null') ...[
          Container(
            child: emergencyContactTile(name2, number2, email2, 2),
          ),
        ] else ...[
          MaterialButton(
            onPressed: () async {
              await getcontact(2);
              name2 = name;
              number2 = number.trim();
              email2 = email;
              prefs.setString('name2', name2);
              prefs.setString('number2', number2);
              prefs.setString('email2', email2);
            },
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: const Icon(
              Icons.add_circle_outline,
              color: Colors.black45,
            ),
          )
        ],
        const SizedBox(
          height: 10,
        ),
        if (name3 != "" && name3 != 'null') ...[
          Container(
            child: emergencyContactTile(name3, number3, email3, 3),
          ),
        ] else ...[
          MaterialButton(
            onPressed: () async {
              await getcontact(3);
              name3 = name;
              number3 = number.trim();
              email3 = email;
              prefs.setString('name3', name3);
              prefs.setString('number3', number3);
              prefs.setString('email3', email3);
            },
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: const Icon(
              Icons.add_circle_outline,
              color: Colors.black45,
            ),
          )
        ],
        const SizedBox(
          height: 10,
        ),
      ]),
    );
  }

  Container emergencyContactTile(
      String name, String phone, String email, int id) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 85,
      decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.person,
                color: Color.fromARGB(255, 244, 39, 107),
              ),
              const SizedBox(
                width: 12,
              ),
              Container(
                width: 140,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      phone,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      email,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          IconButton(
              onPressed: () async {
                debugPrint("Delete");
                setState(() {
                  if (id == 1) name1 = "";
                  if (id == 2) name2 = "";
                  if (id == 3) name3 = "";
                });
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.grey,
                size: 20,
              )),
          VerticalDivider(
            color: Colors.grey,
            thickness: 1,
            width: 1,
            indent: 14,
            endIndent: 14,
          ),
          IconButton(
              // splashColor: Colors.green,
              // iconSize: 20,
              onPressed: () async {
                debugPrint("Edit");
                prefs = await SharedPreferences.getInstance();
                if (id == 1) {
                  editname.text = await prefs.getString('name1').toString();
                  editnumber.text = await prefs.getString('number1').toString();
                  editemail.text = await prefs.getString('email1').toString();
                }
                if (id == 2) {
                  editname.text = await prefs.getString('name2').toString();
                  editnumber.text = await prefs.getString('number2').toString();
                  editemail.text = await prefs.getString('email2').toString();
                }
                if (id == 3) {
                  editname.text = await prefs.getString('name3').toString();
                  editnumber.text = await prefs.getString('number3').toString();
                  editemail.text = await prefs.getString('email3').toString();
                }
                await editcontact(id);
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.grey,
                size: 20,
              ))
        ],
      ),
    );
  }
}
