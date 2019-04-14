import 'dart:ui';

import 'package:fitness_app_flutter/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart' show SystemChannels;


class Post {
  final int status;
  final String uid;
  final String token;
  Post({this.status, this.uid, this.token});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(status: json['status'], uid: json['message']['uid'],token: json['message']['token']);
  }
}

class Login extends StatefulWidget {
  bool loading = false;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginPageState();
  }
}

class _LoginPageState extends State<Login> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();

  void sendData() async {
    setState(() {
      widget.loading = true;

    });
    String email = _emailController.text;
    String password = _passwordController.text;
    Map data = {"emailId": email, "password": password};
    await http
        .post(
            "https://us-central1-firestoredemo-bd9a8.cloudfunctions.net/login",
            headers: {
              'Content-type': 'application/x-www-form-urlencoded',
              'Accept': 'application/json'
            },
            body: data)
        .then((response) {
          setState(() {
            widget.loading = false;
          });
      Post serverResponse = Post.fromJson(json.decode(response.body));
      print(serverResponse.token);
      if (serverResponse.status == 200) {
        setState(() {
          Navigator.push(context, new MaterialPageRoute(
            builder: (BuildContext context) => userHomeScreen(serverResponse: serverResponse)
          ));
        });
      } else {
        showDialog(
            context: context,
            child: new AlertDialog(
              title: new Text("Login"),
              content: new Text(serverResponse.uid),
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

    final email = Opacity(
      opacity: widget.loading==true ? 0.2 : 1,
    child:new Theme(
        data: new ThemeData(
          primaryColor: Colors.blue,
          primaryColorDark: Colors.white,
          hintColor: Colors.white,
        ),
        child: TextFormField(
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
    final loginButton = Opacity(
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
              "Login",
              style: TextStyle(color: Colors.black),
            ),
          )),
    ));
    final registrationText = MaterialButton(
      onPressed: () {
        Navigator.of(context).pushNamed("/registration");
      },
      child: Text("New User? Register Here",
          style: new TextStyle(color: Colors.white)),
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
                  child:new Container(
                          child:ListView(
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
                      loginButton,
                      SizedBox(
                        height: 30,
                      ),
                      registrationText,
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
                        child: Text('Please Wait...'),
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
