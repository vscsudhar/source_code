// To parse this JSON data, do
//
//     final messageResponse = messageResponseFromJson(jsonString);

import 'dart:convert';

MessageResponse messageResponseFromJson(String str) => MessageResponse.fromJson(json.decode(str));

String messageResponseToJson(MessageResponse data) => json.encode(data.toJson());

class MessageResponse {
  MessageResponse({
    this.data,
    this.success,
    this.status,
  });

  List<Message> data;
  bool success;
  int status;

  factory MessageResponse.fromJson(Map<String, dynamic> json) => MessageResponse(
    data: List<Message>.from(json["data"].map((x) => Message.fromJson(x))),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "success": success,
    "status": status,
  };
}

class Message {
  Message({
    this.id,
    this.userId,
    this.sendType,
    this.message,
    this.year,
    this.month,
    this.dayOfMonth,
    this.date,
    this.time,
  });

  int id;
  int userId;
  String sendType;
  String message;
  String year;
  String month;
  String dayOfMonth;
  String date;
  String time;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["id"],
    userId: json["user_id"],
    sendType: json["send_type"],
    message: json["message"],
    year: json["year"],
    month: json["month"],
    dayOfMonth: json["day_of_month"],
    date: json["date"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "send_type": sendType,
    "message": message,
    "year": year,
    "month": month,
    "day_of_month": dayOfMonth,
    "date": date,
    "time": time,
  };
}
