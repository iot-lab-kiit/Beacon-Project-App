// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    User({
        this.role,
        this.purchases,
        this.id,
        this.name,
        this.email,
        this.password,
        this.address,
        this.wallet,
        this.v,
    });

    String role;
    List<dynamic> purchases;
    String id;
    String name;
    String email;
    String password;
    String address;
    List<dynamic> wallet;
    int v;

    factory User.fromJson(Map<String, dynamic> json) => User(
        role: json["role"] == null ? null : json["role"],
        purchases: json["purchases"] == null ? null : List<dynamic>.from(json["purchases"].map((x) => x)),
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        password: json["password"] == null ? null : json["password"],
        address: json["address"] == null ? null : json["address"],
        wallet: json["wallet"] == null ? null : List<dynamic>.from(json["wallet"].map((x) => x)),
        v: json["__v"] == null ? null : json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "role": role == null ? null : role,
        "purchases": purchases == null ? null : List<dynamic>.from(purchases.map((x) => x)),
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "password": password == null ? null : password,
        "address": address == null ? null : address,
        "wallet": wallet == null ? null : List<dynamic>.from(wallet.map((x) => x)),
        "__v": v == null ? null : v,
    };
}
