class DeliveryModel {
  int id;
  String customerFirstName;
  String customerLastName;
  String addressLine1;
  String addressLine2;
  String city;
  String phoneNumber;
  String policyID;
  String policyTransactionDate;
  dynamic policyAmount;
  dynamic agentName;
  dynamic zoneAreaID;
  dynamic startTime;
  dynamic endTime;
  String ownerId;
  int jobStatus;

  DeliveryModel({
      this.id, 
      this.customerFirstName, 
      this.customerLastName, 
      this.addressLine1, 
      this.addressLine2, 
      this.city, 
      this.phoneNumber, 
      this.policyID, 
      this.policyTransactionDate, 
      this.policyAmount, 
      this.agentName, 
      this.zoneAreaID, 
      this.startTime, 
      this.endTime, 
      this.ownerId, 
      this.jobStatus});

  DeliveryModel.fromJson(dynamic json) {
    id = json["id"];
    customerFirstName = json["customerFirstName"];
    customerLastName = json["customerLastName"];
    addressLine1 = json["addressLine1"];
    addressLine2 = json["addressLine2"];
    city = json["city"];
    phoneNumber = json["phoneNumber"];
    policyID = json["policyID"];
    policyTransactionDate = json["policyTransactionDate"];
    policyAmount = json["policyAmount"];
    agentName = json["agentName"];
    zoneAreaID = json["zoneAreaID"];
    startTime = json["startTime"];
    endTime = json["endTime"];
    ownerId = json["ownerId"];
    jobStatus = json["jobStatus"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["customerFirstName"] = customerFirstName;
    map["customerLastName"] = customerLastName;
    map["addressLine1"] = addressLine1;
    map["addressLine2"] = addressLine2;
    map["city"] = city;
    map["phoneNumber"] = phoneNumber;
    map["policyID"] = policyID;
    map["policyTransactionDate"] = policyTransactionDate;
    map["policyAmount"] = policyAmount;
    map["agentName"] = agentName;
    map["zoneAreaID"] = zoneAreaID;
    map["startTime"] = startTime;
    map["endTime"] = endTime;
    map["ownerId"] = ownerId;
    map["jobStatus"] = jobStatus;
    return map;
  }

}