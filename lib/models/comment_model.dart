class CommentModel {
  dynamic id;
  dynamic deliveryID;
  String callTime;
  String comment;

  CommentModel(this.id, this.deliveryID, this.callTime, this.comment);

  CommentModel.fromJson(dynamic json) {
    id = json['id'];
    deliveryID = json['deliveryID'];
    callTime = json['callTime'];
    comment = json['comment'];
  }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = new Map<String, dynamic>();
//   data['id'] = this.id;
//
//   data['deliveryID'] = this.deliveryID;
//   data['callTime'] = this.callTime;
//   data['comment'] = this.comment;
//   return data;
// }
}
