class FeedbackModel {
  final String id;
  final String userId;
  final String type;
  final String message;
  final DateTime timestamp;

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory FeedbackModel.fromMap(Map<String, dynamic> map, String docId) {
    return FeedbackModel(
      id: docId,
      userId: map['userId'] ?? '',
      type: map['type'] ?? '',
      message: map['message'] ?? '',
      timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
    );
  }
}
