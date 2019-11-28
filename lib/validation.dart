import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PasswordValidation extends StatefulWidget {
  final String email;
  PasswordValidation(this.email);

  @override
  _PasswordValidationState createState() => _PasswordValidationState();
}

class _PasswordValidationState extends State<PasswordValidation> {
  String code;
  var key = GlobalKey<FormState>();

  check() {
    final form = key.currentState;

    if (form.validate()) {
      form.save();
      submit();
    }
  }

  submit() async {
    final response = await http.post(
        "http://pickupandlaundry.com/thespotless/stuart/php/passwordValidation.php",
        body: {
          "email": widget.email,
          "code": code,
        });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];

    if (value == 1) {
      print("Your password has been changed");
    } else {
      print("$message");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Form(
          key: key,
          child: ListView(
            children: <Widget>[
              TextFormField(
                onSaved: (e) => code = e,
              ),
              SizedBox(
                height: 16.0,
              ),
              Container(
                width: double.infinity,
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
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
