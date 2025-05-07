enum Author { human, ai }
enum ChatMessageStatus { pending, success, failed }

class ChatMessage {

  final String id;
  final String text;
  final Author author;
  final DateTime createdAt;
  final ChatMessageStatus status;

  ChatMessage({
    required this.id,
    required this.text,
    required this.author,
    required this.createdAt,
    this.status = ChatMessageStatus.pending,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      text: json['text'],
      author: Author.values.byName(json['author']),
      createdAt: DateTime.parse(json['createdAt']),
      status: ChatMessageStatus.success,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'author': author.name,
      'createdAt': createdAt.toIso8601String(),
      'status': status.name,
    };
  }

  ChatMessage copyWith({
    String? id,
    String? text,
    Author? author,
    DateTime? createdAt,
    ChatMessageStatus? status,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      author: author ?? this.author,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, text: $text, senderId: $author, createdAt: $createdAt, status: $status)';
  }
}