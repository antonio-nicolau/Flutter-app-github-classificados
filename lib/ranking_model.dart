import 'dart:convert';

List<RankingModel> rankingModelFromJson(String str) => List<RankingModel>.from(
    json.decode(str).map((x) => RankingModel.fromJson(x)));

class RankingModel {
  RankingModel({
    this.name,
    this.fullName,
    this.owner,
  });

  String name;
  String fullName;
  Owner owner;

  factory RankingModel.fromJson(Map<String, dynamic> json) => RankingModel(
        name: json["name"],
        fullName: json["full_name"],
        owner: Owner.fromJson(json["owner"]),
      );
}

class Owner {
  Owner({
    this.avatarUrl,
    this.repositorio,
  });

  String avatarUrl;
  String repositorio;

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        avatarUrl: json["avatar_url"],
        repositorio: json["html_url"],
      );
}
