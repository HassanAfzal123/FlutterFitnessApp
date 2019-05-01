import 'dart:async';
import 'dart:ui';

import 'DailyCaloriesIntake.dart';

import 'ServerResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pedometer/flutter_pedometer.dart';
import 'package:pedometer/pedometer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ExerciseDetails {
  final int status;
  final String link;
  final String name;
  final String reps;
  final String sets;
  ExerciseDetails({this.name, this.sets,this.reps,this.status,this.link});
  factory ExerciseDetails.fromJson(Map<String, dynamic> json) {
    return ExerciseDetails(
        status: json['status'],
        link: json['message']['link'],
        name: json['message']['exercise'],
        reps: json['message']['reps'],
        sets: json['message']['sets']);
  }
}

class exercisePage extends StatefulWidget {
  bool loading = false;
  final Post serverResponse;
  final String day;
  final String exerciseCategory;
  final String exerciseName;



  exercisePage({Key key, @required this.serverResponse,this.day,this.exerciseCategory,this.exerciseName}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _exercisePageState();
  }
}

class _exercisePageState extends State<exercisePage> with TickerProviderStateMixin {

  String _exerciseName;
  String _reps;
  String _sets;
  String _link;
  void getData() async {
    setState(() {
      widget.loading = true;
    });
    Map data = {'userId': widget.serverResponse.userId, 'documentId': widget.exerciseCategory,'dayId': widget.day,'exerciseName': widget.exerciseName};
    print(widget.day);
    print(widget.exerciseCategory);
    await http
        .post(
        "https://us-central1-firestoredemo-bd9a8.cloudfunctions.net/getExerciseData",
        headers: {
          'Content-type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json'
        },
        body: data)
        .then((response) {
      ExerciseDetails getExercises = ExerciseDetails.fromJson(json.decode(response.body));
      if (getExercises.status == 200) {
        print(getExercises.name);
        setState(() {
          widget.loading = false;
          _exerciseName = getExercises.name;
          _reps = getExercises.reps;
          _sets = getExercises.sets;
          _link = YoutubePlayer.convertUrlToId(getExercises.link);
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
            child:new Column(
              children: <Widget>[
                  Text('Exercise Name: '+ _exerciseName,style: TextStyle(color: Colors.white70),),

                  Text('Number of sets: '+ _sets,style: TextStyle(color: Colors.white70),),

                  Text('Number of reps: '+_reps,style: TextStyle(color: Colors.white70),),

                  YoutubePlayer(
                    context: context,
                    videoId: _link,
                    autoPlay: false,
                    showVideoProgressIndicator: true,
                    videoProgressIndicatorColor: Colors.white,
                    progressColors: ProgressColors(
                      playedColor: Colors.amber,
                      handleColor: Colors.amberAccent,
                    ),
                  )
              ],
            )

          ),
          ],
        ),

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