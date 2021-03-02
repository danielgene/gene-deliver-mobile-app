class SearchResultModel {
  String customerName;
  String vehicleRegNumber;
  String policyNumber;
  int policyId;

  SearchResultModel(
      {this.customerName,
      this.vehicleRegNumber,
      this.policyNumber,
      this.policyId});

  SearchResultModel.fromJson(dynamic json) {
    customerName = json["CustomerName"];
    vehicleRegNumber = json["vehicleRegNumber"];
    policyNumber = json["PolicyNumber"];
    policyId = json["policyId"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["CustomerName"] = customerName;
    map["vehicleRegNumber"] = vehicleRegNumber;
    map["PolicyNumber"] = policyNumber;
    map["policyId"] = policyId;
    return map;
  }
}
