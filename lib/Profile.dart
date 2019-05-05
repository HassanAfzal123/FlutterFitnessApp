import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tts/tts.dart';
import 'ServerResponse.dart';
import 'package:http/http.dart' as http;



class Profile extends StatefulWidget {
  bool loading = false;
  final Post serverResponse;


  Profile({Key key, @required this.serverResponse}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProfileState();
  }

}

class _ProfileState extends State<Profile> with TickerProviderStateMixin{

  String _name='';
  String _height='';
  String _weight='';
  String _age='';
  int _BMI= 0;
  String _userHealthStatus = '';
  final _EditWeightController = new TextEditingController();
  final _EditHeightController = new TextEditingController();
  final _EditAgeController = new TextEditingController();
  bool healthLoading = false;

  List<Color> _backgroundColor;
  Color _iconColor;
  Color _textColor;
  List<Color> _actionContainerColor;
  Color _borderContainer;
  bool colorSwitched = true;

  @override
  void initState() {
    print('hitting');
    // TODO: implement initState
        getData();
        changeTheme();
  }

  void dispose(){

    super.dispose();
  }

  void changeTheme() async {
    if (colorSwitched) {
      setState(() {
        _backgroundColor = [
          Color(0xDD000000),
          Color(0xDD000000),
          Color(0xDD000000),Color(0xDD000000)
        ];
        _iconColor = Colors.white;
        _textColor = Color.fromRGBO(253, 211, 4, 1);
        _borderContainer = Color.fromRGBO(34, 58, 90, 0.2);
        _actionContainerColor = [
          Color.fromRGBO(47, 75, 110, 1),
          Color.fromRGBO(43, 71, 105, 1),
          Color.fromRGBO(39, 64, 97, 1),
          Color.fromRGBO(34, 58, 90, 1),
        ];
      });
    } else {
      setState(() {
        _borderContainer = Color.fromRGBO(252, 233, 187, 1);
        _backgroundColor = [
          Color.fromRGBO(249, 249, 249, 1),
          Color.fromRGBO(241, 241, 241, 1),
          Color.fromRGBO(233, 233, 233, 1),
          Color.fromRGBO(222, 222, 222, 1),
        ];
        _iconColor = Colors.black;
        _textColor = Colors.black;
        _actionContainerColor = [
          Color.fromRGBO(255, 212, 61, 1),
          Color.fromRGBO(255, 212, 55, 1),
          Color.fromRGBO(255, 211, 48, 1),
          Color.fromRGBO(255, 211, 43, 1),
        ];
      });
    }
  }

  speak() async {
    Tts.speak(_name+', this is your profile with some of your information.');
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
      setState(() {
      userProfileData userData = userProfileData.fromJson(json.decode(response.body));

        widget.loading = false;
        _name = userData.name;
        _age = userData.age;
        _height = userData.height;
        _weight = userData.weight;
        _BMI = int.parse(_weight) ~/ ((int.parse(_height)*0.0254) * (int.parse(_height)*0.0254));

      });

    })
        .catchError((onError){
          print('Error here');
    });
  }


  void UpdateUserData()  {
    setState(() {
      widget.loading = true;
    });
    String newWeight;
    String newHeight;
    String newAge;
    if(_EditWeightController.text == ''){
      newWeight = _weight;
    }
    else{
      newWeight = _EditWeightController.text;
    }
    if(_EditHeightController.text==''){
      newHeight = _height;
    }
    else{
      newHeight = _EditHeightController.text;
    }
    if(_EditAgeController.text == ''){
      newAge = _age;
    }
    else{
      newAge = _EditAgeController.text;
    }
    Map data = {"userId": widget.serverResponse.userId,"weight": newWeight, "height": newHeight, "age": newAge};
     http
        .post(
        "https://us-central1-firestoredemo-bd9a8.cloudfunctions.net/UpdateUserData",
        headers: {
          'Content-type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json'
        },
        body: data)
        .then((response) {
          setState(() {
            widget.loading = true;
          });
          getData();
    });
  }

  void getUserStatus() async {
    setState(() {
      healthLoading = true;
    });
    Map data = {'userId': widget.serverResponse.userId};
    await http.post(
        "https://us-central1-firestoredemo-bd9a8.cloudfunctions.net/model",
        headers: {
          'Content-type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json'
        },
        body: data)
        .then((response){
      setState(() {
        userStatusData userStatus = userStatusData.fromJson(json.decode(response.body));
        widget.loading = false;
        healthLoading = false;
        _userHealthStatus = userStatus.userStatus;
        showDialog(
            context: context,
            child: new AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0)),),
              title: new Text("Health Status"),
              content: new Text('Given your Height, Weight and Gender, our Artificial Intelligence predicted that your health status is: "'+_userHealthStatus+'"'),
            ));
          Tts.speak('Given your Height, Weight and Gender, our Artificial Intelligence predicted that your health status is: "'+_userHealthStatus+'"');


      });

    })
        .catchError((onError){
      print('Error here');
    });
  }

  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(
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
          backgroundColor: Colors.black87,
          elevation: 3.0,
        ),
        body: widget.loading == true ? Column(children:<Widget>[CircularRefreshPointer]) :

        GestureDetector(
          onLongPress: () {
            if (colorSwitched) {
              colorSwitched = false;
            } else {
              colorSwitched = true;
            }
            changeTheme();
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [0.2, 0.3, 0.5, 0.8],
                    colors: _backgroundColor)),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Image.asset(
                  'assets/bodygarage_logo.png',
                  fit: BoxFit.contain,
                  height: 150.0,
                  width: 150.0,
                ),
                Container(
                  height: 300.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: _borderContainer,
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
                              alignment: Alignment.topRight,
                              child:  healthLoading == true ? SizedBox(child: RefreshProgressIndicator( valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.red),),height: 40,width: 40,)
                              :
                              IconButton(icon: Icon(Icons.info),color: Colors.white, onPressed: getUserStatus,)
                          ),
                          Container(
                            height: 70,
                            child: Center(
                              child: ListView(
                                children: <Widget>[
                                  Text(
                                    'Hello,',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    _name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: _iconColor, fontSize: 30,fontWeight: FontWeight.bold),
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
                                GestureDetector(
                                  onTap: (){
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Edit Weight(in Kg)'),
                                            content: TextField(
                                              inputFormatters: <TextInputFormatter>[
                                                WhitelistingTextInputFormatter.digitsOnly
                                              ],
                                              keyboardType: TextInputType.number,
                                              controller: _EditWeightController,
                                              decoration: InputDecoration(hintText: _weight),
                                            ),
                                            actions: <Widget>[
                                              new FlatButton(
                                                child: new Text('Cancel'),
                                                onPressed: () {
                                                  _EditWeightController.text = '';
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              new FlatButton(
                                                child: new Text('Submit'),
                                                onPressed: () {
                                                  UpdateUserData();
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  }
                                ,child: _actionList(
                                    'assets/profile_weight.png', 'Weight: '+_weight+'kg')
                                ),
                                GestureDetector(
                                    onTap: (){
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('Edit Height(in Inches)'),
                                              content: TextField(
                                                inputFormatters: <TextInputFormatter>[
                                                  WhitelistingTextInputFormatter.digitsOnly
                                                ],
                                                keyboardType: TextInputType.number,
                                                controller: _EditHeightController,
                                                decoration: InputDecoration(hintText: _height),
                                              ),
                                              actions: <Widget>[
                                                new FlatButton(
                                                  child: new Text('Cancel'),
                                                  onPressed: () {
                                                    _EditHeightController.text = '';
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                new FlatButton(
                                                  child: new Text('Submit'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    UpdateUserData();
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                    }
                                    ,child:  _actionList(
                                    'assets/profile_height.png', 'Height: '+_height+' inches'),
                                ),

                              ]),
                              TableRow(children: [
                                GestureDetector(
                                    onTap: (){
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('Edit Age'),
                                              content: TextField(
                                                inputFormatters: <TextInputFormatter>[
                                                  WhitelistingTextInputFormatter.digitsOnly
                                                ],
                                                keyboardType: TextInputType.number,
                                                controller: _EditAgeController,
                                                decoration: InputDecoration(hintText: _age),
                                              ),
                                              actions: <Widget>[
                                                new FlatButton(
                                                  child: new Text('Cancel'),
                                                  onPressed: () {
                                                    _EditAgeController.text = '';
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                new FlatButton(
                                                  child: new Text('Submit'),
                                                  onPressed: () {
                                                    UpdateUserData();
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                    }
                                    ,child:  _actionList('assets/profile_age.png', 'Age: '+_age)
                                ),
                                _actionList('assets/profile_bmi.png', 'BMI: '+_BMI.toString()),
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

    )
    );
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
            color: _iconColor,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            desc,
            style: TextStyle(color: _iconColor),
          )
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

class userStatusData {
  final String userStatus;
  userStatusData({this.userStatus});

  factory userStatusData.fromJson(Map<String, dynamic> json) {
    return userStatusData(userStatus: json['message']);
  }
}



