import 'dart:async';
import 'dart:ui';

import 'ServerResponse.dart';
import 'package:flutter/material.dart';
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

  String _exerciseName='';
  String _reps='';
  String _sets='';
  String _link='';
  List<Color> _actionContainerColor = [
    Color.fromRGBO(47, 75, 110, 1),
    Color.fromRGBO(43, 71, 105, 1),
    Color.fromRGBO(39, 64, 97, 1),
    Color.fromRGBO(34, 58, 90, 1),
  ];



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
          _link = getExercises.link;
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
          backgroundColor: Colors.black87,
          elevation: 3.0,
        ),
        backgroundColor: Colors.black87,
        body: widget.loading == true ? Column(children:<Widget>[CircularRefreshPointer]) :

        GestureDetector(
          onLongPress: () {
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.black87),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
            YoutubePlayer(
              context: context,
              videoId: YoutubePlayer.convertUrlToId(_link),
              autoPlay: false,
              showVideoProgressIndicator: true,
              videoProgressIndicatorColor: Colors.white,
              progressColors: ProgressColors(
                playedColor: Colors.amber,
                handleColor: Colors.amberAccent,
              ),
            ),
                Container(
                  height: 300.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15)),
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              stops: [0.2, 0.4, 0.6, 0.8],
                              colors: _actionContainerColor)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 120,
                            child: Center(
                              child: ListView(
                                children: <Widget>[
                                  Text(
                                    'Exercise Name',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    _exerciseName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 30,fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            height: 0.5,
                            color: Colors.grey,
                          ),
                          Table(
                            border: TableBorder.symmetric(
                              inside: BorderSide(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 0.5),
                            ),
                            children: [
                              TableRow(children: [
                                _actionList(
                                    'assets/sets.png', 'Sets: '+_sets),
                                _actionList(
                                    'assets/reps.png', 'Reps: '+_reps),
                              ]),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
    );
  }
}

Widget _actionList(var icon, String desc) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
            icon,
            fit: BoxFit.contain,
            height: 45.0,
            width: 45.0,
            color: Colors.white
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          desc,
          style: TextStyle(color: Colors.white),
        )
      ],
    ),
  );
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

