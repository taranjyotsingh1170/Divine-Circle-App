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
      isInKirtanTeam: false);

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
      padding: const EdgeInsets.only(left: 15, top: 20),
      child: Text(
        head,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  void saveForm(context) async {
    final isValid = _formKey.currentState!.validate();

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

      Navigator.of(context).pushNamed(TabsScreen.routeName);
    } else if (_authmode == AuthMode.signup) {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _member.email, password: passController.text);

      final member = Provider.of<Members>(context, listen: false);

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
    return Scaffold(
      appBar: AppBar(
        title: Text(_authmode == AuthMode.login ? 'Login' : 'Signup',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w500, color: Colors.white)),
        iconTheme: Theme.of(context).iconTheme,
        //backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 90),
                    child: Text(
                      'Create Account',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _fieldHead('Enter email'),
                          SizedBox(
                            // padding: const EdgeInsets.symmetric(horizontal: 15),
                            // margin: const EdgeInsets.only(top: 10),
                            // decoration: BoxDecoration(
                            //   border: Border.all(color: Colors.grey),
                            //   borderRadius: BorderRadius.circular(30),
                            // ),
                            child: TextFormField(
                                decoration: const InputDecoration(
                                    //contentPadding: EdgeInsets.all(20),
                                    //labelText: 'Email',
                                    //border: InputBorder.none,
                                    ),
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
                              textCapitalization: TextCapitalization.sentences,
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
                          SizedBox(
                            // padding: const EdgeInsets.symmetric(horizontal: 15),
                            // margin: const EdgeInsets.only(top: 10),
                            // decoration: BoxDecoration(
                            //   border: Border.all(color: Colors.grey),
                            //   borderRadius: BorderRadius.circular(35),
                            // ),
                            child: TextFormField(
                              controller: passController,
                              obscureText: !_ispassVisible,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(20),
                                //labelText: 'Password',
                                //border: InputBorder.none,
                                suffixIcon: IconButton(
                                  icon: _ispassVisible
                                      ? const Icon(Icons.visibility_off_rounded)
                                      : const Icon(Icons.visibility_rounded),
                                  onPressed: () {
                                    setState(() {
                                      _ispassVisible = !_ispassVisible;
                                    });
                                  },
                                ),
                              ),
                              textCapitalization: TextCapitalization.sentences,
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
                          if (_authmode == AuthMode.login)
                            const SizedBox(
                              height: 220,
                            ),
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
                                      contentPadding: const EdgeInsets.all(20),
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
                                      } else if (value != passController.text) {
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
                ],
              ),
            ),
            if (_authmode == AuthMode.signup)
              const SizedBox(
                height: 110,
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                    primary: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 130, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _switchAuthMode();

                    setState(() {});

                    //print(_fadeTransition.status);
                    //print(_slideTransition.status);
                  },
                  child: Text(_authmode == AuthMode.login
                      ? 'Don\'t have an account? Signup'
                      : 'Already have an account? Login Instead'),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
