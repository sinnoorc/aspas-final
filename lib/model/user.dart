class UserModel {
  String? uid;
  String? email;
  String? mobile;
  String? fullName;

  UserModel({this.uid, this.email, this.mobile, this.fullName});

  factory UserModel.frmMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      mobile: map['mobile'],
      fullName: map['fullName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'mobile': mobile,
      'fullName': fullName,
    };
  }
}
