// To parse this JSON data, do
//
//     final conversationCreateResponse = conversationCreateResponseFromJson(jsonString);

import 'dart:convert';

ConversationCreateResponse conversationCreateResponseFromJson(String str) => ConversationCreateResponse.fromJson(json.decode(str));

String conversationCreateResponseToJson(ConversationCreateResponse data) => json.encode(data.toJson());

class ConversationCreateResponse {
  ConversationCreateResponse({
    this.result,
    this.conversation_id,
    this.shop_name,
    this.title,
    this.shop_logo,
    this.message,
  });

  bool result;
  int conversation_id;
  String shop_name;
  String title;
  String shop_logo;
  String message;



  factory ConversationCreateResponse.fromJson(Map<String, dynamic> json) => ConversationCreateResponse(
    result: json["result"],
    conversation_id: json["conversation_id"],
    title: json["title"],
    shop_name: json["shop_name"],
    shop_logo: json["shop_logo"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "conversation_id": conversation_id,
    "shop_name": shop_name,
    "title": title,
    "shop_logo": shop_logo,
    "message": message,
  };
}