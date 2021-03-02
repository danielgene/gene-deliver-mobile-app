class ConfirmationModel {
  dynamic id;
  dynamic deliveryId;
  String startAddress;
  String startLocation;
  String endAddress;
  String endLocation;
  String signatureFilePath;

  ConfirmationModel({
      this.id, 
      this.deliveryId, 
      this.startAddress, 
      this.startLocation, 
      this.endAddress, 
      this.endLocation, 
      this.signatureFilePath});

  ConfirmationModel.fromJson(dynamic json) {
    id = json["id"];
    deliveryId = json["deliveryId"];
    startAddress = json["startAddress"];
    startLocation = json["startLocation"];
    endAddress = json["endAddress"];
    endLocation = json["endLocation"];
    signatureFilePath = json["signatureFilePath"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["deliveryId"] = deliveryId;
    map["startAddress"] = startAddress;
    map["startLocation"] = startLocation;
    map["endAddress"] = endAddress;
    map["endLocation"] = endLocation;
    map["signatureFilePath"] = signatureFilePath;
    return map;
  }

}