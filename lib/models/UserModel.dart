class UserModel {
  UserModel({
    required this.status,
    required this.success,
    required this.messages,
    required this.users,
  });

  int status;
  bool success;
  String messages;
  List<User> users;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(
    status: json["status"],
    success: json["success"],
    messages: json["messages"] ?? "",
     users: List<User>.from(json["data"]["users"].map((x) => User.fromJson(x))),
   // users: List.empty()


  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "success": success,
    "messages": messages,
    "users":  List<dynamic>.from(users.map((x) => x.toJson())),
  };
}

class User {
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.createdAt,
    required this.profileImageUrl,
  });

  String id;
  String firstName;
  String lastName;
  String phoneNumber;
  DateTime createdAt;
  String profileImageUrl;

  factory User.fromJson(Map<String, dynamic> json) =>
      User(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        phoneNumber: json["phoneNumber"],
        profileImageUrl: json["profileImageUrl"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "profileImageUrl": profileImageUrl,
        "createdAt": createdAt.toIso8601String(),
      };
}
