import 'package:duemak_heard/components/custom_surfix_icon.dart';
import 'package:duemak_heard/components/default_button.dart';
import 'package:duemak_heard/components/form_error.dart';
import 'package:duemak_heard/components/socal_card.dart';
import 'package:duemak_heard/screens/Home_screen/home.dart';
import 'package:duemak_heard/utilities/loading.dart';
import 'package:duemak_heard/models/user_from_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();

  late String email;
  late String password;
  late String fname;
  late String lname;
  late String phone;
  late String userName;

  bool loading = false;
  late String conformPassword;
  bool remember = false;
  late String messo;

  final List<String> errors = [];

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
    return SafeArea(
      child: loading
          ? Loading()
          : Scaffold(
              body: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: size.height * 0.04), // 4%
                        Text("Register Account", style: headingStyle),
                        Text(
                          "Complete your details or continue \nwith social media",
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: size.height * 0.08),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              buildNameFormField(),
                              SizedBox(height: 30),
                              buildNameFormField2(),
                              SizedBox(height: 30),
                              buildUsernameFormField(),
                              SizedBox(height: 30),
                              buildPhoneFormField(),
                              SizedBox(height: 30),
                              buildEmailFormField(),
                              SizedBox(height: 30),
                              buildPasswordFormField(),
                              SizedBox(height: 30),
                              buildConformPassFormField(),
                            ],
                          ),
                        ),
                        FormError(errors: errors),
                        SizedBox(height: 40),
                        DefaultButton(
                          text: "Continue",
                          press: () async {
                            setState(() {
                              loading = true;
                            });
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              FocusScope.of(context).requestFocus(FocusNode());
                              try {
                                setState(() {
                                  loading = true;
                                });
                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: email, password: password);
                                await FirebaseAuth.instance.currentUser!
                                    .sendEmailVerification();

                                await userSetup(fname, lname, userName, phone);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                );
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'email-already-in-use') {
                                  messo =
                                      "User with the email you provided exists";
                                  MyDialog(context);
                                } else if (e.code == 'too-many-requests') {
                                  messo = "Too many attempts. Try again later.";
                                  MyDialog(context);
                                } else if (e.code == "network-request-failed") {
                                  messo = "Check your internet connection";
                                  MyDialog(context);
                                } else {
                                  messo = "an error occured";
                                  MyDialog(context);
                                }
                                print(e.toString());
                                setState(() {
                                  loading = false;
                                });
                              }
                              // if all are valid then go to success screen

                            } else {
                              setState(() {
                                loading = false;
                              });
                            }
                          },
                        ),
                        SizedBox(height: size.height * 0.08),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SocalCard(
                              icon: "assets/icons/google-icon.svg",
                              press: () async {
                                // FirebaseAuth.instance.
                              },
                            ),
                            SocalCard(
                              icon: "assets/icons/facebook-2.svg",
                              press: () {},
                            ),
                            SocalCard(
                              icon: "assets/icons/twitter.svg",
                              press: () {},
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          'By continuing your confirm that you agree \nwith our Term and Condition',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.caption,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  // ignore: non_constant_identifier_names
  Future<dynamic> MyDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Signing Up error"),
        content: Text(messo),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => conformPassword = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && password == conformPassword) {
          removeError(error: kMatchPassError);
        }
        conformPassword = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((password != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        focusedBorder: otpInputDecoration.focusedBorder,
        enabledBorder: otpInputDecoration.enabledBorder,
        errorBorder: otpInputDecoration.errorBorder,
        focusedErrorBorder: otpInputDecoration.focusedErrorBorder,
        labelText: "Confirm Password",
        hintText: "Re-enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        focusedBorder: otpInputDecoration.focusedBorder,
        enabledBorder: otpInputDecoration.enabledBorder,
        errorBorder: otpInputDecoration.errorBorder,
        focusedErrorBorder: otpInputDecoration.focusedErrorBorder,
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        focusedBorder: otpInputDecoration.focusedBorder,
        enabledBorder: otpInputDecoration.enabledBorder,
        errorBorder: otpInputDecoration.errorBorder,
        focusedErrorBorder: otpInputDecoration.focusedErrorBorder,
        labelText: "Email",
        hintText: "Enter your email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      onSaved: (newValue) => fname = newValue!,
      onChanged: (value) {
        fname = value;
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: "Name can't be empty");
          return "";
        }

        return null;
      },
      decoration: InputDecoration(
        focusedBorder: otpInputDecoration.focusedBorder,
        enabledBorder: otpInputDecoration.enabledBorder,
        errorBorder: otpInputDecoration.errorBorder,
        focusedErrorBorder: otpInputDecoration.focusedErrorBorder,
        labelText: "First Name",
        hintText: "Enter your First Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildNameFormField2() {
    return TextFormField(
      keyboardType: TextInputType.name,
      onSaved: (newValue) => lname = newValue!,
      onChanged: (value) {
        lname = value;
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: "Name can't be empty");
          return "";
        }

        return null;
      },
      decoration: InputDecoration(
        focusedBorder: otpInputDecoration.focusedBorder,
        enabledBorder: otpInputDecoration.enabledBorder,
        errorBorder: otpInputDecoration.errorBorder,
        focusedErrorBorder: otpInputDecoration.focusedErrorBorder,
        labelText: "Last Name",
        hintText: "Enter your Last Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildPhoneFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (newValue) => phone = newValue!,
      onChanged: (value) {
        phone = value;
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: "Phone number can't be empty");
          return "";
        }

        return null;
      },
      decoration: InputDecoration(
        focusedBorder: otpInputDecoration.focusedBorder,
        enabledBorder: otpInputDecoration.enabledBorder,
        errorBorder: otpInputDecoration.errorBorder,
        focusedErrorBorder: otpInputDecoration.focusedErrorBorder,
        labelText: "Phone Number",
        hintText: "Enter your Phone Number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildUsernameFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => userName = "@" + newValue!,
      onChanged: (value) {
        userName = "@" + value;
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: "Username can't be empty");
          return "";
        }

        return null;
      },
      decoration: InputDecoration(
        focusedBorder: otpInputDecoration.focusedBorder,
        enabledBorder: otpInputDecoration.enabledBorder,
        errorBorder: otpInputDecoration.errorBorder,
        focusedErrorBorder: otpInputDecoration.focusedErrorBorder,
        labelText: "Username",
        hintText: "Enter your Unique username",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
