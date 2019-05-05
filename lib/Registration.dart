import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Registration extends StatefulWidget {
  @override
  bool loading = false;
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RegistrationPageState();
  }
}

class serverData {
  final int status;
  final String message;
  serverData({this.status, this.message});

  factory serverData.fromJson(Map<String, dynamic> json) {
    return serverData(status: json['status'], message: json['message']);
  }
}

class _RegistrationPageState extends State<Registration> with TickerProviderStateMixin {
  final _formKey = new GlobalKey<FormState>();
  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();
  AnimationController rotationController;
  @override
  void initState() {
    rotationController = AnimationController(duration: const Duration(milliseconds: 10000),vsync: this);
    super.initState();
  }

  void sendData() async {
    rotationController.forward();
    setState(() {
      widget.loading = true;
    });
    String email = _emailController.text;
    String password = _passwordController.text;
    Map data = {"emailId": email, "password": password};
    await http
        .post(
            "https://us-central1-firestoredemo-bd9a8.cloudfunctions.net/registerUserWithEmailAndPassword",
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
      serverData serverResponse = serverData.fromJson(json.decode(response.body));
      print(serverResponse);
      if (serverResponse.status == 200) {
        setState(() {
          Navigator.of(context).pushReplacementNamed("/loginPage");
        });
      } else {
        showDialog(
            context: context,
            child: new AlertDialog(
              title: new Text("Register"),
              content: new Text(serverResponse.message),
            ));
      }

    });
  }

  @override
  Widget build(BuildContext context) {

    final logo_img = RotationTransition(
      child: new CircleAvatar(
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
      ),
      turns: Tween(begin: 0.0, end: 5.0).animate(rotationController),         // 0.174533 means rotate -10 deg
      alignment: FractionalOffset.center,
    );

    final email = Opacity(
        opacity: widget.loading==true ? 0.2 : 1,
        child:new Theme(
            data: new ThemeData(
              primaryColor: Colors.blue,
              primaryColorDark: Colors.white,
              hintColor: Colors.white,
            ),
            child: TextFormField(
              validator: (value) => value.isEmpty || value == null ? 'Email cannot be blank':null,
              style: new TextStyle(color: Colors.white),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              decoration: InputDecoration(
                  hintText: "Enter email",
                  contentPadding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0))),
            )));

    final password = new Theme(
        data: new ThemeData(
          primaryColor: Colors.blue,
          primaryColorDark: Colors.white,
          hintColor: Colors.white,
        ),
        child: Opacity(
            opacity: widget.loading==true ? 0.2 : 1,
            child: TextFormField(
              validator: (value) => value.isEmpty || value == null ? 'Password cannot be blank':null,
              style: new TextStyle(color: Colors.white),
              controller: _passwordController,
              autofocus: false,
              obscureText: true,
              decoration: InputDecoration(
                  hintText: "Enter password",
                  contentPadding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0))),
            )));
    final registerButton = Opacity(
        opacity: widget.loading==true ? 0.2 : 1,
        child: Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Material(
          borderRadius: BorderRadius.circular(20.0),
          shadowColor: Colors.black87,
          elevation: 5.0,
          color: Colors.cyan,
          child: MaterialButton(
            onPressed: (){
              if(_formKey.currentState.validate()) {
                sendData();
              }
            },
            child: Text(
              "Register",
              style: TextStyle(color: Colors.black),
            ),
          )),
    ));
    final loginText = MaterialButton(
      onPressed: () {
        Navigator.of(context).pushReplacementNamed("/loginPage");
      },
      child: Text("Back to Login.",
          style: new TextStyle( color: Colors.white)),
    );

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
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                    shrinkWrap: true,
                    children: <Widget>[
                      logo_img,
                      SizedBox(
                        height: 50,
                      ),
                      email,
                      SizedBox(
                        height: 30,
                      ),
                      password,
                      SizedBox(
                        height: 30,
                      ),
                      registerButton,
                      SizedBox(
                        height: 30,
                      ),
                      loginText
                    ],
                  )))),
        ]));
  }
}
