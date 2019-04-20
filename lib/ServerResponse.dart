class Post {
  final int status;
  final String userId;
  final String token;
  final String message;
  final bool info;
  Post({this.status, this.message, this.userId, this.token,this.info});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(status: json['status'], userId: json['message']['userId'],token: json['message']['token'], message: json['message']['message'], info: json['message']['info']);
  }
}