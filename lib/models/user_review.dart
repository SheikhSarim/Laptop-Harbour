class UserReview {
  final String userId;
  final String username;
  final double rating;
  final String reviewText;
  final DateTime date;

  UserReview({
    required this.userId,
    required this.username,
    required this.rating,
    required this.reviewText,
    required this.date,
  });

  // Convert to Firestore Map
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'rating': rating,
      'reviewText': reviewText,
      'date': date.toIso8601String(),
    };
  }

  // Create from Firestore Map
  factory UserReview.fromMap(Map<String, dynamic> map) {
    return UserReview(
      userId: map['userId'] ?? '',
      username: map['username'] ?? 'Anonymous',
      rating: map['rating']?.toDouble() ?? 0.0,
      reviewText: map['reviewText'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
    );
  }
}
