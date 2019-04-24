import 'dart:async';
import 'dart:ui';

import 'DailyCaloriesIntake.dart';

import 'ServerResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pedometer/flutter_pedometer.dart';
import 'package:pedometer/pedometer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TotalCalories {
  final int status;
  final int totalCalorieIntake;
  final int totalStepsCount;
  final String message;
  TotalCalories({this.message, this.status, this.totalCalorieIntake, this.totalStepsCount});
  factory TotalCalories.fromJson(Map<String, dynamic> json) {
    return TotalCalories(
        status: json['status'],
        message: json['message'],
        totalCalorieIntake: json['totalCalorieIntake'],
        totalStepsCount: json['totalStepsCount']);
  }
}

class Home extends StatefulWidget {
  bool loading = false;
  final Post serverResponse;


  Home({Key key, @required this.serverResponse}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  int _totalCalorieIntake = 0;
  int oldStepsCount;
  StreamSubscription<int> _subscription;
  int _stepCountValue = 0;
  int _tempforPedometer = 0;
  int _tempCount = 0;
  Pedometer pedometer = new Pedometer();


  @override
  void setUpPedometer() {

    _subscription = pedometer.stepCountStream.listen(_onData,
        onError: _onError, onDone: _onDone,cancelOnError: true);
  }
  void _onData(int stepCountValue) {
    _tempCount = _tempCount + 1;
    print('old $oldStepsCount');
    if(_tempCount == 1){
        _tempforPedometer = stepCountValue;                         //_tempforPedometer is the first time value that is being returned by the Pedometer
    }
    setState(() {
      _stepCountValue = oldStepsCount+stepCountValue-_tempforPedometer;
      print(_stepCountValue);                                         // Count by user.
    });

  }
  void _onDone() => print('Pedometer Finished');

  void _onError(error) => print("Flutter Pedometer Error: $error");

  void _onCancel() => _subscription.cancel();

  void Pedometerreset(){          //T0 cancel the Pedometer subscription
    _subscription.cancel();
    _subscription = null;
  }
  void sendData() {
    int stepsCount = _stepCountValue;
    Map data = {
      "stepsCount": stepsCount.toString(),
      "userId": widget.serverResponse.userId
    };
    http
        .post(
        "http://localhost:5000/firestoredemo-bd9a8/us-central1/setStepsCount",
        headers: {
          'Content-type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json'
        },
        body: data)
        .then((response) {
          print('StepsCount Sent!');
    });
  }

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
      TotalCalories userData = TotalCalories.fromJson(json.decode(response.body));
      if (userData.status == 200) {
        setState(() {
          widget.loading = false;
          _totalCalorieIntake = userData.totalCalorieIntake;
          oldStepsCount = userData.totalStepsCount;
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
      setUpPedometer();
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
    Pedometerreset();
    sendData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final calorieIntakeCard = Center(
      child:Padding(
        padding: EdgeInsets.all(20),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(leading: Icon(Icons.local_dining), title: Text('Food')),
            Text(
              'Total Calories: ' + _totalCalorieIntake.toString(),
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
            ,
          ],
        ),
      ),
      ),
    );

    final StepsCard = Center(
      child:Padding(
        padding: EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(leading: Icon(Icons.directions_walk), title: Text('Walk')),
              Text(
                'Steps: ' + _stepCountValue.toString(),//_totalCalorieIntake.toString(),
                style: TextStyle(
                    fontSize: 25,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 30,)
            ],
          ),
        ),
      ),
    );


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
        backgroundColor: Colors.black87,
        body:Column(
              children: widget.loading == true
                  ? <Widget>[CircularRefreshPointer]
                  : <Widget>[calorieIntakeCard,StepsCard])
        );
  }
}
