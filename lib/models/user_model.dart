class UserModel {
  String _id;
  String _firstName;
  String _lastName;
  String _accountType;
  bool _active;
  String _phoneNumber;
  bool _hasZone;

  String get id => _id;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get accountType => _accountType;
  bool get active => _active;
  String get phoneNumber => _phoneNumber;
  bool get hasZone => _hasZone;

  UserModel({
      String id, 
      String firstName, 
      String lastName, 
      String accountType, 
      bool active, 
      String phoneNumber, 
      bool hasZone}){
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _accountType = accountType;
    _active = active;
    _phoneNumber = phoneNumber;
    _hasZone = hasZone;
}

  UserModel.fromJson(dynamic json) {
    _id = json["id"];
    _firstName = json["firstName"];
    _lastName = json["lastName"];
    _accountType = json["accountType"];
    _active = json["active"];
    _phoneNumber = json["phoneNumber"];
    _hasZone = json["hasZone"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["firstName"] = _firstName;
    map["lastName"] = _lastName;
    map["accountType"] = _accountType;
    map["active"] = _active;
    map["phoneNumber"] = _phoneNumber;
    map["hasZone"] = _hasZone;
    return map;
  }

}