import 'package:duemak_heard/components/custom_surfix_icon.dart';
import 'package:duemak_heard/components/default_button.dart';
import 'package:duemak_heard/components/form_error.dart';
import 'package:duemak_heard/components/no_account_text.dart';
import 'package:duemak_heard/components/socal_card.dart';
import 'package:duemak_heard/constants.dart';
import 'package:duemak_heard/screens/Home_screen/home.dart';
import 'package:duemak_heard/screens/forgot_password/forgot_password_screen.dart';
import 'package:duemak_heard/screens/sign_in/sign_in_screen.dart';
import 'package:duemak_heard/utilities/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  late String email;
  late String password;
  bool remember = false;
  bool loading = false;

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
              resizeToAvoidBottomInset: true,
              body: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  // EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: size.height * 0.04),
                        Text(
                          "Welcome Back",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Sign in with your email and password  \nor continue with social media",
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: size.height * 0.08),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              buildEmailFormField(),
                              SizedBox(height: 30),
                              buildPasswordFormField(),
                              SizedBox(height: 30),
                              Row(
                                children: [
                                  Checkbox(
                                    value: remember,
                                    activeColor: kPrimaryColor,
                                    onChanged: (value) {
                                      setState(() {
                                        remember = value!;
                                      });
                                    },
                                  ),
                                  Text("Remember me"),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPasswordScreen(),
                                      ),
                                    ),
                                    child: Text(
                                      "Forgot Password",
                                      style: TextStyle(
                                          decoration: TextDecoration.underline),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        FormError(errors: errors),
                        SizedBox(height: 20),
                        DefaultButton(
                          text: "Continue",
                          press: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              // keyboardUtils.hideKeyboard(context);
                              FocusScope.of(context).requestFocus(FocusNode());

                              try {
                                setState(() {
                                  loading = true;
                                });

                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: email, password: password);

                                if (FirebaseAuth.instance.currentUser != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignInScreen(),
                                    ),
                                  );
                                }
                              } on FirebaseAuthException catch (e) {
                                loading = false;
                                print(e.toString());
                              }
                            }
                          },
                        ),
                        SizedBox(height: size.height * 0.08),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SocalCard(
                              icon: "assets/icons/google-icon.svg",
                              press: () {},
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
                        NoAccountText(),
                      ],
                    ),
                  ),
                ),
              ),
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
        return null;
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
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        focusedBorder: otpInputDecoration.focusedBorder,
        enabledBorder: otpInputDecoration.enabledBorder,
        errorBorder: otpInputDecoration.errorBorder,
        focusedErrorBorder: otpInputDecoration.focusedErrorBorder,
        labelText: "Email",
        hintText: "Enter your email",
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
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
    );
  }
}
