import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mwasi_2/auth_controller.dart';
//import 'package:get/get_core/src/get_main.dart';
import 'package:mwasi_2/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(
            height: 55,
          ),
          Container(
              width: w * 0.6,
              height: h * 0.35,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("img/logo.png"), fit: BoxFit.cover))),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            width: w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 35,
                ),
                const Center(
                    child: Text("Sign in to your account",
                        style: TextStyle(
                          fontFamily: 'arial',
                          fontSize: 25,
                          color: Color(0xAA6F364A),
                          //color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ))),
                const SizedBox(
                  height: 15,
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
                              offset: const Offset(1, 1),
                              color: const Color(0xAA6F364A).withOpacity(0.2))
                        ]),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.pink,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30))),
                    )),
                const SizedBox(
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
                              offset: const Offset(1, 1),
                              color: const Color(0xAA6F364A).withOpacity(0.2))
                        ]),
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: const Icon(
                            Icons.password,
                            color: Colors.pink,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30))),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    const Text(
                      "Forget your Password ?",
                      style: TextStyle(
                          fontSize: 17,
                          color: Color(0xAA6F364A),
                          decoration: TextDecoration.underline),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () {
              AuthController.instance.login(
                  emailController.text.trim(), passwordController.text.trim());
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
                "Sign in",
                style: TextStyle(
                  fontSize: 36,
                  fontFamily: 'HarlowSolidItalic',
                  color: Colors.white,
                ),
              )),
            ),
          ),
          SizedBox(height: w * 0.06),
          RichText(
              text: TextSpan(
                  text: "Don't have an account ?",
                  style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 20,
                      fontFamily: 'Rosemary'),
                  children: [
                TextSpan(
                    text: " Create",
                    style: const TextStyle(
                        color: Color(0xAA6F364A),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Get.to(() => const SignUpPage()))
              ]))
        ],
      )),
    );
  }
}
