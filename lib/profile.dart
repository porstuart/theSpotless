import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:thespotless/loginscreen.dart';
import 'package:thespotless/registrationscreen.dart';
import 'package:thespotless/splashscreen.dart';
import 'package:thespotless/laundry.dart';
import 'package:thespotless/payment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

String urlgetdriver = "http://pickupandlaundry.com/thespotless/stuart/php/getdriver.php";
String urluploadImage =
    "http://pickupandlaundry.com/thespotless/stuart/php/upload_imageprofile.php";
String urlupdate = "http://pickupandlaundry.com/thespotless/stuart/php/updatedriver.php";
File _image;
int number = 0;
String _value;

class Profile extends StatefulWidget {
  final Laundry laundry;
  Profile({this.laundry});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: false,
           appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Profile', style: TextStyle(color:Colors.black)),
        ),
          body: ListView.builder(
              //Step 6: Count the data
              itemCount: 5,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Stack(children: <Widget>[
                         
                          Column(
                            children: <Widget>[
                              Center(
                                child: Text("My Pickup",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                onTap: _takePicture,
                                child: Container(
                                    width: 150.0,
                                    height: 150.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white),
                                        image: new DecorationImage(
                                            fit: BoxFit.cover,
                                            image: new NetworkImage(
                                                "http://pickupandlaundry.com/thespotless/stuart/profile/${widget.laundry.email}.jpg")
                                            
                              )))),
                              SizedBox(height: 5),
                              Container(
                                child: Text(
                                  widget.laundry.name?.toUpperCase() ??
                                      'Not register',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              
                              Container(
                                child: Text(
                                  widget.laundry.email,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ),
                              Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.phone,
                                      ),
                                      Text(widget.laundry.phone??
                                          'not registered'),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                color: Colors.blue,
                                child: Center(
                                  child: Text("My Profile ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),                            
                              ),
                            ],
                          ),
                        ]),
                        SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  );
                }

                if (index == 1) {
                  return Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Column(
                      children: <Widget>[
                        MaterialButton(
                          onPressed: _ChangeName,
                          child: Text("Change NAME"),
                        ),
                        MaterialButton(
                          onPressed: _ChangePassword,
                          child: Text("Change PASSWORD"),
                        ),
                        MaterialButton(
                          onPressed: _ChangePhone,
                          child: Text("Change PHONE"),
                        ),
                        MaterialButton(
                          onPressed: _loadPayment,
                          child: Text("BUY CREDIT"),
                        ),
                        MaterialButton(
                          onPressed: _registerAccount,
                          child: Text("REGISTER"),
                        ),
                        MaterialButton(
                          onPressed: _gotologinPage,
                          child: Text("LOG IN"),
                        ),
                        MaterialButton(
                          onPressed: _logout,
                          child: Text("LOG OUT"),
                        )
                      ],
                    ),
                  );
                }
              }),
        ));
  }

  void _takePicture() async {
    if (widget.laundry.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Take new profile picture?"),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                Navigator.of(context).pop();
                _image =
                    await ImagePicker.pickImage(source: ImageSource.camera);

                String base64Image = base64Encode(_image.readAsBytesSync());
                http.post(urluploadImage, body: {
                  "encoded_string": base64Image,
                  "email": widget.laundry.email,
                }).then((res) {
                  print(res.body);
                  if (res.body == "success") {
                    setState(() {
                      number = new Random().nextInt(100);
                      print(number);
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', '');
    await prefs.setString('pass', '');
    print("LOGOUT");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SplashScreen()));
  }

  void _ChangeName() {
    TextEditingController nameController = TextEditingController();
    // flutter defined function

    if (widget.laundry.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change " + widget.laundry.name),
          content: new TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                icon: Icon(Icons.person),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (nameController.text.length < 5) {
                  Toast.show(
                      "Name should be more than 5 characters long", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.laundry.email,
                  "name": nameController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.laundry.name = dres[1];
                      if (dres[0] == "success") {
                        print("in setstate");
                        widget.laundry.name = dres[1];
                      }
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _ChangePassword() {
    TextEditingController passController = TextEditingController();
    // flutter defined function
    print(widget.laundry.name);
    if (widget.laundry.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change Password for " + widget.laundry.name),
          content: new TextField(
            controller: passController,
            decoration: InputDecoration(
              labelText: 'New Password',
              icon: Icon(Icons.lock),
            ),
            obscureText: true,
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (passController.text.length < 5) {
                  Toast.show("Password too short", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.laundry.email,
                  "password": passController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.laundry.name = dres[1];
                      if (dres[0] == "success") {
                        Toast.show("Success", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                            savepref(passController.text);
                            Navigator.of(context).pop();
                      }
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
                
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _ChangePhone() {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function
    print(widget.laundry.name);
    if (widget.laundry.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change phone for" + widget.laundry.name),
          content: new TextField(
              keyboardType: TextInputType.phone,
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'phone',
                icon: Icon(Icons.phone),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (phoneController.text.length < 5) {
                  Toast.show("Please enter correct phone number", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      return;
                }
                http.post(urlupdate, body: {
                  "email": widget.laundry.email,
                  "phone": phoneController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    setState(() {
                      widget.laundry.phone = dres[3];
                      Toast.show("Success ", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      Navigator.of(context).pop();
                      return;
                    });
                  }
                  
                }).catchError((err) {
                  print(err);
                });
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _registerAccount() {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function
    print(widget.laundry.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Register new account?"),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                print(
                  phoneController.text,
                );
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => RegisterScreen()));
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _gotologinPage() {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function
    print(widget.laundry.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Go to login page?"),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                print(
                  phoneController.text,
                );
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void savepref(String pass) async {
    print('Inside savepref');
    SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('pass', pass);
  }


  void _loadPayment() async {
    // flutter defined function
    if (widget.laundry.name == "not register") {
      Toast.show("Not allowed please register", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Buy Credit?"),
          content: Container(
            height: 100,
            child: DropdownExample(),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                if(_value!=null){
                Navigator.of(context).pop();
                var now = new DateTime.now();
                var formatter = new DateFormat('ddMMyyyyhhmmss-');
                String formatted = formatter.format(now)+randomAlphaNumeric(10);
                print(formatted);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PaymentScreen(laundry:widget.laundry,orderid:formatted, val:_value)));
                }else{
                  Toast.show("Please choose an amount.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
                }},
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
class DropdownExample extends StatefulWidget {
  @override
  _DropdownExampleState createState() {
    return _DropdownExampleState();
  }
}

class _DropdownExampleState extends State<DropdownExample> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<String>(
        items: [
          DropdownMenuItem<String>(
            child: Text('50 HCredit (RM10)'),
            value: '10',
          ),
          DropdownMenuItem<String>(
            child: Text('100 HCredit (RM20)'),
            value: '20',
          ),
          DropdownMenuItem<String>(
            child: Text('150 HCredit (RM30)'),
            value: '30',
          ),
        ],
        onChanged: (String value) {
          setState(() {
            _value = value;
          });
        },
        hint: Text('Select Credit'),
        
        value: _value,
      ),
    );
  }
}
