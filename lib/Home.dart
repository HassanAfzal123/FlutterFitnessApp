import 'dart:ui';

import 'DailyCaloriesIntake.dart';

import 'ServerResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TotalCalories {
  final int status;
  final int totalCalorieIntake;
  final String message;
  TotalCalories({this.message, this.status, this.totalCalorieIntake});
  factory TotalCalories.fromJson(Map<String, dynamic> json) {
    return TotalCalories(
        status: json['status'],
        message: json['message'],
        totalCalorieIntake: json['totalCalorieIntake']);
  }
}

class Home extends StatefulWidget {
  bool loading = false;
  final Post serverResponse;
  int totalCalorieIntake = 0;

  Home({Key key, @required this.serverResponse}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  void getData() async {
    setState(() {
      widget.loading = true;
    });
    Map data = {'userId': widget.serverResponse.userId};
    await http
        .post(
            "https://us-central1-firestoredemo-bd9a8.cloudfunctions.net/getTotalCalorieIntake",
            headers: {
              'Content-type': 'application/x-www-form-urlencoded',
              'Accept': 'application/json'
            },
            body: data)
        .then((response) {
      TotalCalories userData =
          TotalCalories.fromJson(json.decode(response.body));
          print(response);
      if (userData.status == 200) {
        setState(() {
          widget.loading = false;
          widget.totalCalorieIntake = userData.totalCalorieIntake;
        });
      }
      else{
        showDialog(
            context: context,
            child: new AlertDialog(
              title: new Text("Server error"),
              content: new Text(userData.message),
            ));
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  void initState() {
    //TODO: implement initState
    if (widget.totalCalorieIntake == 0) {
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final calorieIntakeCard = Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(leading: Icon(Icons.local_dining), title: Text('Food')),
            Text(
              'Total Calories: ' + widget.totalCalorieIntake.toString(),
              style: TextStyle(
                  fontSize: 25,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600),
            ),
            new ButtonTheme(
                minWidth: 150.0,
                height: 20.0,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (BuildContext context) =>
                    CalorieIntake(serverResponse: widget.serverResponse)
            ));
                  },
                  textColor: Colors.black,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[Colors.white, Colors.blue],
                      ),
                    ),
                    padding: const EdgeInsets.all(5.0),
                    child:
                        ListTile(leading: Icon(Icons.add), title: Text('Add')),
                  ),
                ))
          ],
        ),
      ),
    );

    return new Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'The Aesthetic Club',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Courier New',
                  fontWeight: FontWeight.w900),
            ),
          ),
          backgroundColor: Colors.teal,
          elevation: 3.0,
        ),
        body: new Stack(children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              color: Colors.black87,
            ),
          ),
          new Center(
              child: AbsorbPointer(
                  absorbing: widget.loading,
                  child: new Form(
                      key: _formKey,
                      child: new Container(
                          child: ListView(
                        padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                        shrinkWrap: true,
                        children: <Widget>[
                          calorieIntakeCard,
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ))))),
          new Column(
              children: widget.loading == true
                  ? <Widget>[
                      Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Center(
                                  child: SizedBox(
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.red),
                                ),
                                width: 140,
                                height: 140,
                              )),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Text(''),
                              )
                            ],
                          ))
                    ]
                  : <Widget>[])
        ]));
  }
}
