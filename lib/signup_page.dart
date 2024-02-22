//import 'package:flutter/gestures.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mwasi_2/auth_controller.dart';
// import 'package:get/get.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    List images = [
      "g.png",
      "tw.png",
      "f.png",
    ];
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0x776F364A),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Container(
              width: w * 0.5,
              height: h * 0.3,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("img/logo.png"), fit: BoxFit.cover))),
          const Center(
              child: Text("Sign in to your account",
                  style: TextStyle(
                    fontFamily: 'arial',
                    fontSize: 25,
                    color: Colors.white60,
                    //color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ))),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            width: w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 7,
                              offset: Offset(1, 1),
                              color: Colors.grey.withOpacity(0.2))
                        ]),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          labelText: "E-mail",
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.pink,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30))),
                    )),
                SizedBox(
                  height: 20,
                ),
                Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 7,
                              offset: Offset(1, 1),
                              color: Colors.grey.withOpacity(0.2))
                        ]),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: "New password",
                          prefixIcon: Icon(
                            Icons.padding_outlined,
                            color: Colors.pink,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30))),
                    )),
                SizedBox(
                  height: 20,
                ),
                /*Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 7,
                              offset: Offset(1, 1),
                              color: Colors.grey.withOpacity(0.2))
                        ]),
                    child: TextField(
                      //controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: "Confirm password",
                          prefixIcon: Icon(
                            Icons.check_box_outlined,
                            color: Colors.pink,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30))),
                    ))*/
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          GestureDetector(
              onTap: () {
                AuthController.instance.register(emailController.text.trim(),
                    passwordController.text.trim());
              },
              child: Container(
                width: w * 0.5,
                height: h * 0.08,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: const DecorationImage(
                        image: AssetImage("img/loginbtn.png"),
                        fit: BoxFit.cover)),
                child: const Center(
                    child: Text(
                  "Sign up",
                  style: TextStyle(
                    fontFamily: 'HarlowSolidItalic',
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )),
              )),
          const SizedBox(
            height: 10,
          ),
          const Row(
            children: [
              Expanded(
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'or',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          /*RichText(
              text: TextSpan(
                  recognizer: TapGestureRecognizer()..onTap = () => Get.back(),
                  text: "Have an account ?",
                  style: TextStyle(fontSize: 20, color: Colors.grey[500]))),*/
          SizedBox(height: w * 0.06),
          RichText(
              text: TextSpan(
            text: "Sing up using one of the following methods",
            style: TextStyle(color: Colors.grey[500], fontSize: 16),
          )),
          Wrap(
            children: List<Widget>.generate(3, (index) {
              return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0XAAFD79A8),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage("img/" + images[index]),
                      )));
            }),
          )
        ],
      )),
    );
  }
}
