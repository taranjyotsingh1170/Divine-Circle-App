import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_authmode == AuthMode.login ? 'Login' : 'Signup'),
        backgroundColor: Theme.of(context).primaryColor,
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
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _fieldHead('Enter email'),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(20),
                                //labelText: 'Email',
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '* required';
                                } else if (!value.contains('@')) {
                                  return 'Invalid email!';
                                }
                                return null;
                              },
                            ),
                          ),
                          _fieldHead('Enter password'),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: TextFormField(
                              controller: passController,
                              obscureText: !_ispassVisible,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(20),
                                //labelText: 'Password',
                                border: InputBorder.none,
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
                              keyboardType: TextInputType.text,
                              validator: (value) {
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  margin: const EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  child: TextFormField(
                                    enabled: _authmode == AuthMode.signup,
                                    obscureText: !_ispasswordVisible,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(20),
                                      //labelText: 'Re-enter password',
                                      border: InputBorder.none,
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
                  onPressed: () {},
                  child: Text(
                    _authmode == AuthMode.login ? 'Login' : 'Signup',
                    style: const TextStyle(fontSize: 20),
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
