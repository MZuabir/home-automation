class UserModel {
  final String name;
  final String email;
  final String image;
  final String? id;

  UserModel({
    required this.name,
    required this.email,
    required this.image,
    this.id,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? image,
    String? id,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      image: image ?? this.image,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'image': image,
      'id': id,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      image: json['image'],
      id: json['id'],
    );
  }
}
