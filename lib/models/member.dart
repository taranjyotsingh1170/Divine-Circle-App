class Member {
  String id;
  String email;
  String name;
  int phoneNumber;
  //File image;
  //bool isMember;
  bool isInDesignTeam;
  bool isInContentTeam;
  bool isInPrTeam;
  bool isInKirtanTeam;
  bool isSelectedForDuty;
  bool isSelectedForGroupChat;

  Member({
    required this.id,
    required this.email,
    required this.name,
    required this.phoneNumber,
    this.isInDesignTeam = false,
    this.isInContentTeam = false,
    this.isInPrTeam = false,
    this.isInKirtanTeam = false,
    this.isSelectedForDuty = false,
    this.isSelectedForGroupChat = false,
  });
}
