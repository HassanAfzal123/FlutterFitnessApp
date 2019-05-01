import 'dart:async';
import 'dart:ui';

import 'DailyCaloriesIntake.dart';

import 'ServerResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pedometer/flutter_pedometer.dart';
import 'package:pedometer/pedometer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fitness_app_flutter/ExercisePage.dart';

class Exercises {
  final int status;
  List message;
  Exercises({this.message, this.status});
  factory Exercises.fromJson(Map<String, dynamic> json) {
    return Exercises(
        status: json['status'],
        message: json['message']);
  }
}

class exercisesCategory extends StatefulWidget {
  bool loading = false;
  final Post serverResponse;
  final String day;
  final String exerciseCategory;


  exercisesCategory({Key key, @required this.serverResponse,this.day,this.exerciseCategory}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _exercisesCategoryState();
  }
}

class _exercisesCategoryState extends State<exercisesCategory> with TickerProviderStateMixin {

  List _exercises;
  void getData() async {
    setState(() {
      widget.loading = true;
    });
    Map data = {'userId': widget.serverResponse.userId, 'documentId': widget.exerciseCategory,'dayId': widget.day};
    print(widget.day);
    print(widget.exerciseCategory);
    await http
        .post(
        "https://us-central1-firestoredemo-bd9a8.cloudfunctions.net/getDaysData",
        headers: {
          'Content-type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json'
        },
        body: data)
        .then((response) {
      Exercises getExercises = Exercises.fromJson(json.decode(response.body));
      if (getExercises.status == 200) {
        setState(() {
          widget.loading = false;
          _exercises = getExercises.message;
          print(getExercises.message);
        });
      }
      else{
        showDialog(
            context: context,
            child: new AlertDialog(
              title: new Text("Server error"),
              content: new Text(getExercises.status.toString()),
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

  @override
  void dispose(){
    super.dispose();
  }

  Widget build(BuildContext context) {


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
          backgroundColor: Colors.black,
          elevation: 3.0,
        ),
        backgroundColor: Colors.black,
        body: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          verticalDirection: VerticalDirection.down,
          children: widget.loading == true ? <Widget>[CircularRefreshPointer]:

          <Widget>[new Expanded(
            child:
            ListView.builder(
             physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: _exercises== null ? 0: _exercises.length,
                itemBuilder: (BuildContext context,int index){
                  return new Hero(
                    tag: _exercises[index],
                    child: new GestureDetector(
                      onTap: (){
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                exercisePage(serverResponse: widget.serverResponse,day: widget.day,exerciseCategory: widget.exerciseCategory,exerciseName: _exercises[index],)
                        ));
                      },
                        child: Column(

                          children: <Widget>[
                            Center(
                              child:Padding(
                                padding: EdgeInsets.all(20),
                                child: Card(
                                  color: Colors.brown,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(leading: Icon(Icons.fitness_center,size: 50,color: Colors.amber,)),
                                      Text(
                                        _exercises[index],
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.white,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(height: 40,)
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),),);
                }

            ),
            ),
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