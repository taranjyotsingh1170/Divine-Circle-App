import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/wall_of_fame_members.dart';
//import '../providers/user.dart';

import '../widgets/app_drawer.dart';
import '../screens/edit_wall_of_fame_screen.dart';

class WallOfFame extends StatefulWidget {
  const WallOfFame({Key? key}) : super(key: key);

  static const routeName = '/wall-of-fame';

  @override
  State<WallOfFame> createState() => _WallOfFameState();
}

class _WallOfFameState extends State<WallOfFame> {
  bool newAppBar = false;
  String removeMemberId = '';
  bool isSelected = false;
  String existingSelectedMemberId = '';

  @override
  Widget build(BuildContext context) {
    final membersData = Provider.of<WallOfFameMembers>(context);

    return Scaffold(
      appBar: (newAppBar == false || membersData.selectedList.isEmpty)
          ? AppBar(
              title: Text(
                'Wall of Fame',
                style: GoogleFonts.inter(
                fontWeight: FontWeight.w500, color: Colors.white),
              ),
               iconTheme: Theme.of(context).iconTheme,
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(EditWallOfFameScreen.routeName);
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            )
          : AppBar(
              title: Text('${membersData.selectedList.length} selected'),
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () {
                    // print(removeMember);
                    membersData.deleteMember();
                    setState(() {
                      newAppBar = !newAppBar;
                    });
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3.2 / 2.8,
          crossAxisSpacing: 10,
          mainAxisSpacing: 5,
        ),
        itemBuilder: (context, index) => Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: InkWell(
                  splashColor: const Color(0xff134493),
                  onLongPress: () {
                    setState(
                      () {
                        isSelected = true;
                        newAppBar = true;
                        removeMemberId = membersData.membersList[index].id;
                        existingSelectedMemberId =
                            membersData.membersList[index].id;
                      },
                    );

                    //print(membersData.membersList[index].name);
                    // isSelected == true
                    //     ? membersData.addMemberInSelectedList(
                    //         User(
                    //           id: membersData.membersList[index].id,
                    //           name: membersData.membersList[index].name,
                    //           phoneNumber:
                    //               membersData.membersList[index].phoneNumber,
                    //           image: membersData.membersList[index].image,
                    //           designation:
                    //               membersData.membersList[index].designation,
                    //         ),
                    //         existingSelectedMemberId)
                    //     : null;
                    isSelected == true
                        ? membersData
                            .addMemberIDInSelectedList(existingSelectedMemberId)
                        : null;
                    // print(existingSelectedMemberId);
                    // print(membersData.selectedList.length);
                  },
                  onTap: () {
                    // setState(() {
                    //   newAppBar = false;
                    // });
                    if (membersData.selectedList.isEmpty) {
                      setState(() {
                        isSelected = false;
                      });
                    }
                    existingSelectedMemberId =
                        membersData.membersList[index].id;
                    // membersData.removeMemberFromSelectedList(
                    //   membersData.membersList[index].id,
                    // );
                    // print(membersData.selectedList.length);

                    //print(existingSelectedMemberId);
                    // isSelected == true
                    //     ? membersData.addMemberInSelectedList(
                    //         User(
                    //           id: membersData.membersList[index].id,
                    //           name: membersData.membersList[index].name,
                    //           phoneNumber:
                    //               membersData.membersList[index].phoneNumber,
                    //           image: membersData.membersList[index].image,
                    //           designation:
                    //               membersData.membersList[index].designation,
                    //         ),
                    //         existingSelectedMemberId)
                    //     : null;

                    isSelected == true
                        ? membersData
                            .addMemberIDInSelectedList(existingSelectedMemberId)
                        : null;
                  },
                  child: Container(
                    height: 130,
                    width: 130,
                    decoration: BoxDecoration(
                      //color: Colors.black,
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 4,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                        //radius: 30,
                        foregroundImage:
                            FileImage(membersData.membersList[index].image)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              membersData.membersList[index].name,
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            )
          ],
        ),
        itemCount: membersData.membersList.length,
      ),
      drawer: const AppDrawer(),
    );
  }
}
