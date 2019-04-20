import 'dart:convert';

import 'package:flutter/material.dart';
import 'ServerResponse.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  bool loading = false;
  final Post serverResponse;
  String name='';
  String height='';
  String weight='';
  String age='';

  Profile({Key key, @required this.serverResponse}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProfileState();
  }

}

class _ProfileState extends State<Profile> with TickerProviderStateMixin{


  @override
  void initState() {
    // TODO: implement initState
    if(widget.name=='') {
      getData();
    }
  }

  void getData() async {
    setState(() {
      widget.loading=true;
    });
    Map data = {'userId': widget.serverResponse.userId};
    await http.post(
        "https://us-central1-firestoredemo-bd9a8.cloudfunctions.net/getUserData",
        headers: {
          'Content-type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json'
        },
        body: data)
        .then((response){
      userProfileData userData = userProfileData.fromJson(json.decode(response.body));
      setState(() {
        widget.loading = false;
        widget.name = userData.name;
        widget.age = userData.age;
        widget.height = userData.height;
        widget.weight = userData.weight;
      });

    })
        .catchError((onError){
          print('Error here');
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final showName =new Center(
        child: ListView(
          shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          new Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(3.0),
        decoration: new BoxDecoration(
            border: new Border.all(color: Colors.black),
            color: Colors.white,

            boxShadow: [BoxShadow(color: Colors.black,blurRadius:5.0, ),]
        ),
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Name: '+widget.name,
                style: TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600
                ),
              ),
              SizedBox(height: 20,)
            ]

        )
        )
        ]
        )
    );


    final showAge =new Center(
        child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              new Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration: new BoxDecoration(
                      border: new Border.all(color: Colors.black),
                      color: Colors.white,

                      boxShadow: [BoxShadow(color: Colors.black,blurRadius:5.0, ),]
                  ),
                  child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Age: '+widget.age,
                          style: TextStyle(
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        SizedBox(height: 20,)
                      ]

                  )
              )
            ]
        )
    );


    final showWeight =new Center(
        child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              new Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration: new BoxDecoration(
                      border: new Border.all(color: Colors.black),
                      color: Colors.white,

                      boxShadow: [BoxShadow(color: Colors.black,blurRadius:5.0, ),]
                  ),
                  child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Weight(in Kgs): '+widget.weight,
                          style: TextStyle(
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        SizedBox(height: 20,)
                      ]

                  )
              )
            ]
        )
    );

    final showHeight =new Center(
        child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              new Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration: new BoxDecoration(
                      border: new Border.all(color: Colors.black),
                      color: Colors.white,

                      boxShadow: [BoxShadow(color: Colors.black,blurRadius:5.0, ),]
                  ),
                  child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Height(in inches): '+widget.height,
                          style: TextStyle(
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        SizedBox(height: 20,)
                      ]

                  )
              )
            ]
        )
    );
    return new Column(
        children: widget.loading == true ?
        <Widget> [
          Expanded(
              flex: 1,
              child: Column(

                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[Center(
                    child: SizedBox(
                      child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),),width: 140,height: 140,)
                ),SizedBox(height: 20,),Center(
                  child: Text(''),
                )
                ],
              )
          )
        ]:
        <Widget>[SizedBox(height: 40,),showName,SizedBox(height: 20,),showAge,SizedBox(height: 20,),showWeight,SizedBox(height: 20,),showHeight]
    );

  }
}

class userProfileData {
  final String name;
  final String age;
  final String height;
  final String weight;
  userProfileData({this.name,this.height,this.weight,this.age});

  factory userProfileData.fromJson(Map<String, dynamic> json) {
    return userProfileData(name: json['message']['name'],age: json['message']['age'],height: json['message']['height'],weight: json['message']['weight']);
  }
}




