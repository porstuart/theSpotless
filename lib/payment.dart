import 'dart:async';
import 'package:thespotless/laundry.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'mainscreen.dart';

class PaymentScreen extends StatefulWidget {
  final Laundry laundry;
  final String orderid, val;
  PaymentScreen({this.laundry, this.orderid, this.val});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressAppBar,
        child: Scaffold(
            appBar: AppBar(
              title: Text('PAYMENT'),
              backgroundColor: Colors.blue,
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: WebView(
                    initialUrl:
                        'http://pickupandlaundry.com/thespotless/stuart/php/payment.php?email=' +
                            widget.laundry.email +
                            '&mobile=' +
                            widget.laundry.phone +
                            '&name=' +
                            widget.laundry.name +
                            '&amount=' +
                            widget.val +
                            '&orderid=' +
                            widget.orderid,
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.complete(webViewController);
                    },
                  ),
                )
              ],
            )));
  }

  Future<bool> _onBackPressAppBar() async {
    print("onbackpress payment");
    String urlgetuser =
        "http://pickupandlaundry.com/thespotless/stuart/php/getdriver.php";

    http.post(urlgetuser, body: {
      "email": widget.laundry.email,
    }).then((res) {
      print(res.statusCode);
      var string = res.body;
      List dres = string.split(",");
      print(dres);
      if (dres[0] == "success") {
        Laundry updatedriver = new Laundry(
          name: dres[1],
          email: dres[2],
          phone: dres[3],
          credit: dres[4],
        );
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MainScreen(laundry: updatedriver)));
      }
    }).catchError((err) {
      print(err);
    });
    return Future.value(false);
  }
}
