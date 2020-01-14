import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:thespotless/laundry.dart';
import 'package:thespotless/job.dart';
import 'package:thespotless/jobdetaildone.dart';
import 'package:thespotless/mainscreen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'SlideRightRoute.dart';
import 'package:toast/toast.dart';

double perpage = 1;

class MyPost extends StatefulWidget {
  final Laundry laundry;

  MyPost({Key key, this.laundry});

  @override
  _MyPostState createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  List data;
  bool _loggedIn = false;

  final TextEditingController _priceCon = TextEditingController();
  final TextEditingController _descCon = TextEditingController();
  final TextEditingController _pickupCon = TextEditingController();
  final TextEditingController _destiCon = TextEditingController();

  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    
  }

  @override
  Widget build(BuildContext context) {
    
   SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.orange));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Scaffold(
            resizeToAvoidBottomPadding: false,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Colors.blue,
              elevation: 2.0,
              onPressed: _addJobDialog,
              tooltip: 'Request new help',
            ),
              
              body: RefreshIndicator(
              key: refreshKey,
              color: Colors.orange,
              onRefresh: () async {
                await refreshList();
              },

              child:ListView.builder(
                  
                  itemCount: data == null ? 1 : data.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Container(
                        child: Column(
                          children: <Widget>[
                                Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10,10,10,5),
                                    height: MediaQuery.of(context).size.height/5,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.teal[50],
                  
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(15,15,15,5),
                                  decoration: BoxDecoration(
                                  color: Colors.orange[100],
                                  border: Border.all(color: Colors.orange[300]),
                                  borderRadius: BorderRadius.all(
                                  Radius.circular(10.0)),
                                  boxShadow: [BoxShadow(blurRadius: 10,color: Colors.orange[400],offset: Offset(0,0))]),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.person,
                                                    ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    widget.laundry.name
                                                            .toUpperCase() ??
                                                        "Not registered",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.email,
                                                    ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(widget.laundry.email),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.phone,
                                                    ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(widget.laundry.phone),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.attach_money,
                                                    ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(widget.laundry.credit),
                                                ),
                                              ],
                                            ),
                                            
                                            
                                            
                                          ],
                                        ),
                                  ),),

                                  SizedBox(
                                    height: 15,
                                  ),

                                  Container(
                                    padding: EdgeInsets.fromLTRB(15,5,15,5),
                                    color: Colors.orange,
                                    child: Center(
                                    child: Text("Request Posted",
                                    style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)
                                    ),),                            
                                    ),

                                    SizedBox(
                                      height: 4,
                                    ),

                                ],
                              ),
                      
                        ])
                      );
                    }                   
                    if (index == data.length && perpage > 1) {
                      return Container(
                        width: 250,
                        color: Colors.white,
                        child: MaterialButton(
                          child: Text(
                            "Load More",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {},
                        ),
                      );
                    }
                    index -= 1;
                    return Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Card(
                        elevation: 2,
                        child: InkWell(
                          onLongPress: () => _onJobDelete(
                              data[index]['job_id'].toString(),
                              data[index]['job_name'].toString()),
                          onTap: ()=> _onJobDetail(
                            data[index]['job_id'],
                            data[index]['job_name'],
                            data[index]['job_price'],
                            data[index]['job_desc'],
                            data[index]['job_location'],
                            data[index]['job_destination'],
                            data[index]['job_owner'],
                            data[index]['job_date'],
                            data[index]['driver_email'],
                            widget.laundry.name,
                            widget.laundry.credit,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white),
                                        image: new DecorationImage(
                                            fit: BoxFit.cover,
                                            image: new NetworkImage(
                                                "http://pickupandlaundry.com/thespotless/stuart/profile/${widget.laundry.email}.jpg")
                                            
                              ))),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                            data[index]['job_name']
                                                .toString()
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("Date " + data[index]['job_date']),
                                        
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
    )));
  }


  Future<String> makeRequest() async {
    String urlLoadJobs = "http://pickupandlaundry.com/thespotless/stuart/php/loadrequest.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading Jobs");
    pr.show();
    http.post(urlLoadJobs, body: {
      "email": widget.laundry.email ?? "notavailable",
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["jobs"];
        perpage = (data.length / 10);
        print("data");
        print(data);
        pr.dismiss();
      });
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
  }

  void _onLogin(String email, BuildContext ctx) {
     String urlgetuser = "http://pickupandlaundry.com/thespotless/stuart/php/getdriver.php";

    http.post(urlgetuser, body: {
      "email": email,
    }).then((res) {
      print(res.statusCode);
      var string = res.body;
      List dres = string.split(",");
      print(dres);
      if (dres[0] == "success") {
        Laundry laundry = new Laundry(
            name: dres[1],
            email: dres[2],
            phone: dres[3],
            credit: dres[4]);
        Navigator.push(ctx,
            MaterialPageRoute(builder: (context) => MainScreen(laundry: laundry)));
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future init() async {
    this.makeRequest();
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this.makeRequest();
    return null;
  }

  void _onJobDetail(
      String job_id,
      String job_name,
      String job_price,
      String job_desc,
      String job_location,
      String job_destination,
      String job_owner,
      String job_date,
      String driver_email,
      String name,
      String credit) {
    Job job = new Job(
        job_id: job_id,
        job_name: job_name,
        job_price: job_price,
        job_desc: job_desc,
        job_location: job_location,
        job_destination: job_destination,
        job_owner: job_owner,
        job_date: job_date,
        driver_email: driver_email,
       );
    //print(data);
    
    Navigator.push(context, SlideRightRoute(page: JobDetailDone(job: job, laundry: widget.laundry)));
  }


  void _onJobDelete(String job_id, String job_name) {
    print("Delete " + job_id);
    _showDialog(job_id, job_name);
  }

  void _showDialog(String job_id, String job_name) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete " + job_name),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                deleteRequest(job_id);
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

  Future<void> _addJobDialog() {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Order a Ride with 1 credits'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                    controller: _priceCon,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      icon: Icon(Icons.attach_money),
                    )),
                TextField(
                    controller: _descCon,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Job Description',
                      icon: Icon( Icons.description),
                    )),
                TextField(
                    controller: _pickupCon,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Pickup point',
                      icon: Icon(Icons.location_searching),
                    )),
                TextField(
                    controller: _destiCon,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "I'm going to...",
                      icon: Icon(Icons.location_on),
                    )),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: _cancel,
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: _prepareJob,
            ),
          ],
        );
      },
    );
  }

  void _prepareJob() {
    String jobName = "Ride to " + _destiCon.text;
    String price = _priceCon.text;
    String description = _descCon.text;
    String location = _pickupCon.text;
    String destination = _destiCon.text;

    if (jobName.isEmpty ||
        price.isEmpty ||
        description.isEmpty ||
        location.isEmpty ||
        destination.isEmpty) {
      Toast.show("Please complete the field", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      if (widget.laundry != null) {
        _uploadJob(widget.laundry.email, jobName, price, description, location,
            destination, widget.laundry.credit);
      } else {
        Toast.show("Please register to request for a ride", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
      }
    }
  }


  void _uploadJob(
      String email, jobName, price, description, location, destination, credit) {
    String url = 'http://pickupandlaundry.com/thespotless/stuart/php/uploadjob.php';

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Requesting pickup");
    pr.show();

    http.post(url, body: {
      "job_name": jobName,
      "job_price": price,
      "job_desc": description,
      "job_location": location,
      "job_destination": destination,
      "email": email,
      "credit": credit,
    }).then((res) {
      print(res.statusCode);
      Toast.show(res.body, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      pr.dismiss();
      _onLogin(widget.laundry.email, context);

    }).catchError((err) {
      print(err);
    });
  }

  

  void _cancel() {
    setState(() {
      _priceCon.text = "";
      _descCon.text = "";
      _pickupCon.text = "";
      _destiCon.text = "";
    });

    Navigator.of(context).pop();
  }

  Future<String> deleteRequest(String job_id) async {
    String urlLoadJobs = "http://pickupandlaundry.com/thespotless/stuart/php/deletejob.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Deleting Jobs");
    pr.show();
    http.post(urlLoadJobs, body: {
      "job_id": job_id,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        init();
      } else {
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
  }


  


}
