// To parse this JSON data, do
//
//     final searchSuggestionResponse = searchSuggestionResponseFromJson(jsonString);

import 'dart:convert';

List<SearchSuggestionResponse> searchSuggestionResponseFromJson(String str) => List<SearchSuggestionResponse>.from(json.decode(str).map((x) => SearchSuggestionResponse.fromJson(x)));

String searchSuggestionResponseToJson(List<SearchSuggestionResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchSuggestionResponse {
  SearchSuggestionResponse({
    this.id,
    this.query,
    this.count,
    this.type,
    this.type_string,
  });

  int id;
  String query;
  int count;
  String type;
  String type_string;

  factory SearchSuggestionResponse.fromJson(Map<String, dynamic> json) => SearchSuggestionResponse(
    id: json["id"],
    query: json["query"],
    count: json["count"],
    type: json["type"],
    type_string: json["type_string"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "query": query,
    "count": count,
    "type": type,
    "type_string": type_string,
  };
}