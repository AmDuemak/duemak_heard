import 'package:duemak_heard/components/custom_surfix_icon.dart';
import 'package:duemak_heard/components/default_button.dart';
import 'package:duemak_heard/components/form_error.dart';
import 'package:duemak_heard/components/no_account_text.dart';
import 'package:duemak_heard/screens/sign_in/sign_in_screen.dart';
import 'package:duemak_heard/utilities/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  late String email;
  bool loading = false;

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error!);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading
        ? Loading()
        : Scaffold(
            body: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.04),
                      Text(
                        "Account Recovery",
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Please enter your email and check your email for password recovery link",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: size.height * 0.1),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (newValue) => email = newValue!,
                              onChanged: (value) {
                                if (value.isNotEmpty &&
                                    errors.contains(kEmailNullError)) {
                                  setState(() {
                                    errors.remove(kEmailNullError);
                                  });
                                } else if (emailValidatorRegExp
                                        .hasMatch(value) &&
                                    errors.contains(kInvalidEmailError)) {
                                  setState(() {
                                    errors.remove(kInvalidEmailError);
                                  });
                                }
                                email = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty &&
                                    !errors.contains(kEmailNullError)) {
                                  setState(() {
                                    errors.add(kEmailNullError);
                                  });
                                } else if (!emailValidatorRegExp
                                        .hasMatch(value) &&
                                    !errors.contains(kInvalidEmailError)) {
                                  setState(() {
                                    errors.add(kInvalidEmailError);
                                  });
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                focusedBorder: otpInputDecoration.focusedBorder,
                                enabledBorder: otpInputDecoration.enabledBorder,
                                errorBorder: otpInputDecoration.errorBorder,
                                focusedErrorBorder:
                                    otpInputDecoration.focusedErrorBorder,
                                labelText: "Email",
                                hintText: "Enter your email",
                                // If  you are using latest version of flutter then lable text and hint text shown like this
                                // if you r using flutter less then 1.20.* then maybe this is not working properly
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                suffixIcon: CustomSurffixIcon(
                                    svgIcon: "assets/icons/Mail.svg"),
                              ),
                            ),
                            SizedBox(height: 30),
                            FormError(errors: errors),
                            SizedBox(height: size.height * 0.1),
                            DefaultButton(
                              text: "Continue",
                              press: () async {
                                if (_formKey.currentState!.validate()) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  try {
                                    setState(() {
                                      loading = true;
                                    });
                                    await FirebaseAuth.instance
                                        .sendPasswordResetEmail(email: email);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignInScreen(),
                                      ),
                                    );
                                  } on FirebaseException catch (e) {
                                    if (e.code == "network-request-failed") {
                                      addError(
                                          error:
                                              "Check your internet connection");
                                    } else {
                                      addError(error: "an error occured");
                                    }
                                    print(e);
                                    setState(() {
                                      loading = false;
                                    });
                                  }
                                  setState(() {
                                    loading = false;
                                  });
                                }
                              },
                            ),
                            SizedBox(height: size.height * 0.1),
                            NoAccountText(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
