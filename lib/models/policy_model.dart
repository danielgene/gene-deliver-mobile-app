class PolicyModel {
  dynamic id;
  dynamic policyId;
  dynamic customerId;
  dynamic policyNumber;
  dynamic policyNo;
  dynamic customerName;
  dynamic invoiceNumber;
  dynamic paymentMethodId;
  dynamic amountDue;
  dynamic amountPaid;
  dynamic balance;
  dynamic datePosted;
  dynamic transactionReference;
  dynamic summaryDetailId;
  dynamic createdBy;
  dynamic vehicleId;
  dynamic registrationNumber;
  dynamic renewPolicyNumber;
  dynamic tenderedAmount;

  PolicyModel({
      this.id, 
      this.policyId, 
      this.customerId, 
      this.policyNumber, 
      this.policyNo, 
      this.customerName, 
      this.invoiceNumber, 
      this.paymentMethodId, 
      this.amountDue, 
      this.amountPaid, 
      this.balance, 
      this.datePosted, 
      this.transactionReference, 
      this.summaryDetailId, 
      this.createdBy, 
      this.vehicleId, 
      this.registrationNumber, 
      this.renewPolicyNumber, 
      this.tenderedAmount});

  PolicyModel.fromJson(dynamic json) {
    id = json["Id"];
    policyId = json["PolicyId"];
    customerId = json["CustomerId"];
    policyNumber = json["PolicyNumber"];
    policyNo = json["PolicyNo"];
    customerName = json["CustomerName"];
    invoiceNumber = json["InvoiceNumber"];
    paymentMethodId = json["PaymentMethodId"];
    amountDue = json["AmountDue"];
    amountPaid = json["AmountPaid"];
    balance = json["Balance"];
    datePosted = json["DatePosted"];
    transactionReference = json["TransactionReference"];
    summaryDetailId = json["SummaryDetailId"];
    createdBy = json["CreatedBy"];
    vehicleId = json["VehicleId"];
    registrationNumber = json["RegistrationNumber"];
    renewPolicyNumber = json["RenewPolicyNumber"];
    tenderedAmount = json["TenderedAmount"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Id"] = id;
    map["PolicyId"] = policyId;
    map["CustomerId"] = customerId;
    map["PolicyNumber"] = policyNumber;
    map["PolicyNo"] = policyNo;
    map["CustomerName"] = customerName;
    map["InvoiceNumber"] = invoiceNumber;
    map["PaymentMethodId"] = paymentMethodId;
    map["AmountDue"] = amountDue;
    map["AmountPaid"] = amountPaid;
    map["Balance"] = balance;
    map["DatePosted"] = datePosted;
    map["TransactionReference"] = transactionReference;
    map["SummaryDetailId"] = summaryDetailId;
    map["CreatedBy"] = createdBy;
    map["VehicleId"] = vehicleId;
    map["RegistrationNumber"] = registrationNumber;
    map["RenewPolicyNumber"] = renewPolicyNumber;
    map["TenderedAmount"] = tenderedAmount;
    return map;
  }

}