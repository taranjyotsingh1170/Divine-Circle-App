import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ToDoListScreen extends StatelessWidget {
  const ToDoListScreen({Key? key}) : super(key: key);

  static const routeName = '/to-do-list-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do List',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w500, color: Colors.white)),
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0,
      ),
      
    );
  }
}
