import 'dart:ui';

import 'package:fitness_app_flutter/TabScreen.dart';

import 'Home.dart';
import 'ServerResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostCalorie {
  final int status;
  final String message;

  PostCalorie({this.status, this.message});
  factory PostCalorie.fromJson(Map<String, dynamic> json) {
    return PostCalorie(status: json['status'], message: json['message']);
  }
}

class CalorieIntake extends StatefulWidget {
  bool loading = false;
  final Post serverResponse;

  CalorieIntake({Key key, @required this.serverResponse}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CalorieIntakeState();
  }
}

class _CalorieIntakeState extends State<CalorieIntake>
    with TickerProviderStateMixin {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _intakeMealCategory ;
  int _calories = 0;
  DateTime dateCurrent = DateTime.now();
  final _calorieIntakeController = new TextEditingController();
  AnimationController rotationController;

  @override
  void initState() {
    rotationController = AnimationController(duration: const Duration(milliseconds: 10000),vsync: this);
    super.initState();
  }

  void sendData() async {
    setState(() {
      widget.loading = true;

    });
    String calorieIntake = _calorieIntakeController.text;
    String mealCategory = _intakeMealCategory;
    Map data = {"calorieIntake": calorieIntake, "mealCategory": mealCategory, "userId":widget.serverResponse.userId};
    await http
        .post(
            "https://us-central1-firestoredemo-bd9a8.cloudfunctions.net/setCalorieIntake",
            headers: {
              'Content-type': 'application/x-www-form-urlencoded',
              'Accept': 'application/json'
            },
            body: data)
        .then((response) {
          rotationController.reset();
          setState(() {
            widget.loading = false;
          });
      Post serverResponse = Post.fromJson(json.decode(response.body));
      print(serverResponse.status);
      if (serverResponse.status == 200) {
        setState(() {
            Navigator.pushReplacement(context, new MaterialPageRoute(
                builder: (BuildContext context) =>
                  TabScreen(serverResponse: widget.serverResponse)
            ));
          });
      } else {
        showDialog(
            context: context,
            child: new AlertDialog(
              title: new Text("Update calorie count.."),
              content: new Text("Errorr"),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final showDate = new Center(
        child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: <Widget>[
          new Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(3.0),
              child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Date: ' + dateCurrent.toString(),
                      style: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ]))
        ]));
    final calorieInput = new Theme(
        data: new ThemeData(
          primaryColor: Colors.blue,
          primaryColorDark: Colors.white,
          hintColor: Colors.white,
        ),
        child: TextFormField(
          style: new TextStyle(color: Colors.white),
          controller: _calorieIntakeController,
          keyboardType: TextInputType.number,
          autofocus: false,
          decoration: InputDecoration(
              hintText: "Enter calories intake",
              contentPadding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0))),
        ));
    final intakeTimeCategory = Opacity(
        opacity: widget.loading == true ? 0.2 : 1,
        child: new Center(
          child: DropdownButton(
            hint: Text(
              'Meal Type',
              style: TextStyle(color: Colors.black),
            ), // Not necessary for Option 1
            value: _intakeMealCategory,
            onChanged: (newValue) {
              setState(() {
                _intakeMealCategory = newValue;
              });
            },
            items: [
              'Breakfast',
              'Lunch',
              'Dinner',
              'Morning snack',
              'Afternoon snack',
              'Evening snack'
            ].map((items) {
              return DropdownMenuItem(
                child: new Text(
                  items,
                  style: TextStyle(color: Colors.black),
                ),
                value: items,
              );
            }).toList(),
          ),
        ));
    final submitCalories = Opacity(
        opacity: widget.loading == true ? 0.2 : 1,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Material(
              borderRadius: BorderRadius.circular(20.0),
              shadowColor: Colors.black87,
              elevation: 5.0,
              color: Colors.cyan,
              child: MaterialButton(
                onPressed: () {
                  rotationController.forward();
                  sendData();
                },
                child: Text(
                  "Done",
                  style: TextStyle(color: Colors.black),
                ),
              )),
        ));
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
          backgroundColor: Colors.white70,
          elevation: 3.0,
        ),
        body: new Stack(children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              color: Colors.teal,
            ),
          ),
          new Center(
              child: AbsorbPointer(
                  absorbing: widget.loading,
                  child: new Form(
                      key: _formKey,
                      child: ListView(
                        padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                        shrinkWrap: true,
                        children: <Widget>[
                          showDate,
                          SizedBox(
                            height: 30,
                          ),
                          calorieInput,
                          SizedBox(
                            height: 30,
                          ),
                          intakeTimeCategory,
                          SizedBox(
                            height: 30,
                          ),
                          submitCalories
                        ],
                      )))),
          new Column(
              children: widget.loading == true
                  ? <Widget>[
                      Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Center(
                                  child: SizedBox(
                                child: RefreshProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.red),
                                ),
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
