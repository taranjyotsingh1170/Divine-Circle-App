import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({Key? key}) : super(key: key);

  static const routeName = '/to-do-list-screen';

  @override
  State<ToDoListScreen> createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  bool addNewTask = false;
  TextEditingController taskController = TextEditingController();

  void submit(String task, String currentUserName) {
    taskController.text = '';

    final docId = FirebaseFirestore.instance
        .collection('To-do List')
        .doc('tasks')
        .collection('Tasks')
        .doc()
        .id;

    try {
      FirebaseFirestore.instance
          .collection('To-do List')
          .doc('tasks')
          .collection('Tasks')
          .doc(docId)
          .set({
        'id': docId,
        'task': task,
        'task added on': DateTime.now(),
        'task added by': currentUserName,
        'isTaskCompleted': false,
        'task completed on': null,
      });

      setState(() {
        addNewTask = false;
      });
    } catch (error) {
      //print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (addNewTask == true && taskController.text.isEmpty) {
          setState(() {
            addNewTask = false;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('To Do List',
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500)),
          iconTheme: Theme.of(context).iconTheme,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('To-do List')
                        .doc('tasks')
                        .collection('Tasks')
                        .orderBy('task added on')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Text('');
                      }
                      return ListView.separated(
                          separatorBuilder: (ctx, index) => const SizedBox(
                                height: 20,
                              ),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (ctx, index) {
                            bool isTaskCompleted =
                                snapshot.data!.docs[index]['isTaskCompleted'];
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    FirebaseFirestore.instance
                                        .collection('To-do List')
                                        .doc('tasks')
                                        .collection('Tasks')
                                        .doc(snapshot.data!.docs[index]['id'])
                                        .update({'isTaskCompleted': true});

                                    FirebaseFirestore.instance
                                        .collection('To-do List')
                                        .doc('tasks')
                                        .collection('Completed Tasks')
                                        .doc(snapshot.data!.docs[index]['id'])
                                        .set({
                                      'id': snapshot.data!.docs[index]['id'],
                                      'task': snapshot.data!.docs[index]
                                          ['task'],
                                      'task added on': snapshot
                                          .data!.docs[index]['task added on'],
                                      'task added by': snapshot
                                          .data!.docs[index]['task added by'],
                                      'isTaskCompleted': true,
                                      'task completed on': DateTime.now(),
                                    });

                                    FirebaseFirestore.instance
                                        .collection('To-do List')
                                        .doc('tasks')
                                        .collection('Tasks')
                                        .doc(snapshot.data!.docs[index]['id'])
                                        .delete();
                                  },
                                  child: Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    child: isTaskCompleted
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.black,
                                          )
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  snapshot.data!.docs[index]['task'],
                                  style: GoogleFonts.inter(),
                                ),
                              ],
                            );
                          });
                    }),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (!addNewTask)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          addNewTask = !addNewTask;
                        });
                      },
                      child: const Text('Add new.....'),
                    ),
                  if (addNewTask)
                    Expanded(
                      child: SingleChildScrollView(
                        child: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: taskController,
                          onSubmitted: (task) {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .get()
                                .then((value) {
                              var fields = value.data();
                              var currentUserName = fields!['name'];
                              submit(task, currentUserName);
                              //print(currentUserName);
                            });
                          },
                        ),
                      ),
                    ),
                ],
              ),
              const Divider(height: 20),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('To-do List')
                        .doc('tasks')
                        .collection('Completed Tasks')
                        .orderBy('task completed on')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Text('');
                      }

                      return ListView.separated(
                          separatorBuilder: (ctx, index) =>
                              const SizedBox(height: 20),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (ctx, index) {
                            bool isTaskCompleted =
                                snapshot.data!.docs[index]['isTaskCompleted'];
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    FirebaseFirestore.instance
                                        .collection('To-do List')
                                        .doc('tasks')
                                        .collection('Completed Tasks')
                                        .doc(snapshot.data!.docs[index]['id'])
                                        .update({'isTaskCompleted': false});

                                    FirebaseFirestore.instance
                                        .collection('To-do List')
                                        .doc('tasks')
                                        .collection('Tasks')
                                        .doc(snapshot.data!.docs[index]['id'])
                                        .set({
                                      'id': snapshot.data!.docs[index]['id'],
                                      'task': snapshot.data!.docs[index]
                                          ['task'],
                                      'task added on': snapshot
                                          .data!.docs[index]['task added on'],
                                      'task added by': snapshot
                                          .data!.docs[index]['task added by'],
                                      'isTaskCompleted': false,
                                      'task completed on': null,
                                    });

                                    FirebaseFirestore.instance
                                        .collection('To-do List')
                                        .doc('tasks')
                                        .collection('Completed Tasks')
                                        .doc(snapshot.data!.docs[index]['id'])
                                        .delete();
                                  },
                                  child: Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    child: isTaskCompleted
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.grey,
                                          )
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  snapshot.data!.docs[index]['task'],
                                  style: GoogleFonts.inter(
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough),
                                ),
                              ],
                            );
                          });
                    }),
              ),
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   child: const Icon(Icons.add, size: 35),
        //   onPressed: () {},
        // ),
      ),
    );
  }
}
