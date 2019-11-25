import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lab_2/validation.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email;
  var key = GlobalKey<FormState>();
  var loading = false;

  check() {
    final form = key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    }
  }

  submit() async {
    setState(() {
      loading = true;
    });
    final response = await http.post(
        "http://pickupandlaundry.com/thespotless/stuart/php/forgotPw.php",
        body: {"email": email.trim()});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];

    if (value == 1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PasswordValidation(email)));
    } else {
      print(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
      body: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Enter your email address to reset password"),
                SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  onSaved: (e) => email = e,
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Please enter your email";
                    }
                  },
                ),
                SizedBox(
                  height: 8.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.orange,
                        Colors.orange[900],
                      ],
                    ),
                  ),
                  child: FlatButton(
                      onPressed: () {
                        check();
                      },
                      child: Text(
                        "SUBMIT",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ],
            ),
          )),
    );
  }
}