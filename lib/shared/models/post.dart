class Post {
  final String id;
  final String title;
  final String description;

  const Post({
    required this.id,
    required this.title,
    required this.description,
  });

  Post copyWith({String? id, String? title, String? description}) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      description: json['description'],
    );
  }
}
