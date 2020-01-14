import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:thespotless/laundry.dart';
import 'package:thespotless/job.dart';
import 'mainscreen.dart';

class JobDetailDone extends StatefulWidget {
  final Job job;
  final Laundry laundry;
 

  const JobDetailDone({Key key, this.job, this.laundry}) : super(key: key);

  @override
  _JobDetailDoneState createState() => _JobDetailDoneState();
}

class _JobDetailDoneState extends State<JobDetailDone> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blue));
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('JOB DETAILS'),
            backgroundColor: Colors.blue,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: DetailInterface(
                job: widget.job,
                laundry: widget.laundry,
              ),
            ),
          )),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
            laundry: widget.laundry,
          ),
        ));
    return Future.value(false);
  }

}

class DetailInterface extends StatefulWidget {
  final Job job;
  final Laundry laundry;
  DetailInterface({this.job, this.laundry});

  @override
  _DetailInterfaceState createState() => _DetailInterfaceState();
}

class _DetailInterfaceState extends State<DetailInterface> {

 

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: <Widget>[
        Center(),
        Container(
          width: 280,
          height: 200,
         
        ),
        SizedBox(
          height: 10,
        ),
        Text(widget.job.job_name.toUpperCase(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
        Container(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Table(children: [
                TableRow(children: [
                  Text("Job Description",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.job.job_desc),
                ]),
                TableRow(children: [
                  Text("Cloth Pickup",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.job.job_location),
                ]),
                TableRow(children: [
                  Text("Cloth Return",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.job.job_destination),
                ]),
                TableRow(children: [
                  Text("Customer",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.job.job_owner),
                ]),
                TableRow(children: [
                  Text("Date",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.job.job_date),
                ]),
                TableRow(children: [
                  Text("Launder",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.job.driver_email),
                ]),
                
                

                
              ]),
              SizedBox(
                height: 10,
              ),
              
              
            ],
          ),
        ),
      ],
    );
  }
  
}
