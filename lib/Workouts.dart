import 'dart:async';
import 'dart:ui';

import 'DailyCaloriesIntake.dart';

import 'ServerResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pedometer/flutter_pedometer.dart';
import 'package:pedometer/pedometer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fitness_app_flutter/DaysSelection.dart';
import 'package:tts/tts.dart';

class WorkOutCategory {
  final int status;
  List message;
  WorkOutCategory({this.status, this.message});
  factory WorkOutCategory.fromJson(Map<String, dynamic> json) {
    return WorkOutCategory(
        status: json['status'],
        message: json['message']);
  }
}

class Workout extends StatefulWidget {
  bool loading = false;
  final Post serverResponse;

  Workout({Key key, @required this.serverResponse}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _WorkoutState();
  }
}



class _WorkoutState extends State<Workout> with TickerProviderStateMixin {

  List ColorsList= [Color(0xAA33691E),Color(0xFF01579B),Color(0xAABB2C00)];
  List _categories;
  var details;

  speak() async {
    Tts.speak('Hello there !! I am your helper. If you are confused about anything, just hit the information button on the top right corner.');
  }


  void getData() async {
    setState(() {
      widget.loading = true;
    });
    Map data = {'userId': widget.serverResponse.userId};
    await http
        .post(
        "https://us-central1-firestoredemo-bd9a8.cloudfunctions.net/getExercisesCategory",
        headers: {
          'Content-type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json'
        },
        body: data)
        .then((response) {
          widget.loading = false;
      WorkOutCategory categories = WorkOutCategory.fromJson(
          json.decode(response.body));
      print(categories.message);
      if (categories.status == 200) {
        setState(() {
            _categories = categories.message;
        });
      }
      else {
        showDialog(
            context: context,
            child: new AlertDialog(
              title: new Text("Server error"),
              content: new Text('Error'),
            ));
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  void initState() {
    //TODO: implement initState
    getData();
  }

  Widget build(BuildContext context) {


    return new Scaffold(
      appBar: AppBar(
          actions: <Widget>[
      IconButton(
      icon: Icon(Icons.info),
      color: Colors.blue,
      tooltip: 'hint',
      onPressed: speak,
    ),],
        title: Center(
          child: Text(
            'The Aesthetic Club',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Courier New',
                fontWeight: FontWeight.w900),
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 3.0,
      ),
      backgroundColor: Colors.black87,
      body: new Column(
    children: widget.loading == true ? <Widget>[CircularRefreshPointer]:

    <Widget>[new Expanded(
      child: ListView.builder(
        shrinkWrap: true,
          itemCount: _categories == null ? 0: _categories.length,
          itemBuilder: (BuildContext context,int index){
            return new Hero(
              tag: _categories[index],
             child: new GestureDetector(
                  onTap: (){
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            daysSelection(serverResponse: widget.serverResponse,exerciseCategory: _categories[index])
                    ));
                  },
                  onDoubleTap: () {
                    setState(() {
                      details = _categories[index] == 'Advance' ? Text('Recommended only if you have completed Beginners and Intermediate levels'): _categories[index] == 'Beginners' ? Text('If you are new to workouts, you are recommended to go through this level') : _categories[index]=='Intermediate'?Text('Recommended only if you have completed Beginners level'):Text('error');
                    });
              showDialog(
                  context: context,
                  child: new AlertDialog(
                    title: new Text(_categories[index]+' Level'),
                    content: details,
                  ));
                  },
                child: Center(
                child: Column(
              children: <Widget>[
             Center(
            child:Padding(
            padding: EdgeInsets.all(20),
            child: Card(
              color: Colors.transparent,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
            ListTile(leading: Icon(Icons.fitness_center,size: 50,color: Colors.amber,)),
            Text(
            _categories[index]+' Level',
            style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 60,)
            ],
            ),
            ),
            ),
            ),

              ],
            ),),),);
          }

      ),
      ),
    Center(child: Text('Confused? Double tap on level for details !',style: TextStyle(color: Colors.white),))
    ],
      )
    );
  }
}


final CircularRefreshPointer =  Expanded(
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
    ));