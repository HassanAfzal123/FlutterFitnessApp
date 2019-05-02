import 'dart:async';
import 'dart:ui';

import 'DailyCaloriesIntake.dart';

import 'ServerResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pedometer/flutter_pedometer.dart';
import 'package:pedometer/pedometer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'exercisesCategory.dart';

class Days {
  final int status;
  List message;
  Days({this.message, this.status});
  factory Days.fromJson(Map<String, dynamic> json) {
    return Days(
        status: json['status'],
        message: json['message']);
  }
}

class daysSelection extends StatefulWidget {
  bool loading = false;
  final Post serverResponse;
  final String exerciseCategory;


  daysSelection({Key key, @required this.serverResponse,this.exerciseCategory}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _daysSelectionState();
  }
}

class _daysSelectionState extends State<daysSelection> with TickerProviderStateMixin {

  List _days;
  void getData() async {
    setState(() {
      widget.loading = true;
    });
    Map data = {'userId': widget.serverResponse.userId, 'documentId': widget.exerciseCategory};
    await http
        .post(
        "https://us-central1-firestoredemo-bd9a8.cloudfunctions.net/getExerciseDays",
        headers: {
          'Content-type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json'
        },
        body: data)
        .then((response) {
      Days daysData = Days.fromJson(json.decode(response.body));
      if (daysData.status == 200) {
        setState(() {
          widget.loading = false;
          _days = daysData.message;
        });
      }
      else{
        showDialog(
            context: context,
            child: new AlertDialog(
              title: new Text("Server error"),
              content: new Text(daysData.status.toString()),
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
          children: widget.loading == true ? <Widget>[CircularRefreshPointer]:

          <Widget>[new Expanded(
            child: ListView.builder(
                shrinkWrap: true,
            physics: ClampingScrollPhysics(),
                itemCount: _days== null ? 0: _days.length,
                itemBuilder: (BuildContext context,int index){
                  return new Hero(
                    tag: _days[index],
                    child: new GestureDetector(
                      onTap: (){
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                exercisesCategory(serverResponse: widget.serverResponse,day: _days[index],exerciseCategory: widget.exerciseCategory)
                        ));
                      },
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Center(
                              child:Padding(
                                padding: EdgeInsets.all(20),
                                child: Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(leading: Icon(Icons.fitness_center,size: 30,color: Colors.blue,)),
                                      Text(
                                        _days[index],
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.black,
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
                        ),),),);
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