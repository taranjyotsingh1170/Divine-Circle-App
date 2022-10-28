import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divine_circle/models/member.dart';
//import 'package:divine_circle/models/member_type.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
//import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/members.dart';
import '../providers/login.dart';

import '../screens/tabs_screen.dart';

//import '../screens/home_screen.dart';

enum AuthMode { login, signup }

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const routeName = '/login-screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authmode = AuthMode.login;
  late AnimationController _controller;
  late Animation<Offset> _slideTransition;
  late Animation<double> _fadeTransition;
  bool _ispasswordVisible = false;
  bool _ispassVisible = false;
  final passController = TextEditingController();
  final Member _member = Member(
      id: '',
      email: '',
      name: '',
      phoneNumber: 0,
      isInContentTeam: false,
      isInDesignTeam: false,
      isInPrTeam: false,
      isInKirtanTeam: false,
      isSelectedForDuty: false,
      isSelectedForGroupChat: false);

  //final _memberType = MemberType.normalMember;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();

    _slideTransition = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: const Offset(0, 0),
    ).animate(
      //_controller
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _fadeTransition = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      //_controller
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    //repeatOnce();
    // _fadeTransition =
    //     CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  // void repeatOnce() async {
  //   await _controller.forward();
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _switchAuthMode() {
    if (_authmode == AuthMode.login) {
      setState(() {
        _authmode = AuthMode.signup;
      });
    } else if (_authmode == AuthMode.signup) {
      setState(() {
        _authmode = AuthMode.login;
      });
    }
  }

  Widget _fieldHead(String head) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        head,
        style: GoogleFonts.inter(
            // fontWeight: FontWeight.w500,
            color: const Color(0xff54545A),
            fontSize: 15,
            letterSpacing: -0.5),
      ),
    );
  }

  void saveForm(context) async {
    final isValid = _formKey.currentState!.validate();
    final _login = Provider.of<Login>(context, listen: false);
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    if (_authmode == AuthMode.login) {
      try {
        FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _member.email, password: passController.text);
      } catch (error) {
        //print(error);
      }

      final User? userCredentials = FirebaseAuth.instance.currentUser;
      _login.storeTokenAndData(userCredentials);
      Navigator.of(context).pushNamed(TabsScreen.routeName);
    } else if (_authmode == AuthMode.signup) {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _member.email, password: passController.text);

      final member = Provider.of<Members>(context, listen: false);

      setSearchParameter(String userName) {
        List<String> caseSearchList = [];
        String temp = '';
        String lowerTemp = '';

        for (int i = 0; i < userName.length; i++) {
          temp = temp + userName[i];
          caseSearchList.add(temp);
          if (userName[i] == userName[i].toUpperCase()) {
            // print(eventTitle[i].toUpperCase());
            lowerTemp = lowerTemp + userName[i].toLowerCase();
            // print(eventTitle[i].toLowerCase());
            caseSearchList.add(lowerTemp);
          }
        }
        return caseSearchList;
      }

      try {
        final userId = userCredential.user!.uid;
        _member.id = userId;

        member.addMember(_member);
        FirebaseFirestore.instance.collection('users').doc(userId).set({
          'id': FirebaseAuth.instance.currentUser!.uid,
          'email id': _member.email,
          'name': _member.name,
          'Phone number': _member.phoneNumber,
          'isInDesignTeam': _member.isInDesignTeam,
          'isInContentTeam': _member.isInContentTeam,
          'isInPrTeam': _member.isInPrTeam,
          'isInKirtanTeam': _member.isInKirtanTeam,
          'isSelectedForDuty': _member.isSelectedForDuty,
          'isSelectedForGroupChat': _member.isSelectedForGroupChat,
          'case search': setSearchParameter(_member.name),
          //'member type': _memberType,
        });

        Navigator.of(context).pushNamed(TabsScreen.routeName);
      } catch (error) {
        return null;
      }
    }

    //Navigator.of(context).pushNamed(HomeScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(_authmode == AuthMode.login ? 'Login' : 'Signup',
      //       style: GoogleFonts.inter(
      //           fontWeight: FontWeight.w500, color: Colors.black)),
      //   iconTheme: Theme.of(context).iconTheme,
      //   //backgroundColor: Theme.of(context).primaryColor,
      //   elevation: 0,
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              SizedBox(height: deviceSize.height * 0.08),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 50,
                child: Image.asset('assets/images/11.png'),
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(vertical: deviceSize.height * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to Divine Circle!',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff333333),
                          fontSize: 25,
                          letterSpacing: -0.8),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Please enter your details to sign in',
                      style: GoogleFonts.inter(
                          // fontWeight: FontWeight.w500,
                          color: const Color(0xff54545A),
                          fontSize: 15,
                          letterSpacing: -0.5),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: deviceSize.height * 0.08),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldHead('Enter email'),
                            Container(
                              margin: EdgeInsets.only(
                                  top: deviceSize.height * 0.012),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey)),
                              child: TextFormField(
                                  decoration: const InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      //labelText: 'Email',
                                      border: InputBorder.none,
                                      suffixIcon: Icon(
                                        Icons.email_rounded,
                                        color: Colors.black,
                                      )),
                                  textInputAction: TextInputAction.next,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (email) {
                                    if (email!.isEmpty) {
                                      return '* required';
                                    }
                                    if (!EmailValidator.validate(email)) {
                                      return 'Enter a valid email address';
                                    }

                                    // else if (!value.contains('@')) {
                                    //   return 'Invalid email!';
                                    // }
                                    return null;
                                  },
                                  onSaved: (email) {
                                    _member.email = email!;
                                  }),
                            ),
                            if (_authmode == AuthMode.signup)
                              _fieldHead('Enter name'),
                            if (_authmode == AuthMode.signup)
                              TextFormField(
                                //obscureText: !_ispassVisible,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(20),
                                  //labelText: 'Password',
                                  //border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.text,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                validator: (name) {
                                  if (name!.isEmpty) {
                                    return '* required';
                                  }
                                  return null;
                                },
                                onSaved: (name) {
                                  _member.name = name!;
                                },
                              ),
                            if (_authmode == AuthMode.signup)
                              _fieldHead('Enter Phone number'),
                            if (_authmode == AuthMode.signup)
                              TextFormField(
                                //obscureText: !_ispassVisible,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(20),
                                  //labelText: 'Password',
                                  //border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.phone,
                                validator: (number) {
                                  if (number!.isEmpty) {
                                    return '* required';
                                  }
                                  return null;
                                },
                                onSaved: (number) {
                                  _member.phoneNumber = int.parse(number!);
                                },
                              ),
                            _fieldHead('Enter password'),
                            Container(
                              margin: EdgeInsets.only(
                                  top: deviceSize.height * 0.012),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextFormField(
                                controller: passController,
                                obscureText: !_ispassVisible,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 10),
                                  //labelText: 'Password',
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(
                                    icon: _ispassVisible
                                        ? const Icon(
                                            Icons.visibility_off_rounded)
                                        : const Icon(Icons.visibility_rounded),
                                    onPressed: () {
                                      setState(() {
                                        _ispassVisible = !_ispassVisible;
                                      });
                                    },
                                  ),
                                ),
                                textCapitalization:
                                    TextCapitalization.sentences,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  // FlutterPwValidator(
                                  //   width: 400,
                                  //   height: 150,
                                  //   minLength: 6,
                                  //   numericCharCount: 1,
                                  //   specialCharCount: 1,
                                  //   onSuccess: () {},
                                  //   controller: passController,
                                  // );
                                  if (value!.isEmpty) {
                                    return '* required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            // if (_authmode == AuthMode.login)
                            //   SizedBox(height: deviceSize.height * 0.01),
                            if (_authmode == AuthMode.signup)
                              FadeTransition(
                                opacity: _fadeTransition,
                                child: SlideTransition(
                                  position: _slideTransition,
                                  child: _fieldHead('Re-enter password'),
                                ),
                              ),
                            if (_authmode == AuthMode.signup)
                              FadeTransition(
                                opacity: _fadeTransition,
                                child: SlideTransition(
                                  position: _slideTransition,
                                  child: AnimatedContainer(
                                    //curve: Curves.easeIn,
                                    duration: const Duration(seconds: 2),
                                    // padding: const EdgeInsets.symmetric(
                                    //     horizontal: 15),
                                    // margin: const EdgeInsets.only(top: 10),
                                    // decoration: BoxDecoration(
                                    //   border: Border.all(color: Colors.grey),
                                    //   borderRadius: BorderRadius.circular(35),
                                    // ),
                                    child: TextFormField(
                                      enabled: _authmode == AuthMode.signup,
                                      obscureText: !_ispasswordVisible,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(20),
                                        //labelText: 'Re-enter password',
                                        //border: InputBorder.none,
                                        suffixIcon: IconButton(
                                          icon: _ispasswordVisible
                                              ? const Icon(
                                                  Icons.visibility_off_rounded)
                                              : const Icon(
                                                  Icons.visibility_rounded),
                                          onPressed: () {
                                            setState(() {
                                              _ispasswordVisible =
                                                  !_ispasswordVisible;
                                            });
                                          },
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return '* required';
                                        } else if (value !=
                                            passController.text) {
                                          return 'Password does not match';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (_authmode == AuthMode.login)
                      Column(
                        children: [
                          SizedBox(height: deviceSize.height * 0.022),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot Password?',
                              style: GoogleFonts.inter(
                                  // fontWeight: FontWeight.w500,
                                  color: const Color(0xff405c8c),
                                  fontSize: 16,
                                  letterSpacing: -0.5),
                            ),
                            style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(0)),
                          ),
                          // SizedBox(height: deviceSize.height * 0.022),
                        ],
                      ),
                  ],
                ),
              ),
              // if (_authmode == AuthMode.login) const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {
                  saveForm(context);
                },
                child: Text(
                  _authmode == AuthMode.login ? 'Login' : 'Signup',
                  style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff405c8c),
                  padding: EdgeInsets.symmetric(
                      vertical: 10, horizontal: deviceSize.width * 0.35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: deviceSize.height * 0.08),
              TextButton(
                onPressed: () {
                  _switchAuthMode();
                  setState(() {});
                },
                child: Text(
                  _authmode == AuthMode.login
                      ? 'Don\'t have an account? Sign Up here'
                      : 'Already have an account? Login Instead',
                  style: GoogleFonts.inter(
                      // fontWeight: FontWeight.w500,
                      color: const Color(0xff405c8c),
                      fontSize: 16,
                      letterSpacing: -0.5),
                ),
                // style: TextButton.styleFrom(
                //                 padding: const EdgeInsets.all(0)),
              ),
              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}
