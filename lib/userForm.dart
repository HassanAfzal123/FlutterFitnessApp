import 'dart:ui';

import 'package:fitness_app_flutter/TabScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ServerResponse.dart';

class storeData {
  final int status;
  final String message;
  storeData({this.status, this.message});

  factory storeData.fromJson(Map<String, dynamic> json) {
    return storeData(status: json['status'], message: json['message']);
  }
}

class userForm extends StatefulWidget {
  bool loading = false;
  final Post serverResponse;
  userForm({Key key, @required this.serverResponse}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _userFormState();
  }
}

class _userFormState extends State<userForm> with TickerProviderStateMixin{
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _nameController = new TextEditingController();
  final _ageController = new TextEditingController();
  final _heightController = new TextEditingController();
  final _weightController = new TextEditingController();
  String _gender;

  String numberValidator(String value) {
    if(value == null) {
      return null;
    }
    final n = num.tryParse(value);
    if(n == null) {
      return '"$value" is not a valid number';
    }
    return null;
  }

  void sendData() async {
    setState(() {
      widget.loading = true;
    });
    String name = _nameController.text;
    String age = _ageController.text;
    String weight = _weightController.text;
    String height = _heightController.text;
    print(_gender);
    Map data = {"name": name, "age": age, "height": height,"weight": weight,"gender": _gender,"userId": widget.serverResponse.userId};
    print(data);
    await http
        .post(
        "https://us-central1-firestoredemo-bd9a8.cloudfunctions.net/postUserData",
        headers: {
          'Content-type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json'
        },
        body: data)
        .then((response) {
          widget.loading=false;
       storeData  getResponse = storeData.fromJson(json.decode(response.body));
      if (getResponse.status == 200) {
        setState(() {
          Navigator.pushReplacement(context, new MaterialPageRoute(
              builder: (BuildContext context) => TabScreen(serverResponse: widget.serverResponse)
          ));
        });
      } else {
        showDialog(
            context: context,
            child: new AlertDialog(
              title: new Text("Infomation Error"),
              content: new Text("Error"),
            ));

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final logo_img = new CircleAvatar(
        radius: 80.0,
        backgroundColor: Colors.black,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: new DecorationImage(
              image: new AssetImage("assets/splashscreen.png"),
            ),
          ),
        ),
      );

    final name = Opacity(
        opacity: widget.loading==true ? 0.2 : 1,
        child:new Theme(
            data: new ThemeData(
              primaryColor: Colors.blue,
              primaryColorDark: Colors.white,
              hintColor: Colors.white,
            ),
            child: TextFormField(
              style: new TextStyle(color: Colors.white),
              controller: _nameController,
              keyboardType: TextInputType.text,
              autofocus: false,
              decoration: InputDecoration(
                  hintText: "Enter Name",
                  contentPadding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0))),
            )));

    final age = Opacity(
        opacity: widget.loading==true ? 0.2 : 1,
        child:new Theme(
            data: new ThemeData(
              primaryColor: Colors.blue,
              primaryColorDark: Colors.white,
              hintColor: Colors.white,
            ),
            child: TextFormField(
              style: new TextStyle(color: Colors.white),
              controller: _ageController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
              autofocus: false,
              decoration: InputDecoration(
                  hintText: "Enter Age",
                  contentPadding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0))),
            )));

    final weight = Opacity(
        opacity: widget.loading==true ? 0.2 : 1,
        child:new Theme(
            data: new ThemeData(
              primaryColor: Colors.blue,
              primaryColorDark: Colors.white,
              hintColor: Colors.white,
            ),
            child: TextFormField(
              style: new TextStyle(color: Colors.white),
              controller: _weightController,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
              keyboardType: TextInputType.number,
              autofocus: false,
              decoration: InputDecoration(
                  hintText: "Weight in Kgs",
                  contentPadding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0))),
            )));

    final height = Opacity(
        opacity: widget.loading==true ? 0.2 : 1,
        child:new Theme(
            data: new ThemeData(
              primaryColor: Colors.blue,
              primaryColorDark: Colors.white,
              hintColor: Colors.white,
            ),
            child: TextFormField(
              style: new TextStyle(color: Colors.white),
              controller: _heightController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
              autofocus: false,
              decoration: InputDecoration(
                  hintText: "Height in Inches",
                  contentPadding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0))),
            )));

    final gender = Opacity(
        opacity: widget.loading==true ? 0.2 : 1,
        child:  new Center(
          child: DropdownButton(
              hint: Text('Gender',
              style: TextStyle(
                color: Colors.white
              ),
              ), // Not necessary for Option 1
              value: _gender,
              onChanged: (newValue) {
                setState(() {
                  _gender = newValue;
                });
              },
              items: ['Male','Female'].map((location) {
                return DropdownMenuItem(
                  child: new Text(location,
                    style: TextStyle(
                      color: Colors.blue
                    ),
                  ),
                  value: location,
                );
              }).toList(),
            ),
        ));
    final saveDataButton = Opacity(
        opacity: widget.loading==true ? 0.2 : 1,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Material(
              borderRadius: BorderRadius.circular(20.0),
              shadowColor: Colors.black87,
              elevation: 5.0,
              color: Colors.cyan,
              child: MaterialButton(
                onPressed: ()
                {
                  sendData();
                },
                child: Text(
                  "Save Data",
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
          backgroundColor: Colors.black,
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
                      child:new Container(
                          child:ListView(
                            padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                            shrinkWrap: true,
                            children: <Widget>[
                              name,
                              SizedBox(
                                height: 30,
                              ),
                              age,
                              SizedBox(
                                height: 30,
                              ),
                              weight,
                              SizedBox(
                                height: 30,
                              ),
                              height,
                              SizedBox(
                                height: 30,
                              ),
                              gender,
                              SizedBox(
                                height: 30,
                              ),
                              saveDataButton,
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          )
                      )
                  )

              )
          ),
          new Column(
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
              <Widget>[]
          )
        ]));
  }
}
